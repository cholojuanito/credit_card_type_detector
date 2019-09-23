import 'package:test/test.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

void main() {
  group('Correct CC numbers', () {
    test('full card numbers', () {
      final String visaCCNumFull = "4647 7200 6779 1032";
      final String amexCCNumFull = "3799 9661 4347 278";
      final String discoverCCNumFull = "6011 9340 9644 0452";
      final String masterCardCCNumFull = "5587 1921 6771 2970";
      final String jcbCardCCNumFull = '3538 2430 3999 1295';
      final String unionPayCardCCNumFull = '6208 2430 3999 1295';
      final String maestroCardCCNumFull = '4936 9830 3999 1295';

      expect(detectCCType(visaCCNumFull), CreditCardType.visa);
      expect(detectCCType(amexCCNumFull), CreditCardType.amex);
      expect(detectCCType(discoverCCNumFull), CreditCardType.discover);
      expect(detectCCType(masterCardCCNumFull), CreditCardType.mastercard);
      expect(detectCCType(jcbCardCCNumFull), CreditCardType.jcb);
      expect(detectCCType(unionPayCardCCNumFull), CreditCardType.unionpay);
      expect(detectCCType(maestroCardCCNumFull), CreditCardType.maestro);
    });

    test('partial card numbers', () {
      final String visaCCNumPartial = "4647 7200";
      final String amexCCNumPartial = "3499";
      final String discoverCCNumPartial = "6011 2876 89";
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
