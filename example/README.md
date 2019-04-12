# Add Credit Card Screen
## This example can be seen in the gif found in the root README
A screen for entering credit card information. As the user enters the credit card number the type of credit card is checked and then displayed.

This example was created by [Cholojuanito](https://github.com/cholojuanito).

The code is available in the `example` directory of the [git repo](https://github.com/cholojuanito/credit_card_type_detector).

This example makes use of the BLoC pattern so that other screens/widgets can access the new credit card info. 

If you want to read more about the BLoC pattern I recommend the following articles:
* [Streams & BLoC - Didier Boelens](https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc/)
* [BLoC Practical Use Cases - Didier Boelens](https://www.didierboelens.com/2018/12/reactive-programming---streams---bloc---practical-use-cases)
* [Architect your Flutter with BLoC - Medium](https://medium.com/flutterpub/architecting-your-flutter-project-bd04e144a8f1)

# Running the app

## Get packages
`flutter packages get`

## Run the app
`flutter run`

# Important part of the code

The important stuff is found in `add_credit_card_bloc.dart` since detecting the card type is "business logic".

### add_credit_card_bloc.dart
```
...

import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class AddCreditCardBloc implements Bloc {
  // Streams for the input actions
  final _ccNumInputActionController = StreamController<String>();
  
  ...

  // Publicly accessible [Sink]s for updating the info
  Sink<String> get updateCCNum => _ccNumInputActionController.sink;

  ...

  //  Streams for changing the info
  final _ccTypeController = StreamController<CreditCardType>();
  final _ccNumController = StreamController<String>();

  // Publicly accessible [Streams]s for obtaining the changed info
  Stream<CreditCardType> get ccType => _ccTypeController.stream;
  Stream<String> get ccNum => _ccNumController.stream;

  AddCreditCardBloc() {
      // Send the new credit card number to the _onCCNumInput handler
    _ccNumInputActionController.stream.listen(_onCCNumInput);
  }

  void dispose() {
      // Dispose of everything correctly
    ...
  }

  _onCCNumInput(String newNum) {
    // Update the CC number
    _ccNumController.add(newNum);

    // HERE IS WHERE THE DETECTION HAPPENS
    // Determine the CC type and update it
    _ccTypeController.add(detectCCType(newNum));
  }

  ...
}

```

Here is a step-by-step explanation of how the data is passed around:
1. Every time a user changes the "CC number" text field the `_ccNumInputActionController` is notified and sent the new cc number string (This happens every time the user changes a single character in the text field).
2. This new string is then sent to the `_onCCNumInput` handler, where the call to `detectCCType` is made.
3. The cc type is then detected using the `credit_card_type_detector` package
4. The determined type is then "added" to the ccType Stream by calling `_ccTypeController.add(...)`
5. The StreamBuilder widget that is listening to the ccType Stream in `add_credit_card_screen.dart` is then notified and rebuilds itself depending on the cc type.