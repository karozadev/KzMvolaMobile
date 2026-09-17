import 'package:intl/intl.dart';

final _thousandsFormatter = NumberFormat.decimalPattern('fr_FR');
final _whitespacePattern = RegExp(r'\s');
final _nonDigitPattern = RegExp(r'[^\d]');
final _digitPattern = RegExp(r'\d');

/// Espace insécable (U+00A0) : le séparateur de milliers fr-FR produit par
/// [NumberFormat] (U+202F) est normalisé vers ce caractère, comme dans la
/// référence web, pour éviter que « 265 000 Ar » ne se coupe en fin de ligne.
const _nbsp = ' ';

/// Formate un nombre avec des espaces insécables comme séparateurs de milliers, ex: 265000 -> "265 000".
String formatNumber(num value) =>
    _thousandsFormatter.format(value).replaceAll(_whitespacePattern, _nbsp);

/// Formate un montant en Ariary, ex: 265000 -> "265 000 Ar".
String formatAriary(num value) => '${formatNumber(value)}${_nbsp}Ar';

/// Extrait la valeur numérique d'une saisie utilisateur potentiellement formatée ("265 000 Ar").
int parseAmountInput(String raw) {
  final digitsOnly = raw.replaceAll(_nonDigitPattern, '');
  return digitsOnly.isEmpty ? 0 : int.parse(digitsOnly);
}

/// Nombre de chiffres présents dans `str` avant l'index `index`.
int countDigitsBeforeIndex(String str, int index) {
  return _digitPattern.allMatches(str.substring(0, index)).length;
}

/// Position (index) à placer juste après le `digitCount`-ième chiffre de `formatted`.
int cursorPositionAfterDigits(String formatted, int digitCount) {
  if (digitCount <= 0) return 0;
  var seen = 0;
  for (var i = 0; i < formatted.length; i++) {
    if (_digitPattern.hasMatch(formatted[i])) {
      seen++;
      if (seen == digitCount) return i + 1;
    }
  }
  return formatted.length;
}
