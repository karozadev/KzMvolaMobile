import 'package:flutter_test/flutter_test.dart';
import 'package:kzmvola_mobile/domain/format.dart';

// `formatNumber` normalise le séparateur de milliers en espace insécable
// (U+00A0) pour éviter que « 265 000 Ar » ne se coupe en fin de ligne.
const _nbsp = ' ';

void main() {
  group('formatNumber', () {
    test('sépare les milliers par une espace insécable', () {
      expect(formatNumber(0), '0');
      expect(formatNumber(1000), '1${_nbsp}000');
      expect(formatNumber(265000), '265${_nbsp}000');
      expect(formatNumber(20000000), '20${_nbsp}000${_nbsp}000');
    });

    test("ne contient jamais d'espace sécable", () {
      expect(formatNumber(1234567), isNot(contains(' ')));
    });
  });

  group('formatAriary', () {
    test('ajoute le suffixe Ar', () {
      expect(formatAriary(265000), '265${_nbsp}000${_nbsp}Ar');
    });
  });

  group('parseAmountInput', () {
    test('extrait les chiffres, quel que soit le formatage', () {
      expect(parseAmountInput('265 000 Ar'), 265000);
      expect(parseAmountInput('1.234.567'), 1234567);
      expect(parseAmountInput('  42 000  '), 42000);
    });

    test('renvoie 0 pour une saisie sans chiffre', () {
      expect(parseAmountInput(''), 0);
      expect(parseAmountInput('Ar'), 0);
    });
  });

  group('countDigitsBeforeIndex', () {
    test('compte les chiffres situés avant la position du curseur', () {
      expect(countDigitsBeforeIndex('265 000', 0), 0);
      expect(countDigitsBeforeIndex('265 000', 3), 3);
      expect(countDigitsBeforeIndex('265 000', 7), 6);
    });
  });

  group('cursorPositionAfterDigits', () {
    test('replace le curseur juste après le n-ième chiffre du texte formaté', () {
      expect(cursorPositionAfterDigits('265 000', 0), 0);
      expect(cursorPositionAfterDigits('265 000', 3), 3);
      expect(cursorPositionAfterDigits('265 000', 6), 7);
    });

    test('reste dans les bornes quand on demande plus de chiffres que disponible', () {
      expect(cursorPositionAfterDigits('265 000', 99), '265 000'.length);
    });

    test('conserve le nombre de chiffres à gauche du curseur après reformatage', () {
      const before = '2650';
      final digitsLeft = countDigitsBeforeIndex(before, 3); // "265|0" -> 3 chiffres
      final after = formatNumber(parseAmountInput(before)); // "2 650"
      final pos = cursorPositionAfterDigits(after, digitsLeft);
      expect(countDigitsBeforeIndex(after, pos), digitsLeft);
    });
  });
}
