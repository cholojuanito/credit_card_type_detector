import 'package:test/test.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

void main() {
  group('Correct CC numbers', () {
    test('full card numbers', () {
      final String visaCCNumFull = "4647 7200 6779 1032";
      final String amexCCNumFull = "3799 9661 4347 278";
      final String discoverCCNumFull = "6011 9340 9644 0452";
      final String masterCardCCNumFull = "5587 1921 6771 2970";

      // Test Visa
      expect(detectCCType(visaCCNumFull), CreditCardType.visa);

      // Test Amex
      expect(detectCCType(amexCCNumFull), CreditCardType.amex);

      // Test Discover
      expect(detectCCType(discoverCCNumFull), CreditCardType.discover);

      // Test MasterCard
      expect(detectCCType(masterCardCCNumFull), CreditCardType.mastercard);
    });

    test('partial card numbers', () {
      final String visaCCNumPartial = "4647 7200";
      final String amexCCNumPartial = "3499";
      final String discoverCCNumPartial = "6224 2876 89";
      final String masterCardCCNumPartial = "5287 19";

      // Test Visa
      expect(detectCCType(visaCCNumPartial), CreditCardType.visa);

      // Test Amex
      expect(detectCCType(amexCCNumPartial), CreditCardType.amex);

      // Test Discover
      expect(detectCCType(discoverCCNumPartial), CreditCardType.discover);

      // Test MasterCard
      expect(detectCCType(masterCardCCNumPartial), CreditCardType.mastercard);
    });
  });

// Test CC numbers that are not supported
  group('Incorrect CC numbers', () {
    test('full card numbers', () {});

    test('partial card numbers', () {});
  });

// Test empty string and other edge cases
  group('Edge cases', () {
    test('Empty string', () {
      final String emptyStr = '';
      expect(detectCCType(emptyStr), null);
    });

    // TODO
    test('String with non-numerical chars', () {});
  });
}
