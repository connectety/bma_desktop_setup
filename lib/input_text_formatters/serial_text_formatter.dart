import 'package:flutter/services.dart';

class SerialTextFormatter extends TextInputFormatter {
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

  RegExpMatch? getFirstMatch(TextEditingValue value, String regex) {
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
    final RegExpMatch? region = getFirstMatch(newValue, '[A-Z]+');

    /*
    REGEX-EXPLANATION:
    - \d makes sure matches start with digits
    - [\-\d]* is any combination of digits and dashes, these are followed up by
    - the \d at the start makes sure that not a pure - is matched
     */
    RegExpMatch? digits = getFirstMatch(newValue, r'\d[\-\d]*');

    // if there are region letters and digits try inserting a dash
    if (region != null && digits != null) {
      editedValue = _tryInsertDash(editedValue, region.end);

      digits = getFirstMatch(editedValue, r'\d[\-\d]*');
    }

    if (digits != null) {
      int digitAmount = 0;

      for (int i = digits.start; i < digits!.end; i++) {
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
