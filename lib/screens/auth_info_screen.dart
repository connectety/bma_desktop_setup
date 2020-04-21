import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../bma/authenticator.dart';

class AuthInfoPage extends StatelessWidget {
  const AuthInfoPage(this._authBuilder, {Key key}) : super(key: key);

  final Future<Authenticator> Function() _authBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: Colors.grey,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back'),
        ),
      ),
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
                return _AuthInfo(snapshot.data);
              } else if (snapshot.hasError) {
                return _ErrorInfo(snapshot.error);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _AuthInfo extends StatelessWidget {
  const _AuthInfo(this._auth, {Key key}) : super(key: key);

  final Authenticator _auth;

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultStyle = DefaultTextStyle.of(context).style;
    final TextStyle boldTextStyle = defaultStyle.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        QrImage(
          data: _auth.totpURl,
          version: QrVersions.auto,
          size: 200,
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
  const _ErrorInfo(this._error, {Key key}) : super(key: key);

  final Object _error;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.warning,
          size: 40,
          color: Colors.grey[800],
        ),
        const Text(
          'An unexpected Error okured:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        Text(
          _error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
