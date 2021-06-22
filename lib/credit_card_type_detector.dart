// Supported card types
enum CreditCardType {
  visa,
  amex,
  discover,
  mastercard,
  dinersclub,
  jcb,
  unionpay,
  maestro,
  elo,
  mir,
  hiper,
  hipercard,
  unknown,
}

/// CC prefix patterns as of March 2019
/// A [List<String>] represents a range.
/// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
const Map<CreditCardType, Set<List<String>>> cardNumPatterns = {
  CreditCardType.visa: {
    ['4'],
  },
  CreditCardType.amex: {
    ['34'],
    ['37'],
  },
  CreditCardType.discover: {
    ['6011'],
    ['644', '649'],
    ['65'],
  },
  CreditCardType.mastercard: {
    ['51', '55'],
    ['2221', '2229'],
    ['223', '229'],
    ['23', '26'],
    ['270', '271'],
    ['2720'],
  },
  CreditCardType.dinersclub: {
    ['300', '305'],
    ['36'],
    ['38'],
    ['39'],
  },
  CreditCardType.jcb: {
    ['3528', '3589'],
    ['2131'],
    ['1800'],
  },
  CreditCardType.unionpay: {
    ['620'],
    ['624', '626'],
    ['62100', '62182'],
    ['62184', '62187'],
    ['62185', '62197'],
    ['62200', '62205'],
    ['622010', '622999'],
    ['622018'],
    ['622019', '622999'],
    ['62207', '62209'],
    ['622126', '622925'],
    ['623', '626'],
    ['6270'],
    ['6272'],
    ['6276'],
    ['627700', '627779'],
    ['627781', '627799'],
    ['6282', '6289'],
    ['6291'],
    ['6292'],
    ['810'],
    ['8110', '8131'],
    ['8132', '8151'],
    ['8152', '8163'],
    ['8164', '8171'],
  },
  CreditCardType.maestro: {
    ['493698'],
    ['500000', '506698'],
    ['506779', '508999'],
    ['56', '59'],
    ['63'],
    ['67'],
  },
  CreditCardType.elo: {
    ['401178'],
    ['401179'],
    ['438935'],
    ['457631'],
    ['457632'],
    ['431274'],
    ['451416'],
    ['457393'],
    ['504175'],
    ['506699', '506778'],
    ['509000', '509999'],
    ['627780'],
    ['636297'],
    ['636368'],
    ['650031', '650033'],
    ['650035', '650051'],
    ['650405', '650439'],
    ['650485', '650538'],
    ['650541', '650598'],
    ['650700', '650718'],
    ['650720', '650727'],
    ['650901', '650978'],
    ['651652', '651679'],
    ['655000', '655019'],
    ['655021', '655058'],
  },
  CreditCardType.mir: {
    ['2200', '2204'],
  },
  CreditCardType.hiper: {
    ['637095'],
    ['637568'],
    ['637599'],
    ['637609'],
    ['637612'],
    ['63743358'],
    ['63737423'],
  },
  CreditCardType.hipercard: {
    ['606282'],
  }
};

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
