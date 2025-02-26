// Libraries
//import 'package:flutter/material.dart';
import 'package:credit_card_type_detector/constants.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:example2/blocs/add_credit_card_bloc.dart';
import 'package:example2/blocs/bloc.dart';

// Packages
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Local imports

import 'package:flutter/material.dart';

// Local imports

class AddCreditCardScreen extends StatelessWidget {
  late BuildContext _context;
  late AddCreditCardBloc _addCardBloc;
  final _addCCFormKey = GlobalKey<FormState>(debugLabel: "addCCForm");
  final FocusNode _ccNumFocus = FocusNode();
  final FocusNode _expDateFocus = FocusNode();
  final FocusNode _cvvFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  final MaskedTextController _ccNumMask = MaskedTextController(
    mask: "0000 0000 0000 0000",
  );
  final MaskedTextController _expMask = MaskedTextController(mask: "00/00");

  AddCreditCardScreen({super.key});

  Widget _creditCardWidget() {
    Size deviceSize = MediaQuery.of(_context).size;
    double ccIconSize = 50.0;
    double ccDrawingHeight = deviceSize.height * 0.3;
    double ccDrawingWidth = deviceSize.width * 0.8;

    return Container(
      height: ccDrawingHeight,
      color: const Color(0xffe0e0e0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Center(
          child: Container(
            width: ccDrawingWidth,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              gradient: LinearGradient(
                colors: [Color(0xff535252), Color(0xff211e1e)],
              ),
            ),

            // Overlay with credit card info
            child: Stack(
              children: <Widget>[
                // Credit Card number
                Positioned(
                  left: 20.0,
                  top: 30.0,
                  child: StreamBuilder<String>(
                    stream: _addCardBloc.ccNum,
                    initialData: "XXXX XXXX XXXX XXXX",
                    builder: (context, snapshot) {
                      if (snapshot.data!.isNotEmpty) {
                        _ccNumMask.updateText(snapshot.data!);
                      }

                      return Text(
                        snapshot.data!.isNotEmpty
                            ? snapshot.data!
                            : "XXXX XXXX XXXX XXXX",
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 20.0,
                        ),
                      );
                    },
                  ),
                ),

                // Credit Card Type Icon
                // Credit Card Type Icon
                Positioned(
                  right: 20.0,
                  top: 15.0,
                  child: StreamBuilder<CreditCardType>(
                    stream: _addCardBloc.ccType,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<CreditCardType> snapshot,
                    ) {
                      Widget icon;
                      // If there's no data yet or it's an unknown type, return an empty container
                      if (!snapshot.hasData ||
                          snapshot.data?.type == null ||
                          snapshot.data?.type == 'unknown') {
                        return Container();
                      }

                      CreditCardType currType = snapshot.data!;
                      switch (currType.type) {
                        case TYPE_VISA:
                          icon = Icon(
                            FontAwesomeIcons.ccVisa,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case TYPE_AMEX:
                          icon = Icon(
                            FontAwesomeIcons.ccAmex,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case TYPE_MAESTRO:
                        case TYPE_MASTERCARD:
                          icon = Icon(
                            FontAwesomeIcons.ccMastercard,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case TYPE_DISCOVER:
                          icon = Icon(
                            FontAwesomeIcons.ccDiscover,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case TYPE_DINERS_CLUB:
                          icon = Icon(
                            FontAwesomeIcons.ccDinersClub,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case TYPE_JCB:
                          icon = Icon(
                            FontAwesomeIcons.ccJcb,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;
                        case TYPE_RUPAY:
                          icon = Text(
                            "RuPay",
                            style: TextStyle(
                              color: const Color(0xFF37398B),
                              fontSize: ccIconSize * 0.4,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                          break;

                        // Don't show any icon by default
                        default:
                          icon = Container();
                      }

                      return icon;
                    },
                  ),
                ),

                // Expiration Date
                Positioned(
                  left: 20.0,
                  bottom: 60.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StreamBuilder<String>(
                        stream: _addCardBloc.expDate,
                        initialData: "MM/YY",
                        builder: (context, snapshot) {
                          if (snapshot.data!.isNotEmpty) {
                            _expMask.updateText(snapshot.data!);
                          }

                          return Text(
                            snapshot.data!.isNotEmpty
                                ? snapshot.data!
                                : "MM/YY",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xffffffff),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // CVV Code
                Positioned(
                  right: 20.0,
                  bottom: 60.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StreamBuilder<String>(
                        stream: _addCardBloc.cvv,
                        initialData: "CVV/CVC",
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data!.isNotEmpty
                                ? snapshot.data!
                                : "CVV/CVC",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xffffffff),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Cardholder Name
                Positioned(
                  left: 20.0,
                  bottom: 20.0,
                  child: StreamBuilder<String>(
                    stream: _addCardBloc.cardholderName,
                    initialData: "Cardholder Name",
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data!,
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputSection() {
    Size deviceSize = MediaQuery.of(_context).size;

    return Container(
      height: deviceSize.height * 0.1,
      width: deviceSize.width,
      child: Form(
        key: _addCCFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 250.0,
                child: TextField(
                  controller: _ccNumMask,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _ccNumFocus,
                  onSubmitted: (submission) {
                    _ccNumFocus.unfocus();
                    FocusScope.of(_context).requestFocus(_expDateFocus);
                  },
                  autofocus: true,
                  maxLength: 19,
                  style: const TextStyle(color: Color(0xff000000)),
                  onChanged:
                      (newCCNum) =>
                          _addCardBloc.updateCCNum.add(_ccNumMask.text),
                  decoration: const InputDecoration(
                    labelText: "Credit Card Number",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 100.0,
                child: TextField(
                  controller: _expMask,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _expDateFocus,
                  onSubmitted: (submission) {
                    _expDateFocus.unfocus();
                    FocusScope.of(_context).requestFocus(_cvvFocus);
                  },
                  maxLength: 5,
                  style: const TextStyle(color: Color(0xff000000)),
                  onChanged:
                      (newExp) => _addCardBloc.updateExp.add(_expMask.text),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelText: "MM/YY",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 100.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _cvvFocus,
                  onSubmitted: (submission) {
                    _cvvFocus.unfocus();
                    FocusScope.of(_context).requestFocus(_nameFocus);
                  },
                  maxLength: 3,
                  style: const TextStyle(color: Color(0xff000000)),
                  onChanged: (newCvv) => _addCardBloc.updateCvv.add(newCvv),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelText: "CVV/CVC",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  focusNode: _nameFocus,
                  onSubmitted: (submission) {
                    _nameFocus.unfocus();
                  },
                  maxLength: 20,
                  style: const TextStyle(color: Color(0xff000000)),
                  onChanged: (newName) => _addCardBloc.updateName.add(newName),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelText: "Cardholder Name",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonBar() {
    Size deviceSize = MediaQuery.of(_context).size;

    Widget child = Container();
    // TODO Figure out how to change this through a form validationBLoC
    bool validated = true;
    if (validated) {
      child = Container(
        child: MaterialButton(
          child: const Text(
            "Save Card",
            style: TextStyle(
              color: Color(0xffffffff),
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          minWidth: deviceSize.width,
          height: 50.0,
          color: const Color(0xff4CD964),
          elevation: 0.0,
          onPressed: _saveCard,
        ),
      );
    }

    return child;
  }

  void _saveCard() {
    // Implement your save card logic here
    print("Saving card...");
    // You might want to validate the form before proceeding
    if (_addCCFormKey.currentState?.validate() ?? false) {
      // Implement your save logic
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _addCardBloc = BlocProvider.of<AddCreditCardBloc>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xffffffff),
        title: const Text(
          "Add Credit Card",
          style: TextStyle(color: Color(0xff000000), fontSize: 18),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _creditCardWidget(),
          _inputSection(),
          Expanded(child: Center(child: _buttonBar())),
        ],
      ),
    );
  }
}
