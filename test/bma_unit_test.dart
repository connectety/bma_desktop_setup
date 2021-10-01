import 'package:bma_desktop_setup/bma/authenticator.dart';
import 'package:bma_desktop_setup/bma/server_com.dart';
import 'package:test/test.dart';

void main() {
  const String serial = 'EU-2004-1327-3070';
  const String secret = 'PQUUHNLZIWGAOKECSSDG7BWEWHZVQEZX';
  const String restoreCode = 'GNF5YE1JBH';
  const String region = 'EU';

  test('create new authenticator', () async {
    final Authenticator auth = await createAuthenticator(region);

    // ignore: avoid_print
    print('bma.Authenticator serial number: ${auth.serialNumber}');
    // ignore: avoid_print
    print('bma.Authenticator secret key: ${auth.secretKey}');
    // ignore: avoid_print
    print('bma.Authenticator restore code: ${auth.restoreCode}');
  });

  test('create restore code', () {
    final Authenticator auth = Authenticator(secret, serial);
    expect(auth.restoreCode, restoreCode);
  });

  test('restore authenticator', () async {
    final Authenticator auth = await restore(serial, restoreCode, region);
    expect(auth.secretKey, secret);
  });

  test('run full lifecycle', () async {
    final Authenticator auth = await createAuthenticator(region);

    final Authenticator restoredAuth =
      await restore(auth.serialNumber, auth.restoreCode, region);

    expect(auth.totpUrl, restoredAuth.totpUrl);
  });
}
