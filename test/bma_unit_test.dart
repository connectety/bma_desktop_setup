import 'package:setup4bmatotp/bma/authenticator.dart';
import 'package:setup4bmatotp/bma/server_com.dart';
import 'package:test/test.dart';

void main() {
  const String serial = 'EU-2004-1327-3070';
  const String secret = 'PQUUHNLZIWGAOKECSSDG7BWEWHZVQEZX';
  const String restoreCode = 'GNF5YE1JBH';
  const String region = 'EU';

  test('can run authenticator', () async {
    final Authenticator auth = await createAuthenticator(region);

    // ignore: avoid_print
    print('bma.Authenticator serial number: ${auth.serialNumber}');
    // ignore: avoid_print
    print('bma.Authenticator secret key: ${auth.secretKey}');
    // ignore: avoid_print
    print('bma.Authenticator restore code: ${auth.restoreCode}');
  });

  test('test restore', () {
    final Authenticator auth = Authenticator(secret, serial);
    expect(auth.restoreCode, restoreCode);
  });

  test('can restore authenticator', () async {
    final Authenticator auth = await restore(serial, restoreCode, region);
    expect(auth.secretKey, secret);
  });
}
