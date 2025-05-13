import 'package:flutter/material.dart';
import '../utils/kalkulator_logic.dart';

class KalkulatorController extends ChangeNotifier {
  String _input = '';
  String _output = '';
  bool _isResultShown = false;

  String get input => _input;
  String get output => _output;

  final List<String> _operators = ['+', '-', '/', '*', '^', '.', '%'];
  bool get isResultShown => _isResultShown;

  // Tambahan: History
  final List<Map<String, String>> _history = [];
  List<Map<String, String>> get history => _history;

  // Validasi ekspresi matematika
  bool _isValidInput(String input) {
    final regex = RegExp(r'^[0-9+\-x*/().%]+$');
    if (!regex.hasMatch(input)) return false;

    int balance = 0;
    for (final char in input.runes) {
      if (String.fromCharCode(char) == '(') balance++;
      if (String.fromCharCode(char) == ')') balance--;
      if (balance < 0) return false;
    }
    return balance == 0;
  }

  // Hitung hasil
  void _calculateOutput() {
    if (_input.isEmpty) {
      _output = '';
      return;
    }

    final lastChar = _input[_input.length - 1];
    final containsOperator = _operators.any(_input.contains);

    if (!containsOperator ||
        (_operators.contains(lastChar) && lastChar != '%')) {
      _output = '';
      return;
    }

    if (!_isValidInput(_input)) {
      _output = 'Invalid Input: Please check your expression';
      return;
    }

    try {
      final result = KalkulatorLogic.hitung(_input);
      final val = double.tryParse(result);
      _output = (val != null && val % 1 == 0) ? val.toInt().toString() : result;
    } catch (e) {
      _output = 'Error: ${e.toString()}';
    }
  }

  // Reset kalkulator
  void _reset() {
    _input = '';
    _output = '';
    _isResultShown = false;
  }

  // Tombol "=" ditekan
  void _handleEquals() {
    if (_isResultShown) return;

    _calculateOutput();

    final lastChar = _input.isNotEmpty ? _input[_input.length - 1] : '';
    final containsOperator = _operators.any(_input.contains);

    if (!containsOperator ||
        (_operators.contains(lastChar) && lastChar != '%')) {
      return;
    }

    // Simpan ke history jika hasil valid
    if (_output.isNotEmpty && !_output.startsWith('Error')) {
      _history.add({
        'input': _input,
        'output': _output,
      });
    }

    _input = _output;
    _isResultShown = true;
  }

  // Hapus karakter terakhir
  void _handleDelete() {
    if (_input.isNotEmpty) {
      _input = _input.substring(0, _input.length - 1);
      _calculateOutput();
    }
    _isResultShown = false;
  }

  // Tangani operator
  void _handleOperator(String value) {
    final lastChar = _input.isNotEmpty ? _input[_input.length - 1] : '';
    if (_input.isEmpty) return;

    if (lastChar == '%') {
      _input += value;
    } else if (_operators.contains(lastChar)) {
      _input = _input.substring(0, _input.length - 1) + value;
    } else {
      _input += value;
    }
  }

  // Tangani titik desimal
  void _handleDot() {
    final lastChar = _input.isNotEmpty ? _input[_input.length - 1] : '';

    if (_input.isEmpty || _operators.contains(lastChar)) {
      if (!_input.endsWith('0.')) _input += '0.';
      return;
    }

    final parts = _input.split(RegExp(r'[+\-*/^()]'));
    if (parts.isNotEmpty && parts.last.contains('.')) return;

    _input += '.';
  }

  // Fungsi spesial seperti π, faktorial, 1/x
  void _handleSpecialFunction(String value) {
    switch (value) {
      case 'π':
        _input += '3.14';
        break;
      case 'x!':
        final num = int.tryParse(_input);
        if (num != null && num >= 0) {
          _output = List.generate(num, (i) => i + 1)
              .fold(1, (a, b) => a * b)
              .toString();
        } else {
          _output = 'Error: Invalid factorial input';
        }
        break;
      case '1/x':
        final num = double.tryParse(_input);
        if (num != null && num != 0) {
          _output = (1 / num).toStringAsFixed(6);
        } else {
          _output = 'Error: Division by zero';
        }
        break;
    }
  }

  // Clear semua riwayat (opsional)
  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  // Tombol ditekan
  void onButtonPressed(String value) {
    switch (value) {
      case 'AC':
        _reset();
        break;
      case '=':
        _handleEquals();
        break;
      case '⌫':
        _handleDelete();
        break;
      case 'π':
      case 'x!':
      case '1/x':
        _handleSpecialFunction(value);
        break;
      case '.':
        _handleDot();
        break;
      case '%':
        if (_input.isNotEmpty &&
            (RegExp(r'[0-9]$').hasMatch(_input) || _input.endsWith(')'))) {
          _input += '%';
        }
        break;
      case 'CH': // Clear History
        clearHistory();
        break;
      default:
        if (_isResultShown) {
          if (_operators.contains(value)) {
            // Operator → lanjutkan perhitungan dengan hasil sebelumnya
            _input = _output + value;
          } else {
            // Angka atau titik → mulai perhitungan baru
            _input = value;
          }
          _output = '';
          _isResultShown = false;
        } else if (_operators.contains(value)) {
          _handleOperator(value);
        } else {
          _input += value;
        }
        break;
    }

    notifyListeners();
  }
}
