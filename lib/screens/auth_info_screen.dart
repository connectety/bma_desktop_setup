import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../bma/authenticator.dart';
import '../widgets/custom_loading_indicator.dart';
import '../widgets/gradient_btn.dart';

class AuthInfoPage extends StatelessWidget {
  const AuthInfoPage(this._authBuilder, {Key? key}) : super(key: key);

  final Future<Authenticator> Function() _authBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: backBtnFactory(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(80),
          child: FutureBuilder<Authenticator>(
            future: _authBuilder(),
            builder: (
              BuildContext context,
              AsyncSnapshot<Authenticator> snapshot,
            ) {
              if (snapshot.hasData) {
                return _AuthInfo(snapshot.data!);
              } else if (snapshot.hasError) {
                return _ErrorInfo(snapshot.error);
              } else {
                return const CustomLoadingIndicator(color: Colors.black);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _AuthInfo extends StatelessWidget {
  const _AuthInfo(this._auth, {Key? key}) : super(key: key);

  final Authenticator _auth;

  @override
  Widget build(BuildContext context) {
    const TextStyle defaultStyle = TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    );
    final TextStyle boldTextStyle = defaultStyle.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: QrImage(
            data: _auth.totpUrl,
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Serial: ',
            style: boldTextStyle,
            children: <TextSpan>[
              TextSpan(text: _auth.serialNumber, style: defaultStyle),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Restore-Code: ',
            style: boldTextStyle,
            children: <TextSpan>[
              TextSpan(text: _auth.restoreCode, style: defaultStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorInfo extends StatelessWidget {
  const _ErrorInfo(this._error, {Key? key}) : super(key: key);

  final Object? _error;

  @override
  Widget build(BuildContext context) {
    const TextStyle defaultStyle = TextStyle(color: Colors.red);
    final TextStyle boldTextStyle = defaultStyle.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.warning,
          size: 40,
          color: Colors.grey[800],
        ),
        Text(
          'An unexpected error occurred:',
          style: boldTextStyle,
        ),
        Text(_error.toString(), style: defaultStyle),
      ],
    );
  }
}
