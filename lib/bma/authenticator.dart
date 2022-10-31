import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:pointycastle/export.dart';

import 'constants.dart';
import 'util.dart';

class Authenticator {
  Authenticator(this._secretKey, this._serialNumber);

  final String _secretKey;
  final String _serialNumber;

  String get secretKey => _secretKey;

  String get serialNumber => _serialNumber;

  String get totpUrl => 'otpauth://totp/Blizzard:$serialNumber'
      '?secret=$secretKey&issuer=Blizzard&digits=8';

  String get restoreCode {
    final Uint8List secretKeyBytes = base32.decode(_secretKey);
    final List<int> serialBytes = utf8.encode(normalizeSerial(_serialNumber));

    final Uint8List data = Uint8List.fromList(serialBytes + secretKeyBytes);

    final Digest sha1 = SHA1Digest();
    Uint8List digest = sha1.process(data);
    digest = digest.sublist(digest.length - 10);

    final List<int> charCodes = digest.map((int i) {
      final int byte = i & 0x1f;
      return byte2char[byte];
    }).toList();

    return String.fromCharCodes(charCodes);
  }
}
