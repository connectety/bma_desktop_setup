import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bma/server_com.dart';
import '../custom_routes/slide_page_route.dart';
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
          onPressed: () =>  Navigator.pop(context),
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
                  _UppercaseTextFormatter(),
                  WhitelistingTextInputFormatter(RegExp(r'[A-Z0-9\-]')),
                  _SerialTextFormatter(),
                  // _SerialTextFormatter(),
                ],
              ),
              _textFormFieldFactory(
                restoreCodeController,
                'restore-code',
                10,
                context,
                <TextInputFormatter>[
                  _UppercaseTextFormatter(),
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

class _UppercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _SerialTextFormatter extends TextInputFormatter {
  TextEditingValue _tryInsertDash(TextEditingValue value, int index) {
    // if there is a dash behind the index, do nothing
    if (value.text.substring(index, index + 1) == '-') {
      return value;
    }

    TextSelection selection = value.selection;

    if (index < selection.end) {
      selection = selection.copyWith(extentOffset: selection.end + 1);
    }

    if (index < selection.start) {
      selection = selection.copyWith(baseOffset: selection.start + 1);
    }

    return TextEditingValue(
      selection: selection,
      text: '${value.text.substring(0, index)}-${value.text.substring(index)}',
    );
  }

  TextEditingValue _tryRemoveDash(TextEditingValue value, int index) {
    // if there isn't a dash at the index, do nothing
    if (index >= value.text.length ||
        value.text.substring(index, index + 1) != '-') {
      return value;
    }

    TextSelection selection = value.selection;

    if (index < selection.start) {
      selection = selection.copyWith(baseOffset: selection.start - 1);
    }

    if (index < selection.end) {
      selection = selection.copyWith(extentOffset: selection.end - 1);
    }

    return TextEditingValue(
      selection: selection,
      text:
          '${value.text.substring(0, index)}${value.text.substring(index + 1)}',
    );
  }

  RegExpMatch getFirstMatch(TextEditingValue value, String regex) {
    final Iterable<RegExpMatch> regionMatches =
        RegExp(regex).allMatches(value.text);
    return regionMatches.isNotEmpty ? regionMatches.first : null;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextEditingValue editedValue = newValue;

    // finds all uppercase letters aka region
    final RegExpMatch region = getFirstMatch(newValue, '[A-Z]+');

    /*
    REGEX-EXPLANATION:
    - \d makes sure matches start with digits
    - [\-\d]* is any combination of digits and dashes, these are followed up by
    - the \d at the start makes sure that not a pure - is matched
     */
    RegExpMatch digits = getFirstMatch(newValue, r'\d[\-\d]*');

    // if there are region letters and digits try inserting a dash
    if (region != null && digits != null) {
      editedValue = _tryInsertDash(editedValue, region.end);

      digits = getFirstMatch(editedValue, r'\d[\-\d]*');
    }

    if (digits != null) {
      int digitAmount = 0;

      for (int i = digits.start; i < digits.end; i++) {
        final String digit = editedValue.text.substring(i, i + 1);
        if (digit != '-') {
          digitAmount++;
        }

        bool nextIsDigit = false;
        if (i + 1 < editedValue.text.length) {
          final String nextDigit = editedValue.text.substring(i + 1, i + 2);
          if (nextDigit != '-') {
            nextIsDigit = true;
          }
        }

        if (digitAmount == 4) {
          if (nextIsDigit) {
            editedValue = _tryInsertDash(editedValue, i + 1);
          }
          digits = getFirstMatch(editedValue, r'\d[\-\d]*');

          digitAmount = 0;
        } else {
          editedValue = _tryRemoveDash(editedValue, i + 1);
          digits = getFirstMatch(editedValue, r'\d[\-\d]*');
        }
      }
    }

    /*
    REGEX-EXPLANATION:
    - It starts with ^ and end with $ to only allow full matches.
    - [A-Z]{0,2} so that the region can not be fully filled and only matches
      uppercase letters with a maximum of 2 length-
    - "-?" because the dashes is also optional.
    - \d{1,4}- so one has to fill in digits to use the dash
      this prevent multiple dashes behind each other.
    - (){0,2} allows the whole thing to be can left out, used once or twice.
    - the final digits use \d{0,4} because there is no dash behind so
      they simple can be left out.
     */
    if (RegExp(
      r'^[A-Z]{0,2}-?(\d{1,4}-?){0,2}\d{0,4}$',
    ).hasMatch(editedValue.text)) {
      return editedValue;
    } else {
      return oldValue;
    }
  }
}
