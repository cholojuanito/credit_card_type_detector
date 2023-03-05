import 'package:credit_card_type_detector/constants.dart';

import 'models.dart';

final CardCollection _defaultCCTypes = CardCollection({
  TYPE_VISA: CreditCardType.visa(),
  TYPE_MASTERCARD: CreditCardType.mastercard(),
  TYPE_AMEX: CreditCardType.americanExpress(),
  TYPE_DISCOVER: CreditCardType.discover(),
  TYPE_DINERS_CLUB: CreditCardType.dinersClub(),
  TYPE_JCB: CreditCardType.jcb(),
  TYPE_UNIONPAY: CreditCardType.unionPay(),
  TYPE_MAESTRO: CreditCardType.maestro(),
  TYPE_ELO: CreditCardType.elo(),
  TYPE_HIPER: CreditCardType.hiper(),
  TYPE_HIPERCARD: CreditCardType.hipercard(),
  TYPE_UNKNOWN: CreditCardType.unknown(),
});

CardCollection _customCards = CardCollection.from(_defaultCCTypes);

/// Finds non numeric characters
RegExp _nonNumeric = RegExp(r'\D+');

/// Finds whitespace in any form
RegExp _whiteSpace = RegExp(r'\s+\b|\b\s');

/// This function determines the CC type based on the cardPatterns
CreditCardType detectCCType(String ccNumStr) {
  CreditCardType cardType = CreditCardType.unknown;
  ccNumStr = ccNumStr.replaceAll(_whiteSpace, '');;

  if (ccNumStr.isEmpty) {
    return cardType;
  }

  // Check that only numerics are in the string
  if (_nonNumeric.hasMatch(ccNumStr)) {
    return cardType;
  }

  cardNumPatterns.forEach(
    (CreditCardType type, Set<List<String>> patterns) {
      for (List<String> patternRange in patterns) {
        // Remove any spaces
        String ccPatternStr = ccNumStr;
        int rangeLen = patternRange[0].length;
        // Trim the CC number str to match the pattern prefix length
        if (rangeLen < ccNumStr.length) {
          ccPatternStr = ccPatternStr.substring(0, rangeLen);
        }

        if (patternRange.length > 1) {
          // Convert the prefix range into numbers then make sure the
          // CC num is in the pattern range.
          // Because Strings don't have '>=' type operators
          int ccPrefixAsInt = int.parse(ccPatternStr);
          int startPatternPrefixAsInt = int.parse(patternRange[0]);
          int endPatternPrefixAsInt = int.parse(patternRange[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt &&
              ccPrefixAsInt <= endPatternPrefixAsInt) {
            // Found a match
            cardType = type;
            break;
          }
        } else {
          // Just compare the single pattern prefix with the CC prefix
          if (ccPatternStr == patternRange[0]) {
            // Found a match
            cardType = type;
            break;
          }
        }
      }
    },
  );

  return cardType;
}
