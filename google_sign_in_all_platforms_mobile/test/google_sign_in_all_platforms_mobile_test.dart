import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_mobile/google_sign_in_all_platforms_mobile.dart';
import 'package:google_sign_in_all_platforms_mobile/google_sign_in_all_platforms_mobile_platform_interface.dart';
import 'package:google_sign_in_all_platforms_mobile/google_sign_in_all_platforms_mobile_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGoogleSignInAllPlatformsMobilePlatform
    with MockPlatformInterfaceMixin
    implements GoogleSignInAllPlatformsMobilePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GoogleSignInAllPlatformsMobilePlatform initialPlatform = GoogleSignInAllPlatformsMobilePlatform.instance;

  test('$MethodChannelGoogleSignInAllPlatformsMobile is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGoogleSignInAllPlatformsMobile>());
  });

  test('getPlatformVersion', () async {
    GoogleSignInAllPlatformsMobile googleSignInAllPlatformsMobilePlugin = GoogleSignInAllPlatformsMobile();
    MockGoogleSignInAllPlatformsMobilePlatform fakePlatform = MockGoogleSignInAllPlatformsMobilePlatform();
    GoogleSignInAllPlatformsMobilePlatform.instance = fakePlatform;

    expect(await googleSignInAllPlatformsMobilePlugin.getPlatformVersion(), '42');
  });
}
