import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;
  late TextEditingController _resultController;
  bool _validate = false;
  double _moneyAmount = 0;
  double _result = 0;
  double _input = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _resultController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void _convertToEuro(){
    _input = double.parse(_controller.text);
    _result = (_input * 4.95) as double;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              height: 270,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage('assets/images/currencyConverterImage.jpg'),
                    fit: BoxFit.cover),
              ),
              child: const SizedBox()),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Enter your number",
              errorText: _validate ? 'Value Can\'t Be Empty' : null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
          ),
          TextButton(
            child: const Text(
              'Calculate',
              style: TextStyle(fontSize: 20.0, color: Colors.pink),
            ),
            onPressed: () {
              setState(() {
                _controller.text.isEmpty ? _validate = true : _validate = false;
                //if(_validate){
                  _convertToEuro();
                //}
              });
            },
          ),
          Text(_result.toString()),
        ],
      ),
    );
  }
}
