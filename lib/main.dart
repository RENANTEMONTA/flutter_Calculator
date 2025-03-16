import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String input = ''; // Stores user input
  String result = '0'; // Stores calculated result

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '0';
      } else if (value == '⌫') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == '=') {
        result = calculateResult();
      } else if (value == '%') {
        // Ensure % is applied to a SINGLE number
        if (input.isNotEmpty && RegExp(r'^\d+$').hasMatch(input)) {
          input = '(${input}/100)'; // Convert to valid percentage
        } else {
          result = 'Error'; // Show error if misused
        }
      } else {
        input += value;
      }
    });
  }

  String calculateResult() {
    try {
      String formattedInput = input.replaceAll('x', '*');

      Parser p = Parser();
      Expression exp = p.parse(formattedInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

  Widget buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(20),
          ),
          child: Text(text, style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red[400],
          title: Text("Calculator App", style: TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(24),
                child: Text(input, style: TextStyle(fontSize: 40)),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(24),
                child: Text(result, style: TextStyle(fontSize: 40)),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(children: [buildButton('C'), buildButton('⌫'), buildButton('/'), buildButton('x')]),
                  Row(children: [buildButton('7'), buildButton('8'), buildButton('9'), buildButton('-')]),
                  Row(children: [buildButton('4'), buildButton('5'), buildButton('6'), buildButton('+')]),
                  Row(children: [buildButton('1'), buildButton('2'), buildButton('3'), buildButton('=')]),
                  Row(children: [buildButton('%'), buildButton('0'), buildButton('.')]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
