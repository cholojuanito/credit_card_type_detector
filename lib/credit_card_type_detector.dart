library credit_card_type_detector;

/// Supported card types
enum CreditCardType {
  visa,
  amex,
  discover,
  mastercard,
}

/// CC prefix patterns as of March 2019
/// A [List<String>] represents a range.
/// i.e. ['50', '55'] represents the range of cards starting with '50' to those starting with '55'
const Map<CreditCardType, List<List<String>>> cardPatterns = {
  CreditCardType.visa: [
    ['4'],
  ],
  CreditCardType.amex: [
    ['34'],
    ['37'],
  ],
  CreditCardType.discover: [
    ['6011'],
    ['622126', '622925'],
    ['644', '649'],
    ['65']
  ],
  CreditCardType.mastercard: [
    ['50', '55']
  ],
};

/// This function determines the CC type based on the cardPatterns
CreditCardType detectCCType(String ccNumStr) {
  CreditCardType cardType;

  if (ccNumStr.isEmpty) {
    return cardType;
  }

  //TODO error checking for strings with non-numerical chars

  cardPatterns.forEach(
    (CreditCardType type, List<List<String>> patterns) {
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
