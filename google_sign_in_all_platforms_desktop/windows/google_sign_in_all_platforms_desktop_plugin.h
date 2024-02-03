#ifndef FLUTTER_PLUGIN_GOOGLE_SIGN_IN_ALL_PLATFORMS_DESKTOP_PLUGIN_H_
#define FLUTTER_PLUGIN_GOOGLE_SIGN_IN_ALL_PLATFORMS_DESKTOP_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace google_sign_in_all_platforms_desktop {

class GoogleSignInAllPlatformsDesktopPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  GoogleSignInAllPlatformsDesktopPlugin();

  virtual ~GoogleSignInAllPlatformsDesktopPlugin();

  // Disallow copy and assign.
  GoogleSignInAllPlatformsDesktopPlugin(const GoogleSignInAllPlatformsDesktopPlugin&) = delete;
  GoogleSignInAllPlatformsDesktopPlugin& operator=(const GoogleSignInAllPlatformsDesktopPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace google_sign_in_all_platforms_desktop

#endif  // FLUTTER_PLUGIN_GOOGLE_SIGN_IN_ALL_PLATFORMS_DESKTOP_PLUGIN_H_
