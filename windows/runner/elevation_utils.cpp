#include "elevation_utils.h"
#include <iostream>
#include <shlobj.h>
#include <shellapi.h>

#pragma comment(lib, "shell32.lib")

bool ElevationUtils::IsRunningAsAdmin() {
  BOOL is_admin = FALSE;
  PSID admin_group = nullptr;
  SID_IDENTIFIER_AUTHORITY nt_authority = SECURITY_NT_AUTHORITY;

  if (AllocateAndInitializeSid(
          &nt_authority,
          2,
          SECURITY_BUILTIN_DOMAIN_RID,
          DOMAIN_ALIAS_RID_ADMINS,
          0, 0, 0, 0, 0, 0,
          &admin_group)) {

    if (!CheckTokenMembership(nullptr, admin_group, &is_admin)) {
      is_admin = FALSE;
    }

    FreeSid(admin_group);
  }

  return is_admin == TRUE;
}

bool ElevationUtils::IsUACEnabled() {
  HKEY key;
  LONG result = RegOpenKeyExW(
      HKEY_LOCAL_MACHINE,
      L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System",
      0,
      KEY_READ,
      &key);

  if (result != ERROR_SUCCESS) {
    return true;
  }

  DWORD value = 0;
  DWORD value_size = sizeof(DWORD);
  result = RegQueryValueExW(
      key,
      L"EnableLUA",
      nullptr,
      nullptr,
      reinterpret_cast<LPBYTE>(&value),
      &value_size);

  RegCloseKey(key);

  if (result != ERROR_SUCCESS) {
    return true;
  }

  return value != 0;
}

bool ElevationUtils::RequestElevation() {
  if (IsRunningAsAdmin()) {
    return true;
  }

  std::wstring exe_path = GetExecutablePath();
  if (exe_path.empty()) {
    std::cerr << "Failed to get executable path" << std::endl;
    return false;
  }

  SHELLEXECUTEINFOW sei = { sizeof(sei) };
  sei.lpVerb = L"runas";
  sei.lpFile = exe_path.c_str();
  sei.hwnd = nullptr;
  sei.nShow = SW_NORMAL;

  if (!ShellExecuteExW(&sei)) {
    DWORD error = GetLastError();
    if (error == ERROR_CANCELLED) {
      std::cout << "User cancelled elevation request" << std::endl;
    } else {
      std::cerr << "ShellExecuteEx failed with error: " << error << std::endl;
    }
    return false;
  }

  return true;
}

std::wstring ElevationUtils::GetExecutablePath() {
  wchar_t path[MAX_PATH];
  DWORD length = GetModuleFileNameW(nullptr, path, MAX_PATH);

  if (length == 0 || length == MAX_PATH) {
    return std::wstring();
  }

  return std::wstring(path);
}
