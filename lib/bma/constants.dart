import 'package:pointycastle/export.dart';

import 'util.dart';

const Map<String, String> hosts = <String, String>{
  'CN': 'mobile-service.battlenet.com.cn',
  'US': 'mobile-service.blizzard.com',
  'EU': 'mobile-service.blizzard.com',
  'default': 'mobile-service.blizzard.com',
};

const String enrollUrl = '/enrollment/enroll.htm';
const String initiateRestoreUrl = '/enrollment/initiatePaperRestore.htm';
const String validateRestoreUrl = '/enrollment/validatePaperRestore.htm';

const String defaultMobileModel = 'Motorola RAZR v3';

final BigInt _modulus = BigInt.parse(
  '1048900188079865568740077109142054431570301596680341971861256789602874708942'
  '9083053061828494311840511089632283544909943323209315116825015214602331932649'
  '1587651685252774820340995950744075665455681760652136576493028733914892166700'
  '8991098362911808810630974611756439983563219936638682333667053407581025677424'
  '83097',
);
final BigInt _pow = BigInt.from(257);

final AsymmetricKeyParameter<RSAPublicKey> asyncKeyParam =
    PublicKeyParameter<RSAPublicKey>(
  RSAPublicKey(_modulus, _pow),
);

final List<int> byte2char = List<int>
    .generate(10 + 23, byte2charGen);

final List<int> char2byte = List<int>
    .generate('Z'.codeUnitAt(0) + 1, (int index) => byte2char.indexOf(index));
