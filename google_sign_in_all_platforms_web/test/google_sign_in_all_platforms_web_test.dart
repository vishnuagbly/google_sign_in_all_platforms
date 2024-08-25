import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_web/google_sign_in_all_platforms_web.dart';
import 'package:google_sign_in_all_platforms_web/google_sign_in_all_platforms_web_platform_interface.dart';
import 'package:google_sign_in_all_platforms_web/google_sign_in_all_platforms_web_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGoogleSignInAllPlatformsWebPlatform
    with MockPlatformInterfaceMixin
    implements GoogleSignInAllPlatformsWebPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GoogleSignInAllPlatformsWebPlatform initialPlatform = GoogleSignInAllPlatformsWebPlatform.instance;

  test('$MethodChannelGoogleSignInAllPlatformsWeb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGoogleSignInAllPlatformsWeb>());
  });

  test('getPlatformVersion', () async {
    GoogleSignInAllPlatformsWeb googleSignInAllPlatformsWebPlugin = GoogleSignInAllPlatformsWeb();
    MockGoogleSignInAllPlatformsWebPlatform fakePlatform = MockGoogleSignInAllPlatformsWebPlatform();
    GoogleSignInAllPlatformsWebPlatform.instance = fakePlatform;

    expect(await googleSignInAllPlatformsWebPlugin.getPlatformVersion(), '42');
  });
}
