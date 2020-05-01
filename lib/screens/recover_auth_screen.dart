import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bma/server_com.dart';
import '../custom_routes/slide_page_route.dart';
import '../input_text_formatters/serial_text_formatter.dart';
import '../input_text_formatters/uppercase_text_formatter.dart';
import '../scoped_models/region_model.dart';
import '../widgets/gradient_btn.dart';
import '../widgets/region_selector.dart';
import 'auth_info_screen.dart';

class RecoverAuthPage extends StatelessWidget {
  RecoverAuthPage({Key key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController restoreCodeController = TextEditingController();

  void submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Navigator.push(
        context,
        SlidePageRoute<AuthInfoPage>(
          widget: AuthInfoPage(
            () => restore(
              serialController.text,
              restoreCodeController.text,
              RegionModel.of(context).region,
            ),
          ),
        ),
      );
    }
  }

  TextFormField _textFormFieldFactory(
    TextEditingController controller,
    String name,
    int requiredLength,
    BuildContext context,
    List<TextInputFormatter> inputFormatters,
  ) {
    return TextFormField(
      autofocus: true,
      autocorrect: false,
      decoration: InputDecoration(hintText: 'Enter a $name here.'),
      controller: controller,
      inputFormatters: inputFormatters,
      validator: (String value) {
        if (value.length < requiredLength) {
          return 'Please completly fill in the $name.';
        }
        return null;
      },
      onFieldSubmitted: (String _) => submit(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
        child: GradientButton.icon(
          onPressed: () => Navigator.pop(context),
          gradient: const LinearGradient(colors: <Color>[
            Color(0xff000000),
            Color(0xff434343),
          ]),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          label: const Text(
            'Back',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(80),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _textFormFieldFactory(
                serialController,
                'serial',
                17,
                context,
                <TextInputFormatter>[
                  UppercaseTextFormatter(),
                  WhitelistingTextInputFormatter(RegExp(r'[A-Z0-9\-]')),
                  SerialTextFormatter(),
                  // _SerialTextFormatter(),
                ],
              ),
              _textFormFieldFactory(
                restoreCodeController,
                'restore-code',
                10,
                context,
                <TextInputFormatter>[
                  UppercaseTextFormatter(),
                  WhitelistingTextInputFormatter(RegExp('[A-Z0-9]')),
                  BlacklistingTextInputFormatter(RegExp('[IOLS]')),
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const RegionSelector(),
                  const SizedBox(width: 20),
                  GradientButton(
                    onPressed: () => submit(context),
                    gradient: const LinearGradient(colors: <Color>[
                      Colors.blue,
                      Colors.indigo,
                    ]),
                    child: const Text(
                      'next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
