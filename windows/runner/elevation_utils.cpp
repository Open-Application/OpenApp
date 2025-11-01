#include "elevation_utils.h"
#include <iostream>
#include <shlobj.h>
#include <shellapi.h>
#include <mutex>

#pragma comment(lib, "shell32.lib")


static bool g_admin_check_cached = false;
static bool g_is_admin = false;
static std::mutex g_admin_check_mutex;

bool ElevationUtils::IsRunningAsAdmin() {
  std::lock_guard<std::mutex> lock(g_admin_check_mutex);

  if (g_admin_check_cached) {
    return g_is_admin;
  }

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


  g_is_admin = (is_admin == TRUE);
  g_admin_check_cached = true;

  return g_is_admin;
}


static bool g_uac_check_cached = false;
static bool g_uac_enabled = true;
static std::mutex g_uac_check_mutex;

bool ElevationUtils::IsUACEnabled() {
  std::lock_guard<std::mutex> lock(g_uac_check_mutex);
  if (g_uac_check_cached) {
    return g_uac_enabled;
  }

  HKEY key;
  LONG result = RegOpenKeyExW(
      HKEY_LOCAL_MACHINE,
      L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System",
      0,
      KEY_READ,
      &key);

  if (result != ERROR_SUCCESS) {
    g_uac_enabled = true;
    g_uac_check_cached = true;
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
    g_uac_enabled = true;
    g_uac_check_cached = true;
    return true;
  }

  g_uac_enabled = (value != 0);
  g_uac_check_cached = true;

  return g_uac_enabled;
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
