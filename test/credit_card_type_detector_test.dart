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
      Pattern(['6526']),
      Pattern(['81']),
      Pattern(['82']),
      Pattern(['508']),
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
    resetCardTypes();
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
      expect(
          detectCCType(visaCCNumFull),
          allOf([
            contains(CreditCardType.visa()),
            containsAllInOrder([CreditCardType.visa()])
          ]));
      expect(
          detectCCType(amexCCNumFull),
          allOf([
            contains(CreditCardType.americanExpress()),
            containsAllInOrder([CreditCardType.americanExpress()])
          ]));
      expect(
          detectCCType(discoverCCNumFull),
          allOf([
            contains(CreditCardType.discover()),
            containsAllInOrder([CreditCardType.discover()])
          ]));
      expect(
          detectCCType(masterCardCCNumFull),
          allOf([
            contains(CreditCardType.mastercard()),
            containsAllInOrder([CreditCardType.mastercard()])
          ]));
      expect(
          detectCCType(jcbCardCCNumFull),
          allOf([
            contains(CreditCardType.jcb()),
            containsAllInOrder([CreditCardType.jcb()])
          ]));
      expect(
          detectCCType(unionPayCardCCNumFull),
          allOf([
            contains(CreditCardType.unionPay()),
            containsAllInOrder([CreditCardType.unionPay()])
          ]));
      expect(
          detectCCType(maestroCardCCNumFull),
          allOf([
            contains(CreditCardType.maestro()),
            containsAllInOrder([CreditCardType.maestro()])
          ]));
      expect(
          detectCCType(eloCardCCNumFull),
          allOf([
            contains(CreditCardType.elo()),
            containsAllInOrder([CreditCardType.elo()])
          ]));
    });

    test('partial card numbers', () {
      expect(
          detectCCType(visaCCNumPartial),
          allOf([
            contains(CreditCardType.visa()),
            containsAllInOrder([CreditCardType.visa()])
          ]));
      expect(
          detectCCType(amexCCNumPartial),
          allOf([
            contains(CreditCardType.americanExpress()),
            containsAllInOrder([CreditCardType.americanExpress()])
          ]));
      expect(
          detectCCType(discoverCCNumPartial),
          allOf([
            contains(CreditCardType.discover()),
            containsAllInOrder([CreditCardType.discover()])
          ]));
      expect(
          detectCCType(masterCardCCNumPartial),
          allOf([
            contains(CreditCardType.mastercard()),
            containsAllInOrder([CreditCardType.mastercard()])
          ]));
      expect(
          detectCCType(eloCardCCNumPartial),
          allOf([
            contains(CreditCardType.elo()),
            containsAllInOrder([CreditCardType.elo()])
          ]));
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
      expect(detectCCType(badCCNumFull1), isEmpty);
      expect(detectCCType(badCCNumFull2), isEmpty);
      expect(detectCCType(badCCNumFull3), isEmpty);
    });

    test('partial card numbers', () {
      expect(detectCCType(badCCNumPartial1), isEmpty);
      expect(detectCCType(badCCNumPartial2), isEmpty);
      expect(detectCCType(badCCNumPartial3), isEmpty);
    });
  });

  group('detectCCType: Custom CC numbers', () {
    // Rupay type should match as both Rupay and Discover
    final String rupayCCNumFull = '6526 1553 1595 4098';
    final String rupayCCNumPartial = '6526';
    final String myCardCCNumFull = '1234 5678 9123 1';
    final String myCardCCNumPartial = '2345 67';

    test('full card numbers', () {
      addCardType('rupay', rupayType);
      addCardType('mycard', someMadeUpCardType);
      expect(
          detectCCType(rupayCCNumFull),
          allOf([
            contains(rupayType),
            containsAllInOrder([rupayType, CreditCardType.discover()])
          ]));
      expect(
          detectCCType(myCardCCNumFull),
          allOf([
            contains(someMadeUpCardType),
            containsAllInOrder([someMadeUpCardType])
          ]));
    });

    test('partial card numbers', () {
      addCardType('rupay', rupayType);
      addCardType('mycard', someMadeUpCardType);
      expect(
          detectCCType(rupayCCNumPartial),
          allOf([
            contains(rupayType),
            containsAllInOrder([rupayType, CreditCardType.discover()])
          ]));
      expect(
          detectCCType(myCardCCNumPartial),
          allOf([
            contains(someMadeUpCardType),
            containsAllInOrder([someMadeUpCardType])
          ]));
    });
  });

// Test custom CC types
  group('Customizing card types', () {
    group('Custom cards', () {
      test('Add custom card type', () {
        addCardType('rupay', rupayType);
        expect(getCardType('rupay'), allOf([isNotNull, equals(rupayType)]));
      });

      test('Edit custom card type', () {
        addCardType('rupay', rupayType);
        updateCardType('rupay', modifiedRupay);
        expect(getCardType('rupay'), allOf([isNotNull, equals(modifiedRupay)]));
      });

      test('Remove custom card type', () {
        addCardType('rupay', rupayType);
        removeCardType('rupay');
        expect(getCardType('rupay'), isNull);
      });
    });
    group('Default cards', () {
      final String goodDefaultVisaNumber = '4023 5678 1234 9076';
      final String goodModifiedVisaNumber = '3023 5678 1234 9076';
      test('Edit default card type', () {
        updateCardType(TYPE_VISA, modifiedVisa);
        expect(
            getCardType(TYPE_VISA), allOf([isNotNull, equals(modifiedVisa)]));
      });

      test('Add new card patterns to default card type', () {
        CreditCardType visaCard = getCardType(TYPE_VISA)!;
        visaCard.addPattern(Pattern(['3']));
        expect(detectCCType(goodDefaultVisaNumber),
            contains(getCardType(TYPE_VISA)));
        expect(detectCCType(goodModifiedVisaNumber),
            contains(getCardType(TYPE_VISA)));
      });

      test('Remove default card type', () {
        removeCardType(TYPE_VISA);
        expect(getCardType(TYPE_VISA), isNull);
      });
    });
  });

// Test empty string and other edge cases
  group('Edge cases', () {
    final String emptyStr = '';
    final String badStr = '4000 abc';

    test('empty string', () {
      expect(
          detectCCType(emptyStr),
          containsAll([
            CreditCardType.americanExpress(),
            CreditCardType.dinersClub(),
            CreditCardType.discover(),
            CreditCardType.elo(),
            CreditCardType.hiper(),
            CreditCardType.hipercard(),
            CreditCardType.jcb(),
            CreditCardType.maestro(),
            CreditCardType.mastercard(),
            CreditCardType.unionPay(),
            CreditCardType.visa()
          ]));
    });

    test('string with non-numerical chars', () {
      expect(detectCCType(badStr), isEmpty);
    });

    test('Add existing custom card type throws exception', () {
      addCardType('rupay', rupayType);
      expect(() => addCardType('rupay', rupayType), throwsException);
      expect(getCardType('rupay'), allOf([isNotNull, equals(rupayType)]));
    });
  });
}
