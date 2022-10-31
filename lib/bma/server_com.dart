import 'dart:convert';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart';

import 'authenticator.dart';
import 'constants.dart';
import 'util.dart';

Future<Authenticator> createAuthenticator(String region) async {
  final Uint8List communicationKey = randomUint8List(37);

  final Uint8List defaultRegionBytes = uint8ListFromString(region);
  final Uint8List defaultMobileModelBytes = uint8ListFromString(
    defaultMobileModel,
  );

  final Uint8List requestData = Uint8List.fromList(
    <int>[1] + communicationKey + defaultRegionBytes + defaultMobileModelBytes,
  );

  final RSAEngine rsaEngine = RSAEngine()..init(true, asyncKeyParam);
  final Uint8List encryptedRequestData = rsaEngine.process(requestData);

  // http instead of https because their certificate is invalid
  final http.Response response = await http.post(
    Uri.http(hosts[region]!, enrollUrl),
    body: encryptedRequestData,
  );

  if (response.statusCode != 200) {
    throw http.ClientException(
      'Initialization request returned HTTP error ${response.statusCode}',
    );
  }

  assert(response.bodyBytes.length == 45, 'enroll body not 32 bytes long');

  final Uint8List responseBody = response.bodyBytes.sublist(8);
  final Uint8List plainData = doOneTimePadDecryption(
    responseBody,
    communicationKey,
  );

  final String secretKey = base32.encode(plainData.sublist(0, 20));
  final String serial = utf8.decode(plainData.sublist(20, 37));

  return Authenticator(secretKey, serial);
}

Future<Authenticator> restore(
  String serial,
  String restoreCode,
  String region,
) async {
  final String serialNormed = normalizeSerial(serial);
  final String restoreCodeNormed = restoreCode.toUpperCase();

  assert(restoreCodeNormed.length == 10, 'restore code not 10 chars long');

  final Uint8List serialBytes = uint8ListFromString(serialNormed);

  // http instead of https because their certificate is invalid
  final Future<http.Response> challengeFuture = http.post(
    Uri.http(hosts[region]!, initiateRestoreUrl),
    body: serialNormed,
  );

  final Uint8List bytes = Uint8List.fromList(
      uint8ListFromString(restoreCodeNormed)
          .map((int char) => char2byte[char]).toList()
  );

  final http.Response challenge = await challengeFuture;

  if (challenge.statusCode != 200) {
    throw http.ClientException(
      'Initialization request returned HTTP error ${challenge.statusCode}',
    );
  }

  assert(
    challenge.bodyBytes.length == 32,
    'restore initiation body not 32 bytes long',
  );

  final Uint8List hmacData = Uint8List.fromList(
    uint8ListFromString(serialNormed) + challenge.bodyBytes,
  );

  final HMac hmac = HMac(SHA1Digest(), 64)..init(KeyParameter(bytes));
  final Uint8List hash = hmac.process(hmacData);

  final Uint8List otp = randomUint8List(20);
  final Uint8List rsaData = Uint8List.fromList(hash + otp);

  final RSAEngine rsaEngine = RSAEngine()..init(true, asyncKeyParam);
  final Uint8List encryptedData = rsaEngine.process(rsaData);

  final Uint8List data = Uint8List.fromList(serialBytes + encryptedData);

  // http instead of https because their certificate is invalid
  final http.Response validateResponse = await http.post(
    Uri.http(hosts[region]!, validateRestoreUrl),
    body: data,
  );

  if (validateResponse.statusCode == 600) {
    throw http.ClientException('Invalid serial or restore key');
  } else if (validateResponse.statusCode != 200) {
    throw http.ClientException(
      'Initialization request returned HTTP error '
      '${validateResponse.statusCode}',
    );
  }

  assert(
    validateResponse.bodyBytes.length == 20,
    'validation response not 20 chars long',
  );

  final Uint8List secretBytes = doOneTimePadDecryption(
    validateResponse.bodyBytes,
    otp,
  );
  final String secretKey = base32.encode(secretBytes);

  return Authenticator(secretKey, serial);
}
