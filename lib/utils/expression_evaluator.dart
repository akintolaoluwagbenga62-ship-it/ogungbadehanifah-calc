import 'dart:math' as math;

/// A small recursive-descent parser/evaluator for calculator expressions.
/// Supports +, -, *, /, %, ^, !, parentheses, constants (pi, e) and
/// functions: sin, cos, tan, asin, acos, atan, sinh, cosh, tanh,
/// asinh, acosh, atanh, log, ln, sqrt, abs, exp.
class ExpressionEvaluator {
  final String expression;
  final bool isDegrees;
  int _pos = 0;

  ExpressionEvaluator(this.expression, {this.isDegrees = true});

  double evaluate() {
    _pos = 0;
    if (expression.trim().isEmpty) {
      throw const FormatException('Empty expression');
    }
    final result = _parseExpression();
    _skipWhitespace();
    if (_pos < expression.length) {
      throw FormatException('Unexpected character at position $_pos');
    }
    if (result.isNaN || result.isInfinite) {
      throw const FormatException('Result is undefined');
    }
    return result;
  }

  void _skipWhitespace() {
    while (_pos < expression.length && expression[_pos] == ' ') {
      _pos++;
    }
  }

  double _parseExpression() {
    double value = _parseTerm();
    while (true) {
      _skipWhitespace();
      if (_pos >= expression.length) break;
      final ch = expression[_pos];
      if (ch == '+') {
        _pos++;
        value += _parseTerm();
      } else if (ch == '-') {
        _pos++;
        value -= _parseTerm();
      } else {
        break;
      }
    }
    return value;
  }

  double _parseTerm() {
    double value = _parseFactor();
    while (true) {
      _skipWhitespace();
      if (_pos >= expression.length) break;
      final ch = expression[_pos];
      if (ch == '*') {
        _pos++;
        value *= _parseFactor();
      } else if (ch == '/') {
        _pos++;
        final divisor = _parseFactor();
        if (divisor == 0) throw Exception('Division by zero');
        value /= divisor;
      } else if (ch == '%') {
        _pos++;
        value = value % _parseFactor();
      } else {
        break;
      }
    }
    return value;
  }

  double _parseFactor() {
    double value = _parseUnary();
    _skipWhitespace();
    if (_pos < expression.length && expression[_pos] == '^') {
      _pos++;
      final exponent = _parseUnary();
      value = math.pow(value, exponent).toDouble();
    }
    return value;
  }

  double _parseUnary() {
    _skipWhitespace();
    if (_pos < expression.length && expression[_pos] == '-') {
      _pos++;
      return -_parseUnary();
    }
    if (_pos < expression.length && expression[_pos] == '+') {
      _pos++;
      return _parseUnary();
    }
    return _parsePostfix();
  }

  double _parsePostfix() {
    double value = _parsePrimary();
    _skipWhitespace();
    while (_pos < expression.length && expression[_pos] == '!') {
      _pos++;
      value = _factorial(value);
      _skipWhitespace();
    }
    return value;
  }

  double _factorial(double n) {
    if (n < 0 || n != n.roundToDouble() || n > 170) {
      throw Exception('Factorial requires a non-negative integer <= 170');
    }
    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  double _parsePrimary() {
    _skipWhitespace();
    if (_pos >= expression.length) {
      throw const FormatException('Unexpected end of expression');
    }

    final ch = expression[_pos];

    if (ch == '(') {
      _pos++;
      final value = _parseExpression();
      _skipWhitespace();
      if (_pos >= expression.length || expression[_pos] != ')') {
        throw const FormatException('Expected closing parenthesis');
      }
      _pos++;
      return value;
    }

    if (RegExp(r'[0-9.]').hasMatch(ch)) {
      return _parseNumber();
    }

    if (RegExp(r'[a-zA-Z]').hasMatch(ch)) {
      return _parseFunctionOrConstant();
    }

    throw FormatException('Unexpected character: $ch');
  }

  double _parseNumber() {
    final start = _pos;
    while (_pos < expression.length &&
        RegExp(r'[0-9.]').hasMatch(expression[_pos])) {
      _pos++;
    }
    final text = expression.substring(start, _pos);
    if (text == '.' || text.isEmpty) {
      throw const FormatException('Invalid number');
    }
    return double.parse(text);
  }

  String _parseIdentifier() {
    final start = _pos;
    while (_pos < expression.length &&
        RegExp(r'[a-zA-Z]').hasMatch(expression[_pos])) {
      _pos++;
    }
    return expression.substring(start, _pos);
  }

  double _parseFunctionOrConstant() {
    final identifier = _parseIdentifier();

    switch (identifier) {
      case 'pi':
        return math.pi;
      case 'e':
        return math.e;
    }

    _skipWhitespace();
    if (_pos >= expression.length || expression[_pos] != '(') {
      throw FormatException('Expected ( after $identifier');
    }
    _pos++;
    final arg = _parseExpression();
    _skipWhitespace();
    if (_pos >= expression.length || expression[_pos] != ')') {
      throw const FormatException('Expected ) after function argument');
    }
    _pos++;

    return _applyFunction(identifier, arg);
  }

  double _toRadians(double deg) => deg * math.pi / 180;
  double _toDegrees(double rad) => rad * 180 / math.pi;

  double _applyFunction(String name, double arg) {
    switch (name) {
      case 'sin':
        return math.sin(isDegrees ? _toRadians(arg) : arg);
      case 'cos':
        return math.cos(isDegrees ? _toRadians(arg) : arg);
      case 'tan':
        return math.tan(isDegrees ? _toRadians(arg) : arg);
      case 'asin':
        final r = math.asin(arg);
        return isDegrees ? _toDegrees(r) : r;
      case 'acos':
        final r = math.acos(arg);
        return isDegrees ? _toDegrees(r) : r;
      case 'atan':
        final r = math.atan(arg);
        return isDegrees ? _toDegrees(r) : r;
      case 'sinh':
        return (math.exp(arg) - math.exp(-arg)) / 2;
      case 'cosh':
        return (math.exp(arg) + math.exp(-arg)) / 2;
      case 'tanh':
        final e2 = math.exp(2 * arg);
        return (e2 - 1) / (e2 + 1);
      case 'asinh':
        return math.log(arg + math.sqrt(arg * arg + 1));
      case 'acosh':
        if (arg < 1) throw Exception('acosh requires arg >= 1');
        return math.log(arg + math.sqrt(arg * arg - 1));
      case 'atanh':
        if (arg <= -1 || arg >= 1) throw Exception('atanh requires -1 < arg < 1');
        return 0.5 * math.log((1 + arg) / (1 - arg));
      case 'log':
        if (arg <= 0) throw Exception('log requires a positive argument');
        return math.log(arg) / math.ln10;
      case 'ln':
        if (arg <= 0) throw Exception('ln requires a positive argument');
        return math.log(arg);
      case 'sqrt':
        if (arg < 0) throw Exception('Cannot take sqrt of a negative number');
        return math.sqrt(arg);
      case 'abs':
        return arg.abs();
      case 'exp':
        return math.exp(arg);
      default:
        throw FormatException('Unknown function: $name');
    }
  }
}
