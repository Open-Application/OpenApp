#ifndef RUNNER_ELEVATION_UTILS_H_
#define RUNNER_ELEVATION_UTILS_H_

#include <windows.h>
#include <string>

class ElevationUtils {
 public:
  static bool IsRunningAsAdmin();
  static bool IsUACEnabled();
  static bool RequestElevation();

  static std::wstring GetExecutablePath();
};

#endif
