# credit_card_type_detector | Credit Card Type Detector
A Dart package that detects credit card types based on the current credit card number patterns

This package is inspired by [Braintree's credit-card-type module](https://github.com/braintree/credit-card-type/)

![Gif of the example app](example/example.gif)

# Installing
Add dependency to your `pubspec.yaml`

*Get the current version in the **Installing** tab on pub.dartlang.org*
```
dependencies:
    credit_card_type_detector: <current_version>
```

#  Usage
```
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

String visa = '4647 7200 6779 1032';

var type = detectCCType(visa);

assert(type == CreditCardType.visa)

```
**Check out the example app** in the [example](example) directory or the 'Example' tab on pub.dartlang.org for a more complete example using the BLoC pattern

# Features
* No external dependencies
* Supported cards: 
    * Visa
    * Mastercard
    * American Express
    * Discover
    * Diners Club
    * JCB
    * Union Pay
    * Maestro
    * Mir
    * Elo
    * Hiper/Hipercard

## Pattern Detection
Each card type has a corresponding list of patterns. See the `cardNumPatterns` map.
Each pattern is an array of strings that represents a range of numbers or a single number. These numbers correspond to the [Issuer Identification number (IIN)](https://en.wikipedia.org/wiki/Payment_card_number) for the credit card company.

There are two types of patterns:

1. Single number pattern. The pattern number is compared against the card number. Partial matches for card numbers that are shorter than the pattern will count as matches (this is helpful for reactive text boxes where the UI can be updated as the user is typing).
    
    I.e. given the pattern `'123'`, then the card numbers `'1'`, `'12'`, `'123'`, `'1234'` will all match, but `'2'`, `'13'`, and `'124'` will not match.

2. Range of numbers. The card number is checked to be within the range of those numbers in the pattern. Again, partial matches are looked for.

    I.e. given the range `['100', '123']`, then the card numbers `'1'`, `'10'`, `'100'`, `'12'`, `'120'`, `'123'` will all match, but `'2'`, `'13'`, and `'124'` will not match.

Every card type and all of its corresponding patterns are looped over when the function `detectCCType` is called. Whitespace is ignored in the string passed in.

**If there are any non-numeric characters in the string the result will be `CreditCardType.unknown`.**


# API
## `detectCCType(String number)`
> Returns: A `CreditCardType` enum.

I.e. `CreditCardType.visa` for  any card number that starts with '4'.

# Related Repos
* [Credit Card Validator - Cholojuanito GitHub](https://github.com/cholojuanito/credit_card_validator)

# Author
Cholojuanito (Tanner Davis) - *Creator and repo owner* - [Github Profile](https://github.com/cholojuanito)

# Support
If you think this package is helpful, tell your friends, give it a star on GitHub, and a like on [pub.dev](https://pub.dev/packages/credit_card_type_detector)


# License
This project is licensed under the MIT License - see the [LICENSE file](LICENSE) for more details

