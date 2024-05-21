#!/usr/bin/env bash
set -eu

# Get the directory containing this script
dir=${0%/*}
cd $dir

target="invalid"

fatal_error() {
  echo "Error: $1"
  exit 1
}

print_help() {
  echo "USAGE: $0 [target] [options]"
  echo "Valid Targets:"
  echo "  - raddbg: builds the debugger itself (default)"
  echo "Valid options:"
  echo "  - debug: builds the target in debug mode (default)"
  echo "  - release: builds the target in release mode"
  echo "  - telemetry: build with Telemetry profiler hooks enabled"
  echo "  - asan: enables the address sanitizer"
  echo "  - no_meta: skips running the metaprogram"
}


if [[ $# < 1 ]]; then
  echo "[default mode, assuming \`raddbg\` build]"
  target="raddbg"
else
  case $1 in
  raddbg)
    target="raddbg"
    ;;
  help)
    print_help
    exit
    ;;
  *)
    fatal_error "'$1' is not a valid build target! (run \`$0 help\` for a list of valid build targets)"
    ;;
  esac
fi

build_profile="debug"
use_telemetry="0"
use_asan="0"
run_meta="1"

for((i=2; i < $#; i+=1));
do
  case $i in
  debug)
    build_profile="debug"
    ;;
  release)
    build_profile="release"
    ;;
  telemetry)
    use_telemetry="1"
    ;;
  asan)
    use_asan="1"
    ;;
  no_meta)
    run_meta="1"
    ;;
  *)
    fatal_error "'$i' is not a valid build flag! (run \`$0 help\` for a list of valid build flags)"
    ;;
  esac
done

clang_cpp_standard="-std=c++11"
clang_common_args="-I../src -I../local -maes -mssse3 -msse4 -gcodeview -fdiagnostics-absolute-paths -Wall -Wno-missing-braces -Wno-unused-function -Wno-writable-strings -Wno-unused-value -Wno-unused-variable -Wno-unused-local-typedef -Wno-deprecated-register -Wno-deprecated-declarations -Wno-unused-but-set-variable -Wno-single-bit-bitfield-constant-conversion -Xclang -flto-visibility-public-std -D_USE_MATH_DEFINES -Dstrdup=_strdup -Dgnu_printf=prtintf"
if [[ use_telemetry == "1" ]]; then
  clang_common_args="$clang_common_args -DPROFILE_TELEMETRY=1"
  echo "[telemetry profiling enabled]"
fi
if [[ use_asan == "1" ]]; then
  clang_common_args="$clang_common_args -fsanitize=address"
  echo "[asan enabled]"
fi

clang_debug_args="-g -O0 -D_DEBUG $clang_common_args"
clang_release_args="-g -O3 -DNDEBUG $clang_common_args"

gfx="-DOS_FEATURE_GRAPHICAL=1"
net="-DOS_FEATURE_SOCKET"

clang_build_args=""

case $build_profile in
"debug")
  echo "[debug mode]"
  clang_build_args=$clang_debug_args
  ;;
"release")
  echo "[release mode]"
  clang_build_args=$clang_release_args
  ;;
*)
  fatal_error "Unsupported build profile: '$build_profile'"
  ;;
esac


# Build everything
mkdir -p build

pushd build
if [[ $run_meta == "1" ]]; then
  clang $clang_build_args ../src/metagen/metagen_main.c -o metagen
  ./metagen
fi

case $target in
"raddbg")
  clang $clang_build_args $gfx $clang_cpp_standard ../src/raddbg/raddbg_main.cpp -o raddbg
  ;;
*)
  fatal_error "Unsupported build target: '$target'"
  ;;
esac

popd
