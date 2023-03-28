## [3.0.0] - 28 Mar 2023
* **Breaking changes**
  * `detectCCType()` now returns a `List<CreditCardType>` to support custom cards. This list will have the most likely card type as the first element
* **Support for custom credit card types**
  * Basic CRUD operations for card types that you can define. You can even change the default card types

## [2.0.0] - 22 Jun 2021
* Dart null safety ready official release
* Added some more Hipercard numbers
* Touched up the example app

## [2.0.0-nullsafety.0] - 15 Dec 2020
* Dart null safety ready! Updated dependencies to be ready.
* More edge case tests and unit tests
  * Checks for non-numeric characters
  * Testing for more incorrect card numbers

## [1.1.0] - 23 Sept 2019 
* Now supports all cards that the [Braintree module supports](https://github.com/braintree/credit-card-type/)
* Updated `README` to include a basic example, API, and other notes

## [1.0.1] - 12 Apr 2019
* Removed the gif from the `example/README` since the pub website wasn't displaying it

## [1.0.0] - 12 Apr 2019
* Updated the Mastercard patterns
* Added an example app


## [0.1.0] - 26 Mar 2019
* Support for Visa, Amex, Discover and MasterCard
* Basic unit tests

