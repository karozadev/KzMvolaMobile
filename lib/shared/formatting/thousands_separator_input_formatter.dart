import 'package:flutter/services.dart';

import '../../domain/format.dart';

/// Reformate en direct la saisie du montant avec des séparateurs de milliers,
/// en préservant la position du curseur relativement aux chiffres tapés.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsBeforeCursor = countDigitsBeforeIndex(newValue.text, newValue.selection.end);
    final amount = parseAmountInput(newValue.text);
    final formatted = amount > 0 ? formatNumber(amount) : '';
    final cursor = cursorPositionAfterDigits(formatted, digitsBeforeCursor);
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: cursor));
  }
}
