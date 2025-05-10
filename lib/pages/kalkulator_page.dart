import 'package:flutter/material.dart';
import '../pages/kalkulator_button.dart';
import '../controllers/kalkulator_controller.dart';

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  _KalkulatorPageState createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  late KalkulatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = KalkulatorController();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  String _formatInputDisplay(String input) {
    return input.replaceAll('*', '×').replaceAll('/', '÷');
  }

  Widget _buildButtonRow(List<KalkulatorButton> buttons) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: buttons),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kalkulator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_formatInputDisplay(_controller.input),
                      style: TextStyle(fontSize: 32)),
                  Text(_controller.output,
                      style: TextStyle(fontSize: 24, color: Colors.grey))
                ],
              ),
            ),
          ),
          _buildButtonRow([
            KalkulatorButton(
                label: 'AC',
                onTap: () => _controller.onButtonPressed('AC'),
                color: Color(0xFFE04E39)),
            KalkulatorButton(
                label: 'π',
                onTap: () => _controller.onButtonPressed('π'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '%',
                onTap: () => _controller.onButtonPressed('%'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '+',
                onTap: () => _controller.onButtonPressed('+'),
                color: Color(0xFFF18F01),
                textColor: Colors.white),
          ]),
          _buildButtonRow([
            KalkulatorButton(
                label: '1',
                onTap: () => _controller.onButtonPressed('1'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '2',
                onTap: () => _controller.onButtonPressed('2'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '3',
                onTap: () => _controller.onButtonPressed('3'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '-',
                onTap: () => _controller.onButtonPressed('-'),
                color: Color(0xFFF18F01)),
          ]),
          _buildButtonRow([
            KalkulatorButton(
                label: '4',
                onTap: () => _controller.onButtonPressed('4'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '5',
                onTap: () => _controller.onButtonPressed('5'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '6',
                onTap: () => _controller.onButtonPressed('6'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '×',
                onTap: () => _controller.onButtonPressed('*'),
                color: Color(0xFFF18F01)),
          ]),
          _buildButtonRow([
            KalkulatorButton(
                label: '7',
                onTap: () => _controller.onButtonPressed('7'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '8',
                onTap: () => _controller.onButtonPressed('8'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '9',
                onTap: () => _controller.onButtonPressed('9'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '÷',
                onTap: () => _controller.onButtonPressed('/'),
                color: Color(0xFFF18F01)),
          ]),
          _buildButtonRow([
            KalkulatorButton(
                label: '0',
                onTap: () => _controller.onButtonPressed('0'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '.',
                onTap: () => _controller.onButtonPressed('.'),
                color: Color(0xFF9E9E9E)),
            KalkulatorButton(
                label: '⌫',
                onTap: () => _controller.onButtonPressed('⌫'),
                color: Color.fromARGB(255, 224, 88, 34)),
            KalkulatorButton(
                label: '=',
                onTap: () => _controller.onButtonPressed('='),
                color: Color(0xFF4CAF50)),
          ]),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
