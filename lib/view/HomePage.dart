import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textFormController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _inputAmount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textFormController.dispose();
    super.dispose();
  }

  // convert the input into RON
  void _convertToEuro() {
    var text = _textFormController.text.replaceAll(" EUR", '');
    // If input is 0, replace it with a string '0'
    if (RegExp(r'^0(\.0+)').hasMatch(text)) {
      _textFormController.value = const TextEditingValue(text: '0');
      text = 0 as String;
    }

    // Validate the form and input, then calculate the amount
    _formKey.currentState!.validate() && _textFormController.text == ''
        ? _inputAmount = 0
        : _inputAmount = double.parse(text) * 4.9;
  }

  // Validate the input value
  String? validate(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }

    // Regex pattern to allow digits, decimal point, and ' EUR' at the end of the string
    final numberPattern = RegExp(r'^\d*\.?\d{0,13}( EUR)?$');
    if (!numberPattern.hasMatch(value)) {
      return 'Please enter a valid number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              height: 270,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/currencyConverterImage.jpg'),
                      fit: BoxFit.cover)),
              child: const SizedBox()),
          Form(
              key: _formKey,
              child: TextFormField(
                  controller: _textFormController,
                  validator: (value) {
                    return validate(value);
                  },
                  decoration:
                      const InputDecoration(labelText: "Enter your number"),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  //  Allow digits, decimal point, and ' RON' at the end of the string),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,13}( EUR)?$'))
                  ],
                  maxLength: 16,
                  // actually it is 12, because of ' RON'
                  onChanged: (text) {
                    // Manipulate the input text
                    final updatedText =
                        text.replaceAll(' EUR', '').trim() + ' EUR';
                    if (updatedText != _textFormController.text) {
                      final cursorPosition = updatedText.indexOf(' EUR');
                      _textFormController.value = _textFormController.value
                          .copyWith(
                              text: updatedText,
                              selection: TextSelection.collapsed(
                                  offset: cursorPosition));
                    }
                  })),
          TextButton(
              child: const Text('Calculate',
                  style: TextStyle(fontSize: 20.0, color: Colors.pink)),
              onPressed: () {
                setState(() {});
                _convertToEuro();
              }),
          Text(_inputAmount != 0
              ? _inputAmount.round() == _inputAmount
                  ? _inputAmount.toString()
                  : '${_inputAmount.toStringAsFixed(2)} RON' // Removes the 0's after result
              : '0 RON')
        ],
      ),
    );
  }
}
