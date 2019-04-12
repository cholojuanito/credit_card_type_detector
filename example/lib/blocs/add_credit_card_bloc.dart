import 'dart:async';

import 'package:credit_card_type_detector/credit_card_type_detector.dart';

import './bloc.dart';

class AddCreditCardBloc implements Bloc {
  /// Streams for the input actions
  final _ccNumInputActionController = StreamController<String>();
  final _expInputActionController = StreamController<String>();
  final _nameInputActionController = StreamController<String>();
  final _cvvInputActionController = StreamController<String>();

  /// Publicly accessible [Sink]s for updating the info
  Sink<String> get updateCCNum => _ccNumInputActionController.sink;
  Sink<String> get updateExp => _expInputActionController.sink;
  Sink<String> get updateName => _nameInputActionController.sink;
  Sink<String> get updateCvv => _cvvInputActionController.sink;

  ///  Streams for changing the info
  final _ccTypeController = StreamController<CreditCardType>();
  final _ccNumController = StreamController<String>();
  final _expController = StreamController<String>();
  final _nameController = StreamController<String>();
  final _cvvController = StreamController<String>();

  /// Publicly accessible [Streams]s for obtaining the changed info
  Stream<CreditCardType> get ccType => _ccTypeController.stream;
  Stream<String> get ccNum => _ccNumController.stream;
  Stream<String> get expDate => _expController.stream;
  Stream<String> get cardholderName => _nameController.stream;
  Stream<String> get cvv => _cvvController.stream;

  AddCreditCardBloc() {
    _ccNumInputActionController.stream.listen(_onCCNumInput);
    _expInputActionController.stream.listen(_onExpInput);
    _nameInputActionController.stream.listen(_onNameInput);
    _cvvInputActionController.stream.listen(_onCvvInput);
  }

  void dispose() {
    _ccNumInputActionController?.close();
    _cvvInputActionController?.close();
    _expInputActionController?.close();
    _nameInputActionController?.close();

    _ccTypeController?.close();
    _ccNumController?.close();
    _expController?.close();
    _nameController?.close();
    _cvvController?.close();
  }

  _onCCNumInput(String newNum) {
    // Update the CC number
    _ccNumController.add(newNum);

    // Determine the CC type and update it
    _ccTypeController.add(detectCCType(newNum));
  }

  _onExpInput(String newExp) {
    _expController.add(newExp);
  }

  _onNameInput(String newName) {
    _nameController.add(newName);
  }

  _onCvvInput(String newCvv) {
    _cvvController.add(newCvv);
  }

  void ccFormat(String s) {
    print(s);
    updateCCNum.add(s);
  }
}
