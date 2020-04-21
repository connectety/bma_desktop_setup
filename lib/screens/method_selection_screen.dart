import 'package:flutter/material.dart';

import '../bma/server_com.dart';
import '../custom_routes/slide_page_route.dart';
import '../widgets/region_selector.dart';
import 'auth_info_screen.dart';
import 'recover_auth_screen.dart';

class MethodSelectionPage extends StatelessWidget {
  const MethodSelectionPage({Key key}) : super(key: key);

  OutlineButton _btnFactory(
    final BuildContext context,
    final Widget routeWidget,
    final String text,
  ) {
    return OutlineButton(
      onPressed: () {
        Navigator.push(
          context,
          SlidePageRoute<AuthInfoPage>(
            widget: routeWidget,
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      borderSide: const BorderSide(
        color: Colors.purple,
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _btnFactory(
              context,
              AuthInfoPage(() {
                return createAuthenticator(RegionSelector.getRegion(context));
              }),
              'Create new authenticator',
            ),
            _btnFactory(
              context,
              const RecoverAuthPage(),
              'Recover an authenticator',
            ),
            const RegionSelector(),
          ],
        ),
      ),
    );
  }
}
