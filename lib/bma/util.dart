import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

/// Will trim any whitespace, remove dashes and uppercase it
/// Do trimming first, to catch dashes intercepting the padding
String normalizeSerial(String serial) {
  return serial.trim().replaceAll('-', '').toUpperCase();
}

Uint8List uint8ListFromString(String str) {
  return Uint8List.fromList(const Utf8Codec().encode(str));
}

Uint8List doOneTimePadDecryption(Uint8List cipherText, Uint8List key) {
  final Uint8List plainText = Uint8List(cipherText.length);
  for (int i = 0; i < cipherText.length; i++) {
    plainText[i] = cipherText[i] ^ key[i];
  }
  return plainText;
}

Uint8List randomUint8List(int length) {
  final Random random = Random();

  final Uint8List communicationKey = Uint8List(length);
  for (int i = 0; i < communicationKey.length; i++) {
    communicationKey[i] = random.nextInt(256);
  }

  return communicationKey;
}
