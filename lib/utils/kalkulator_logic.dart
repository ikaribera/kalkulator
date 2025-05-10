import 'package:math_expressions/math_expressions.dart';

class KalkulatorLogic {
  static String hitung(String input) {
    String truncateDouble(double value, int decimalPlaces) {
      String valueStr = value.toString();
      if (!valueStr.contains('.')) {
        return valueStr;
      }
      int dotIndex = valueStr.indexOf('.');
      int endIndex = dotIndex + 1 + decimalPlaces;
      if (endIndex > valueStr.length) {
        endIndex = valueStr.length;
      }
      return valueStr.substring(0, endIndex);
    }

    try {
      // Improved replacement for percentages like 'number%' even when followed by operators
      String ekspresi = input.replaceAllMapped(
          RegExp(r'(\d+(\.\d+)?)%'), (Match m) => '(${m.group(1)}*0.01)');

      ekspresi = ekspresi
          .replaceAll('x', '*')
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('√', 'sqrt')
          .replaceAll('π', 'pi')
          .replaceAll('e', 'e')
          .replaceAll('x!', 'factorial')
          .replaceAll('1/x', '1/')
          .replaceAll('xʸ', '^')
          .replaceAll('lg', 'log')
          .replaceAll('ln', 'log')
          .replaceAll('sin', 'sin');

      // Add parentheses around the entire expression to ensure correct parsing
      ekspresi = '($ekspresi)';

      Parser p = Parser();
      Expression exp = p.parse(ekspresi);
      ContextModel cm = ContextModel();

      double hasil = exp.evaluate(EvaluationType.REAL, cm);
      return truncateDouble(hasil, 4);
    } catch (e) {
      return 'Error';
    }
  }
}
