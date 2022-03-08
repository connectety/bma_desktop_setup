import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bma/server_com.dart';
import '../commons/gradient_input_border.dart';
import '../commons/slide_page_route.dart';
import '../input_text_formatters/serial_text_formatter.dart';
import '../input_text_formatters/uppercase_text_formatter.dart';
import '../scoped_models/region_model.dart';
import '../widgets/gradient_btn.dart';
import '../widgets/region_selector.dart';
import 'auth_info_screen.dart';

class RecoverAuthPage extends StatelessWidget {
  RecoverAuthPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController restoreCodeController = TextEditingController();

  void submit(BuildContext context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
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

  Widget _textFormFieldFactory(
    TextEditingController controller,
    String name,
    String example,
    int requiredLength,
    BuildContext context,
    List<TextInputFormatter> inputFormatters,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        border: const GradientInputBorder(
          gradient: LinearGradient(
            colors: <Color>[
              // Colors are easy thanks to Flutter's Colors class.
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
        fillColor: Colors.grey[300],
        hintText: 'Enter a $name here.',
      ),
      controller: controller,
      inputFormatters: inputFormatters,
      validator: (String? value) {
        if (value != null && value.length < requiredLength) {
          return 'Please completely fill in the $name. (e.g. $example)';
        }
        return null;
      },
      onFieldSubmitted: (String _) => submit(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: backBtnFactory(context),
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
                'AB-1234-1234-1234',
                17,
                context,
                <TextInputFormatter>[
                  UppercaseTextFormatter(),
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\-]')),
                  SerialTextFormatter(),
                  // _SerialTextFormatter(),
                ],
              ),
              const SizedBox(height: 20),
              _textFormFieldFactory(
                restoreCodeController,
                'restore-code',
                'ABCDE12345',
                10,
                context,
                <TextInputFormatter>[
                  UppercaseTextFormatter(),
                  FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                  FilteringTextInputFormatter.deny(RegExp('[IOLS]')),
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
                      'Next',
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
