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

      expect(detectCCType(visaCCNumPartial), CreditCardType.visa);
      expect(detectCCType(amexCCNumPartial), CreditCardType.amex);
      expect(detectCCType(discoverCCNumPartial), CreditCardType.discover);
      expect(detectCCType(masterCardCCNumPartial), CreditCardType.mastercard);
    });
  });

// Test CC numbers that are not supported
  group('Incorrect CC numbers', () {
    test('full card numbers', () {
      final String badCCNumFull1 = "8647 7200 6779 1032";
      final String badCCNumFull2 = "3399 9661 4347 2781";
      final String badCCNumFull3 = "6111 9340 9644 0452";

      expect(detectCCType(badCCNumFull1), CreditCardType.unknown);
      expect(detectCCType(badCCNumFull2), CreditCardType.unknown);
      expect(detectCCType(badCCNumFull3), CreditCardType.unknown);
    });

    test('partial card numbers', () {
      final String badCCNumPartial1 = "8647 7200";
      final String badCCNumPartial2 = "3399";
      final String badCCNumPartial3 = "6111 2878 9";

      expect(detectCCType(badCCNumPartial1), CreditCardType.unknown);
      expect(detectCCType(badCCNumPartial2), CreditCardType.unknown);
      expect(detectCCType(badCCNumPartial3), CreditCardType.unknown);
    });
  });

// Test empty string and other edge cases
  group('Edge cases', () {
    test('empty string', () {
      final String emptyStr = '';

      expect(detectCCType(emptyStr), CreditCardType.unknown);
    });

    test('string with non-numerical chars', () {
      final String badStr = '4000 abc';

      expect(detectCCType(badStr), CreditCardType.unknown);
    });
  });
}
