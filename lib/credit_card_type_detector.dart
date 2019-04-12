library credit_card_type_detector;

/// Supported card types
enum CreditCardType {
  visa,
  amex,
  discover,
  mastercard,
  unknown,
}

/// CC prefix patterns as of March 2019
/// A [List<String>] represents a range.
/// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
const Map<CreditCardType, Set<List<String>>> cardPatterns = {
  CreditCardType.visa: {
    ['4'],
  },
  CreditCardType.amex: {
    ['34'],
    ['37'],
  },
  CreditCardType.discover: {
    ['6011'],
    ['622126', '622925'],
    ['644', '649'],
    ['65']
  },
  CreditCardType.mastercard: {
    ['51', '55'],
    ['2221', '2229'],
    ['223', '229'],
    ['23', '26'],
    ['270', '271'],
    ['2720'],
  },
};

/// This function determines the CC type based on the cardPatterns
CreditCardType detectCCType(String ccNumStr) {
  CreditCardType cardType = CreditCardType.unknown;

  if (ccNumStr.isEmpty) {
    return cardType;
  }

  //TODO error checking for strings with non-numerical chars

  cardPatterns.forEach(
    (CreditCardType type, Set<List<String>> patterns) {
      for (List<String> patternRange in patterns) {
        // Remove any spaces
        String ccPatternStr = ccNumStr.replaceAll(RegExp(r'\s+\b|\b\s'), '');
        int patternLen = patternRange[0].length;
        // Trim the CC number str to match the pattern prefix length
        if (patternLen < ccNumStr.length) {
          ccPatternStr = ccPatternStr.substring(0, patternLen);
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
