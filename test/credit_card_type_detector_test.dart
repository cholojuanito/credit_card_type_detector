import 'package:credit_card_type_detector/constants.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:test/test.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

void main() {
  // Variables used in tests
  final CreditCardType rupayType = CreditCardType(
    'rupay',
    'RuPay',
    [16],
    {
      Pattern(['60']),
      Pattern(['65']), // Conflicts with Discover
      Pattern(['81']), // Conflicts with UnionPay
      Pattern(['82']),
      Pattern(['508']), // Conflicts with Maestro
    },
    SecurityCode.cvv(),
  );

  final CreditCardType modifiedRupay = CreditCardType(
    'rupay',
    'RuPay',
    [16],
    {
      Pattern(['60']),
      Pattern(['82']),
    },
    SecurityCode.cvv(),
  );

  final CreditCardType someMadeUpCardType = CreditCardType(
    'mycard',
    'MyCard',
    [16, 17, 18],
    {
      Pattern(['1']),
      Pattern(['2']),
      Pattern(['999']),
    },
    SecurityCode.cid4(),
  );

  final CreditCardType modifiedVisa = CreditCardType(
    TYPE_VISA,
    PRETTY_VISA,
    [16], // only length 16
    {
      Pattern(['3'])
    },
    SecurityCode.cvv(),
  );

  setUp(() {
    resetCustomCardTypes();
  });

  group('detectCCType: Correct default CC numbers', () {
    final String visaCCNumFull = "4647 7200 6779 1032";
    final String amexCCNumFull = "3799 9661 4347 278";
    final String discoverCCNumFull = "6011 9340 9644 0452";
    final String masterCardCCNumFull = "5587 1921 6771 2970";
    final String jcbCardCCNumFull = '3538 2430 3999 1295';
    final String unionPayCardCCNumFull = '6208 2430 3999 1295';
    final String maestroCardCCNumFull = '4936 9830 3999 1295';
    final String eloCardCCNumFull = '6550 2121 9875 8900';
    final String visaCCNumPartial = '4647 7200';
    final String amexCCNumPartial = '3499';
    final String discoverCCNumPartial = '6011 2876 89';
    final String masterCardCCNumPartial = '5287 19';
    final String eloCardCCNumPartial = '6550 2121';

    test('full card numbers', () {
      expect(detectCCType(visaCCNumFull), equals(CreditCardType.visa()));
      expect(detectCCType(amexCCNumFull),
          equals(CreditCardType.americanExpress()));
      expect(
          detectCCType(discoverCCNumFull), equals(CreditCardType.discover()));
      expect(detectCCType(masterCardCCNumFull),
          equals(CreditCardType.mastercard()));
      expect(detectCCType(jcbCardCCNumFull), equals(CreditCardType.jcb()));
      expect(detectCCType(unionPayCardCCNumFull),
          equals(CreditCardType.unionPay()));
      expect(
          detectCCType(maestroCardCCNumFull), equals(CreditCardType.maestro()));
      expect(detectCCType(eloCardCCNumFull), equals(CreditCardType.elo()));
    });

    test('partial card numbers', () {
      expect(detectCCType(visaCCNumPartial), equals(CreditCardType.visa()));
      expect(detectCCType(amexCCNumPartial),
          equals(CreditCardType.americanExpress()));
      expect(detectCCType(discoverCCNumPartial),
          equals(CreditCardType.discover()));
      expect(detectCCType(masterCardCCNumPartial),
          equals(CreditCardType.mastercard()));
      expect(detectCCType(eloCardCCNumPartial), equals(CreditCardType.elo()));
    });
  });

// Test CC numbers that are not supported
  group('detectCCType: Incorrect default CC numbers', () {
    final String badCCNumFull1 = '8647 7200 6779 1032';
    final String badCCNumFull2 = '3399 9661 4347 2781';
    final String badCCNumFull3 = '6111 9340 9644 0452';
    final String badCCNumPartial1 = '8647 7200';
    final String badCCNumPartial2 = '3399';
    final String badCCNumPartial3 = '6111 2878 9';

    test('full card numbers', () {
      expect(detectCCType(badCCNumFull1), equals(CreditCardType.unknown()));
      expect(detectCCType(badCCNumFull2), equals(CreditCardType.unknown()));
      expect(detectCCType(badCCNumFull3), equals(CreditCardType.unknown()));
    });

    test('partial card numbers', () {
      expect(detectCCType(badCCNumPartial1), equals(CreditCardType.unknown()));
      expect(detectCCType(badCCNumPartial2), equals(CreditCardType.unknown()));
      expect(detectCCType(badCCNumPartial3), equals(CreditCardType.unknown()));
    });
  });

  group('detectCCType: Custom CC numbers', () {
    final String rupayCCNumFull = '6026 1553 1595 4098';
    final String rupayCCNumPartial = '6026';
    final String myCardCCNumFull = '1234 5678 9123 1';
    final String myCardCCNumPartial = '2345 67';

    test('full card numbers', () {
      addCustomCardType('rupay', rupayType);
      addCustomCardType('mycard', someMadeUpCardType);
      expect(detectCCType(rupayCCNumFull), equals(rupayType));
      expect(detectCCType(myCardCCNumFull), equals(someMadeUpCardType));
    });

    test('partial card numbers', () {
      addCustomCardType('rupay', rupayType);
      addCustomCardType('mycard', someMadeUpCardType);
      expect(detectCCType(rupayCCNumPartial), equals(rupayType));
      expect(detectCCType(myCardCCNumPartial), equals(someMadeUpCardType));
    });
  });

// Test custom CC types
  group('Customizing card types', () {
    group('Custom cards', () {
      test('Add custom card type', () {
        addCustomCardType('rupay', rupayType);
        expect(getCardType('rupay'), equals(rupayType));
        expect(getCardType('rupay'), allOf([isNotNull, equals(rupayType)]));
      });

      test('Edit custom card type', () {
        addCustomCardType('rupay', rupayType);
        updateCustomCardType('rupay', modifiedRupay);
        expect(getCardType('rupay'), allOf([isNotNull, equals(modifiedRupay)]));
      });

      test('Remove custom card type', () {
        addCustomCardType('rupay', rupayType);
        removeCustomCardType('rupay');
        expect(getCardType('rupay'), isNull);
      });
    });
    group('Default cards', () {
      final String goodDefaultVisaNumber = '4023 5678 1234 9076';
      final String goodModifiedVisaNumber = '3023 5678 1234 9076';
      test('Edit default card type', () {
        updateCustomCardType(TYPE_VISA, modifiedVisa);
        expect(
            getCardType(TYPE_VISA), allOf([isNotNull, equals(modifiedVisa)]));
      });

      test('Add new card patterns to default card type', () {
        CreditCardType visaCard = getCardType(TYPE_VISA)!;
        visaCard.addPattern(Pattern(['3']));
        expect(
            detectCCType(goodDefaultVisaNumber), equals(getCardType(TYPE_VISA)));
        expect(detectCCType(goodModifiedVisaNumber),
            equals(getCardType(TYPE_VISA)));
      });

      test('Remove default card type', () {
        removeCustomCardType(TYPE_VISA);
        expect(getCardType(TYPE_VISA), isNull);
      });
    });
  });

// Test empty string and other edge cases
  group('Edge cases', () {
    final String emptyStr = '';
    final String badStr = '4000 abc';

    test('empty string', () {
      expect(detectCCType(emptyStr), CreditCardType.unknown());
    });

    test('string with non-numerical chars', () {
      expect(detectCCType(badStr), CreditCardType.unknown());
    });

    test('Add existing custom card type throws exception', () {
      addCustomCardType('rupay', rupayType);
      expect(() => addCustomCardType('rupay', rupayType), throwsException);
      expect(getCardType('rupay'), allOf([isNotNull, equals(rupayType)]));
    });
  });
}
