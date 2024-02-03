#include "include/google_sign_in_all_platforms_desktop/google_sign_in_all_platforms_desktop_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "google_sign_in_all_platforms_desktop_plugin.h"

void GoogleSignInAllPlatformsDesktopPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  google_sign_in_all_platforms_desktop::GoogleSignInAllPlatformsDesktopPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
