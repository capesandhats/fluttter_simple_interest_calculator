import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Intrest Application",
    home: SIForm(),
    theme: ThemeData(
      primaryColor: Colors.red[900],
      accentColor: Colors.redAccent,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _minimumPadding = 5.0;
  var _currencies = ["Dollar", "Ruppes", "Euro"];
  var _currentCurrency;
  String _totalReturn = "";

  var _formKey = GlobalKey<FormState>();

  TextEditingController principleTextController = new TextEditingController();
  TextEditingController roiTextController = new TextEditingController();
  TextEditingController termTextController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentCurrency = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = Theme.of(this.context).textTheme.title;

    var _errorStyle =
        TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 15.0);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Simple Interest Calculator",
            style: _textStyle,
          ),
        ),
        body: Form(
            key: _formKey,
//            margin: EdgeInsets.all(_minimumPadding * 1),
            child: Padding(
              padding: EdgeInsets.all(_minimumPadding * 1),
              child: ListView(
                children: <Widget>[
                  simpleInterestImage(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      style: _textStyle,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Principle",
                          hintText: "enter the priciple amount eg. 1000",
                          errorStyle: _errorStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      controller: principleTextController,
                      validator: (String inputValue) {
                        if (inputValue.isEmpty) {
                          return "Please enter valid priciple amount";
                        } else if (!_isPositiveNumber(inputValue)) {
                          return "Please enter valid priciple amount";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      style: _textStyle,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Rate of interest",
                          hintText: "Enter in percentage",
                          errorStyle: _errorStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      controller: roiTextController,
                      validator: (String inputValue) {
                        if (inputValue.isEmpty) {
                          return "Please enter valid ROI";
                        } else if (!_isPositiveNumber(inputValue)) {
                          return "Please enter valid ROI";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          style: _textStyle,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Term",
                              hintText: "enter period in years",
                              errorStyle: _errorStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          controller: termTextController,
                          validator: (String inputValue) {
                            if (inputValue.isEmpty) {
                              return "Please enter valid term";
                            } else if (!_isPositiveNumber(inputValue)) {
                              return "Please enter valid term";
                            }
                          },
                        )),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                          items: _currencies.map(
                            (String currency) {
                              return DropdownMenuItem<String>(
                                child: Text(
                                  currency,
                                  style: _textStyle,
                                ),
                                value: currency,
                              );
                            },
                          ).toList(),
                          value: _currentCurrency,
                          style: _textStyle,
                          onChanged: (String selectedValue) {
                            _onDropDownChanged(selectedValue);
                          },
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: buildButtonRow(context, _textStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Text(
                      _totalReturn,
                      style: _textStyle,
                    ),
                  )
                ],
              ),
            )));
  }

  Row buildButtonRow(BuildContext context, TextStyle _textStyle) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 60,
            child: RaisedButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColorDark,
                child: Text(
                  "Calculate",
                  style: _textStyle,
                ),
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      this._totalReturn = _calculateTotalReturn();
                    }
                  });
                }),
          ),
        ),
        Container(
          width: _minimumPadding * 5,
        ),
        Expanded(
          child: SizedBox(
            height: 60,
            child: RaisedButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text(
                  "Reset",
                  style: _textStyle,
                ),
                onPressed: () {
                  setState(() {
                    _resetFields();
                  });
                }),
          ),
        ),
      ],
    );
  }

  Widget simpleInterestImage() {
    var assetImage = AssetImage("images/simple_interest_logo.png");
    Image image = Image(
      image: assetImage,
      width: 150,
      height: 150,
      colorBlendMode: BlendMode.luminosity,
    );

    return Container(
      margin: EdgeInsets.only(
          left: _minimumPadding * 10,
          right: _minimumPadding * 10,
          top: _minimumPadding * 2),
      child: image,
    );
  }

  void _onDropDownChanged(selectedValue) {
    setState(() {
      this._currentCurrency = selectedValue;
    });
  }

  String _calculateTotalReturn() {
    double principle = double.parse(principleTextController.text);
    double roi = double.parse(roiTextController.text);
    double term = double.parse(termTextController.text);

    double totalReturn = principle + (principle * roi * term) / 100;
    var returnString =
        "total return your investiment is:  $totalReturn  $_currentCurrency";
    debugPrint(returnString);
    return returnString;
  }

  void _resetFields() {
    principleTextController.text = "";
    roiTextController.text = "";
    termTextController.text = "";
    _currentCurrency = _currencies[0];
    _totalReturn = "";
  }

  bool _isPositiveNumber(String inputValue) {
    var returnValue = double.tryParse(inputValue);
    debugPrint("print value :$returnValue");
    if (returnValue != null) {
      if (returnValue > 0) {
        return true;
      }
    }
    return false;
  }
}
