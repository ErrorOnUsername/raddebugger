////////////////////////////////
//~ rd: Backend Implementations

fp_hook void
fp_init(void)
{
  ProfBeginFunction();
  ProfEndFunction();
}

fp_hook FP_Handle
fp_font_open(String8 path)
{
  ProfBeginFunction();
  NotImplemented;
  ProfEndFunction();
  return fp_handle_zero();
}

fp_hook FP_Handle
fp_font_open_from_static_data_string(String8 *data_ptr)
{
  ProfBeginFunction();
  NotImplemented;
  ProfEndFunction();
  return fp_handle_zero();
}

fp_hook void
fp_font_close(FP_Handle handle)
{
  ProfBeginFunction();
  NotImplemented;
  ProfEndFunction();
}

fp_hook FP_Metrics
fp_metrics_from_font(FP_Handle font)
{
  ProfBeginFunction();
  NotImplemented;
  ProfEndFunction();
  return { 0 };
}

fp_hook NO_ASAN FP_RasterResult
fp_raster(Arena *arena, FP_Handle font, F32 size, FP_RasterMode mode, String8 string)
{
  ProfBeginFunction();
  NotImplemented;
  ProfEndFunction();
  return { 0 };
}