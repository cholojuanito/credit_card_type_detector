import 'dart:collection';

import 'constants.dart';

/// Represents the credit card type and general information
/// about a particular brand of card, including the patterns and
/// usual security code used with that brand.
class CreditCardType {
  final String type;
  final String prettyType;
  final List<int> lengths;
  final Set<Pattern> patterns;
  SecurityCode securityCode;

  CreditCardType(this.type, this.prettyType, this.lengths, this.patterns,
      this.securityCode);

  /// Creates a Visa card type with default values
  CreditCardType.visa()
      : type = TYPE_VISA,
        prettyType = PRETTY_VISA,
        lengths = ccNumLengthDefaults[TYPE_VISA]!,
        patterns = cardNumPatternDefaults[TYPE_VISA]!,
        securityCode = ccSecurityCodeDefaults[TYPE_VISA]!;

  /// Creates a Mastercard card type with default values
  CreditCardType.mastercard()
      : type = TYPE_MASTERCARD,
        prettyType = PRETTY_MASTERCARD,
        lengths = ccNumLengthDefaults[TYPE_MASTERCARD]!,
        patterns = cardNumPatternDefaults[TYPE_MASTERCARD]!,
        securityCode = ccSecurityCodeDefaults[TYPE_MASTERCARD]!;

  /// Creates a American Express card type with default values
  CreditCardType.americanExpress()
      : type = TYPE_AMEX,
        prettyType = PRETTY_AMEX,
        lengths = ccNumLengthDefaults[TYPE_AMEX]!,
        patterns = cardNumPatternDefaults[TYPE_AMEX]!,
        securityCode = ccSecurityCodeDefaults[TYPE_AMEX]!;

  /// Creates a Discover card type with default values
  CreditCardType.discover()
      : type = TYPE_DISCOVER,
        prettyType = PRETTY_DISCOVER,
        lengths = ccNumLengthDefaults[TYPE_DISCOVER]!,
        patterns = cardNumPatternDefaults[TYPE_DISCOVER]!,
        securityCode = ccSecurityCodeDefaults[TYPE_DISCOVER]!;

  /// Creates a Diner's Club card type with default values
  CreditCardType.dinersClub()
      : type = TYPE_DINERS_CLUB,
        prettyType = PRETTY_DINERS_CLUB,
        lengths = ccNumLengthDefaults[TYPE_DINERS_CLUB]!,
        patterns = cardNumPatternDefaults[TYPE_DINERS_CLUB]!,
        securityCode = ccSecurityCodeDefaults[TYPE_DINERS_CLUB]!;

  /// Creates a JCB card type with default values
  CreditCardType.jcb()
      : type = TYPE_JCB,
        prettyType = PRETTY_JCB,
        lengths = ccNumLengthDefaults[TYPE_JCB]!,
        patterns = cardNumPatternDefaults[TYPE_JCB]!,
        securityCode = ccSecurityCodeDefaults[TYPE_JCB]!;

  /// Creates a UnionPay card type with default values
  CreditCardType.unionPay()
      : type = TYPE_UNIONPAY,
        prettyType = PRETTY_UNIONPAY,
        lengths = ccNumLengthDefaults[TYPE_UNIONPAY]!,
        patterns = cardNumPatternDefaults[TYPE_UNIONPAY]!,
        securityCode = ccSecurityCodeDefaults[TYPE_UNIONPAY]!;

  /// Creates a Maestro card type with default values
  CreditCardType.maestro()
      : type = TYPE_MAESTRO,
        prettyType = PRETTY_MAESTRO,
        lengths = ccNumLengthDefaults[TYPE_MAESTRO]!,
        patterns = cardNumPatternDefaults[TYPE_MAESTRO]!,
        securityCode = ccSecurityCodeDefaults[TYPE_MAESTRO]!;

  /// Creates a Elo card type with default values
  CreditCardType.elo()
      : type = TYPE_ELO,
        prettyType = PRETTY_ELO,
        lengths = ccNumLengthDefaults[TYPE_ELO]!,
        patterns = cardNumPatternDefaults[TYPE_ELO]!,
        securityCode = ccSecurityCodeDefaults[TYPE_ELO]!;

  /// Creates a Mir card type with default values
  CreditCardType.mir()
      : type = TYPE_MIR,
        prettyType = PRETTY_MIR,
        lengths = ccNumLengthDefaults[TYPE_MIR]!,
        patterns = cardNumPatternDefaults[TYPE_MIR]!,
        securityCode = ccSecurityCodeDefaults[TYPE_MIR]!;

  /// Creates a Hiper card type with default values
  CreditCardType.hiper()
      : type = TYPE_HIPER,
        prettyType = PRETTY_HIPER,
        lengths = ccNumLengthDefaults[TYPE_HIPER]!,
        patterns = cardNumPatternDefaults[TYPE_HIPER]!,
        securityCode = ccSecurityCodeDefaults[TYPE_HIPER]!;

  /// Creates a Hipercard card type with default values
  CreditCardType.hipercard()
      : type = TYPE_HIPER,
        prettyType = PRETTY_HIPER,
        lengths = ccNumLengthDefaults[TYPE_HIPER]!,
        patterns = cardNumPatternDefaults[TYPE_HIPER]!,
        securityCode = ccSecurityCodeDefaults[TYPE_HIPER]!;

  /// Creates a Hipercard card type with default values
  CreditCardType.unknown()
      : type = TYPE_UNKNOWN,
        prettyType = PRETTY_UNKNOWN ,
        lengths = ccNumLengthDefaults[TYPE_UNKNOWN]!,
        patterns = cardNumPatternDefaults[TYPE_UNKNOWN]!,
        securityCode = ccSecurityCodeDefaults[TYPE_UNKNOWN]!;

  /// Add a new pattern to a card type
  void addPattern(Pattern pattern) {
    this.patterns.add(pattern);
  }

  /// Change the security code information about
  void updateSecurityCode(SecurityCode securityCode) {
    this.securityCode = securityCode;
  }

  @override
  bool operator ==(Object other) => (other is CreditCardType)
      ? (type == other.type &&
          prettyType == other.prettyType &&
          lengths == other.lengths &&
          patterns == other.patterns &&
          securityCode == other.securityCode)
      : false;

  @override
  int get hashCode =>
      Object.hash(type, prettyType, lengths, patterns, securityCode);
}

/// Represents different patterns a credit card number pattern can have.
/// Mostly encapsulates the possible prefixes that the card number has for a particular brand.
class Pattern {
  /// A lower and upper bound on a range of values the card number starts with.
  /// i.e. `['51', '55']` represents the range of cards starting
  /// with '51' to those starting with '55'
  final List<String> prefixes;

  Pattern(this.prefixes);

  void addPrefix(String prefix) {
    prefixes.add(prefix);
  }

  @override
  bool operator ==(Object other) =>
      (other is Pattern) ? (prefixes == other.prefixes) : false;

  @override
  int get hashCode => Object.hashAll(prefixes);
}

class SecurityCode {
  final String name;
  final int length;

  SecurityCode(this.name, this.length);

  /// Creates a security code based on a standard CVV
  const SecurityCode.cvv()
      : name = SEC_CODE_CVV,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// Creates a security code based on a standard CVC
  const SecurityCode.cvc()
      : name = SEC_CODE_CVC,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// Creates a security code based on a standard CID
  /// with 3 digits
  const SecurityCode.cid3()
      : name = SEC_CODE_CID,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// Creates a security code based on a standard CID
  /// with 4 digits
  const SecurityCode.cid4()
      : name = SEC_CODE_CID,
        length = ALT_SECURITY_CODE_LENGTH;

  /// Creates a security code based on a standard CVN
  const SecurityCode.cvn()
      : name = SEC_CODE_CVN,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// Creates a security code based on a standard CVE
  const SecurityCode.cve()
      : name = SEC_CODE_CVE,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// Creates a security code based on a standard CVP2
  const SecurityCode.cvp2()
      : name = SEC_CODE_CVP2,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  @override
  bool operator ==(Object other) => (other is SecurityCode)
      ? (name == other.name && length == other.length)
      : false;

  @override
  int get hashCode => Object.hash(name, length);
}

class CardCollection {
  final Map<String, CreditCardType> cards;

  CardCollection(this.cards);
  CardCollection.empty() : cards = {};
  factory CardCollection.from(CardCollection other) {
    CardCollection c = CardCollection.empty();
    c.cards.addAll(other.cards);
    return c;
  }

  CreditCardType? getCardType(String cardName) {
    return cards[cardName];
  }

  void addCardType(String key, CreditCardType cardType) {
    if (cards.containsKey(key)) {
      throw Exception(
          'The card "${key}" already exists in this collection. Use `updateCardType()` instead');
    } else {
      cards[key] = cardType;
    }
  }

  void updateCardType(String key, CreditCardType cardType) {
    cards[key] = cardType;
  }

  CreditCardType? removeCard(String key) {
    return cards.remove(key);
  }
}
