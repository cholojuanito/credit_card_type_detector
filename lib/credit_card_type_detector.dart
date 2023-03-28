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

/// This function determines the potential CC types based on the cardPatterns
List<CreditCardType> detectCCType(String ccNumStr) {
  List<CreditCardType> cardTypes = [];
  ccNumStr = ccNumStr.replaceAll(_whiteSpace, '');

  if (ccNumStr.isEmpty) {
    return cardTypes;
  }

  // Check that only numerics are in the string
  if (_nonNumeric.hasMatch(ccNumStr)) {
    return cardTypes;
  }

  _customCards.cards.forEach(
    (String cardName, CreditCardType type) {
      for (Pattern pattern in type.patterns) {
        // Remove any spaces
        String ccPatternStr = ccNumStr;
        int rangeLen = pattern.prefixes[0].length;
        // Trim the CC number str to match the pattern prefix length
        if (rangeLen < ccNumStr.length) {
          ccPatternStr = ccPatternStr.substring(0, rangeLen);
        }

        if (pattern.prefixes.length > 1) {
          // Convert the prefix range into numbers then make sure the
          // CC num is in the pattern range.
          // Because Strings don't have '>=' type operators
          int ccPrefixAsInt = int.parse(ccPatternStr);
          int startPatternPrefixAsInt = int.parse(pattern.prefixes[0]);
          int endPatternPrefixAsInt = int.parse(pattern.prefixes[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt &&
              ccPrefixAsInt <= endPatternPrefixAsInt) {
            // Found a match
            cardTypes.add(type);
            break;
          }
        } else {
          // Just compare the single pattern prefix with the CC prefix
          if (ccPatternStr == pattern.prefixes[0]) {
            // Found a match
            cardTypes.add(type);
            break;
          }
        }
      }
    },
  );

  return cardTypes;
}

/// Gets the `CreditCardType` object associated with the `cardName`
CreditCardType? getCardType(String cardName) {
  return _customCards.getCardType(cardName);
}

/// Adds a custom card type to the card collection
/// 
/// Throws `Exception` if the `cardName` is already in the collection
void addCustomCardType(String cardName, CreditCardType type) {
  _customCards.addCardType(cardName, type);
}

/// Updates the card type of the `cardName` in the card collection
void updateCustomCardType(String cardName, CreditCardType type) {
  _customCards.updateCardType(cardName, type);
}

/// Removes `cardName` from the card collection
void removeCustomCardType(String cardName) {
  CreditCardType? _ = _customCards.removeCard(cardName);
}

void resetCustomCardTypes() {
  _customCards = CardCollection.from(_defaultCCTypes);
}