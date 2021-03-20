import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:pointycastle/export.dart';

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
    final Uint8List serialBytes =
      utf8.encode(normalizeSerial(_serialNumber)) as Uint8List;

    final Uint8List data = Uint8List.fromList(serialBytes + secretKeyBytes);

    final Digest sha1 = SHA1Digest();
    Uint8List digest = sha1.process(data);
    digest = digest.sublist(digest.length - 10);

    final List<int> charCodes = <int>[];
    for (final int i in digest) {
      int c = i & 0x1f;

      if (c < 10) {
        c += 48;
      } else {
        c += 55;
        // I
        if (c > 72) {
          c += 1;
        }
        // L
        if (c > 75) {
          c += 1;
        }
        // O
        if (c > 78) {
          c += 1;
        }
        // S
        if (c > 82) {
          c += 1;
        }
      }

      charCodes.add(c);
    }

    return String.fromCharCodes(charCodes);
  }
}
