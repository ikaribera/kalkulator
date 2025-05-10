import 'package:flutter/material.dart';
import '../utils/kalkulator_logic.dart';

class KalkulatorController extends ChangeNotifier {
  String _input = '';
  String _output = '';
  bool _isResultShown = false;

  String get input => _input;
  String get output => _output;

  final List<String> _operators = ['+', '-', '/', '*', '^', '.', '%'];

  bool _isValidInput(String input) {
    final regex = RegExp(r'^[0-9+\-x*/().%]+$');
    if (!regex.hasMatch(input)) return false;

    // Check for balanced parentheses
    int balance = 0;
    for (int i = 0; i < input.length; i++) {
      if (input[i] == '(') {
        balance++;
      } else if (input[i] == ')') balance--;
      if (balance < 0) return false; // Closing before opening
    }
    if (balance != 0) return false;

    return true;
  }

  void _calculateOutput() {
    if (_input.isEmpty) {
      _output = '';
      return;
    }

    // Jangan tampilkan output jika input hanya angka tanpa operator
    bool containsOperator = _operators.any((op) => _input.contains(op));
    if (!containsOperator) {
      _output = '';
      return;
    }

    // Jangan tampilkan output jika input berakhir dengan operator selain '%'
    String lastChar = _input[_input.length - 1];
    if (_operators.contains(lastChar) && lastChar != '%') {
      _output = '';
      return;
    }

    if (_isValidInput(_input)) {
      try {
        final result = KalkulatorLogic.hitung(_input);
        final val = double.tryParse(result);
        if (val != null && val % 1 == 0) {
          _output = val.toInt().toString();
        } else {
          _output = result;
        }
      } catch (e) {
        _output = 'Error: ${e.toString()}';
      }
    } else {
      _output = 'Invalid Input: Please check your expression';
    }
  }

  void onButtonPressed(String value) {
    if (value == 'AC') {
      _input = '';
      _output = '';
      _isResultShown = false;
    } else if (value == '=') {
      if (!_isResultShown) {
        _calculateOutput();
        String lastChar = _input.isNotEmpty ? _input[_input.length - 1] : '';
        bool containsOperator = _operators.any((op) => _input.contains(op));
        if (_operators.contains(lastChar) && lastChar != '%') {
          // Jangan hapus input jika berakhir dengan operator selain '%'
          // biarkan input tetap ada
        } else if (!containsOperator) {
          // Jika input hanya angka tanpa operator, jangan hapus input
          // biarkan input tetap ada
        } else {
          // Hapus input dan hanya tampilkan output
          _input = '';
        }
        _isResultShown = true;
      }
      // Jika sudah menampilkan hasil, tekan '=' lagi tidak mengubah apa-apa
    } else if (value == '⌫') {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
        _calculateOutput();
      }
      _isResultShown = false;
    } else if (_isResultShown) {
      // Jika hasil sudah ditampilkan dan user menekan tombol
      if (value == '%') {
        // Khusus untuk %, tambahkan % ke output lalu jadikan input baru
        _input = '$_output%';
        _output = '';
        _isResultShown = false;
      } else if (_operators.contains(value)) {
        // Jika tombol adalah operator selain %, lanjutkan perhitungan dengan hasil sebelumnya
        _input = _output + value;
        _output = '';
        _isResultShown = false;
      } else {
        // Jika tombol adalah angka atau lainnya, lanjutkan input tanpa menghapus input sebelumnya
        _input += value;
        _output = '';
        _isResultShown = false;
      }
    } else {
      String lastChar = _input.isNotEmpty ? _input[_input.length - 1] : '';
      if (value == '.') {
        if (_input.isEmpty || _operators.contains(lastChar)) {
          if (!_input.endsWith('0.')) {
            _input += '0.';
          }
        } else {
          final parts = _input.split(RegExp(r'[+\-*/^()]'));
          final lastNumber = parts.isNotEmpty ? parts.last : '';
          if (lastNumber.contains('.')) return;
          _input += value;
        }
      } else if (value == '%') {
        if (_input.isNotEmpty &&
            (RegExp(r'[0-9]$').hasMatch(_input) || _input.endsWith(')'))) {
          _input += '%';
        }
      } else if (value == 'π') {
        _input += '3.14';
      } else if (value == 'x!') {
        try {
          final num = int.tryParse(_input);
          if (num != null && num >= 0) {
            int result = 1;
            for (int i = 1; i <= num; i++) {
              result *= i;
            }
            _output = result.toString();
          } else {
            _output = 'Error: Invalid factorial input';
          }
        } catch (e) {
          _output = 'Error: ${e.toString()}';
        }
      } else if (value == '1/x') {
        try {
          final num = double.tryParse(_input);
          if (num != null && num != 0) {
            _output = (1 / num).toStringAsFixed(6);
          } else {
            _output = 'Error: Division by zero';
          }
        } catch (e) {
          _output = 'Error: ${e.toString()}';
        }
      } else if (_operators.contains(value)) {
        if (_input.isEmpty) {
          return;
        }
        if (lastChar == '%') {
          // Jika input berakhir dengan %, dan user input operator, tambahkan operator setelah %
          _input += value;
        } else if (_operators.contains(lastChar)) {
          // Jika input berakhir dengan operator, ganti operator terakhir dengan yang baru
          _input = _input.substring(0, _input.length - 1) + value;
        } else {
          _input += value;
        }
      } else {
        if (lastChar != '' &&
            _operators.contains(lastChar) &&
            !_isResultShown) {
          // Jika input berakhir dengan operator dan user input angka, lanjutkan perhitungan
          _input += value;
        } else if (_isResultShown) {
          // Jika hasil sudah ditampilkan dan user input angka, lanjutkan input tanpa menghapus input sebelumnya
          _input += value;
          _output = '';
          _isResultShown = false;
          notifyListeners();
          return;
        } else {
          _input += value;
        }
      }
      _calculateOutput();
    }
    notifyListeners();
  }
}
