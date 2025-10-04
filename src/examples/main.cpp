/**
 * @file main.cpp
 * @brief Entry point for the GUI application.
 *
 * This file defines the main entry point for the GUI application, handling both
 * Windows and non-Windows platforms. It includes platform-specific macros and
 * logic to ensure the correct entry function is used depending on the build environment.
 *
 * - On Windows (MSVC), it defines and uses either `WinMain` or `wWinMain` as the entry point,
 *   depending on whether Unicode is enabled.
 * - On other platforms, it uses the standard `main` function.
 *
 * The actual application logic is delegated to `main_impl()` defined elsewhere.
 *
 * @include sample/gui_app/main_impl.h
 * @include spdlog/spdlog.h
 */

#include <imgui_ready/main_impl.h>
#include <spdlog/spdlog.h>

#ifdef __cplusplus
#define SC_BEGIN_EXTERN_C \
  extern "C"              \
  {
#define SC_END_EXTERN_C }
#else
#define SC_BEGIN_EXTERN_C
#define SC_END_EXTERN_C
#endif

#if defined(_MSC_VER)

#if defined(UNICODE) && UNICODE
#define SC_WIN_UNICODE
#endif

#include <windows.h>

#ifdef SC_WIN_UNICODE
#define SCWinMain                      \
  int WINAPI wWinMain(HINSTANCE hInst, \
                      HINSTANCE hPrev, \
                      PWSTR szCmdLine, \
                      int sw)
#else
#define SCWinMain                     \
  int WINAPI WinMain(HINSTANCE hInst, \
                     HINSTANCE hPrev, \
                     LPSTR szCmdLine, \
                     int sw)
#endif

SC_BEGIN_EXTERN_C

SCWinMain
{

  int argc;
  LPWSTR *argv = CommandLineToArgvW(GetCommandLineW(), &argc);
  int nResult = main_impl(argc,agrv);
  if (argv != 0)
  {
    LocalFree(argv);
  }
}

SC_END_EXTERN_C

#else
int main(int argc, const char *argv[])
{
  return main_impl(argc, argv);
}
#endif
