import 'package:flutter/material.dart';

import '../bma/server_com.dart';
import '../commons/slide_page_route.dart';
import '../widgets/gradient_btn.dart';
import '../widgets/region_selector.dart';
import 'auth_info_screen.dart';
import 'recover_auth_screen.dart';

class MethodSelectionPage extends StatelessWidget {
  const MethodSelectionPage({Key key}) : super(key: key);

  Widget _btnFactory(
    final BuildContext context,
    final IconData icon,
    final Gradient gradient,
    final Widget routeWidget,
    final String text,
  ) {
    return GradientButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          SlidePageRoute<AuthInfoPage>(
            widget: routeWidget,
          ),
        );
      },
      gradient: gradient,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
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
              Icons.add,
              LinearGradient(colors: <Color>[
                Colors.teal[800],
                Colors.teal[600],
                Colors.tealAccent[700],
                Colors.greenAccent[400],
              ]),
              AuthInfoPage(() {
                return createAuthenticator(RegionSelector.getRegion(context));
              }),
              'Create new authenticator',
            ),
            _btnFactory(
              context,
              Icons.replay,
              LinearGradient(colors: <Color>[
                Colors.deepPurple[800],
                Colors.deepPurple,
                Colors.redAccent[400],
                Colors.redAccent,
              ]),
              RecoverAuthPage(),
              'Recover an authenticator',
            ),
            const RegionSelector(),
          ],
        ),
      ),
    );
  }
}
