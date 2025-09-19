import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class CodeChallenge {
  final String codeVerifier;
  late final String codeChallenge;
  final int byteLength;

  CodeChallenge([this.byteLength = 32])
      : codeVerifier = _generateCodeVerifier(byteLength) {
    codeChallenge = _generateCodeChallenge(codeVerifier);
  }

  static String _generateCodeVerifier(int byteLength) {
    final rand = Random.secure();
    final bytes = List<int>.generate(byteLength, (_) => rand.nextInt(256));
    return _b64UrlNoPadding(bytes);
  }

  static String _b64UrlNoPadding(List<int> bytes) =>
      base64Url.encode(bytes).replaceAll('=', '');

  static String _generateCodeChallenge(String codeVerifier) {
    final bytes = ascii.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return _b64UrlNoPadding(digest.bytes);
  }
}
