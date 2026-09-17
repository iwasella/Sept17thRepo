import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff176b87),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xfff3f7f8),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _firstOperand;
  String? _operator;
  bool _waitingForOperand = false;

  void _inputDigit(String digit) {
    setState(() {
      if (_waitingForOperand || _display == '0' || _display == 'Error') {
        _display = digit;
        _waitingForOperand = false;
      } else {
        _display += digit;
      }
    });
  }

  void _inputDecimal() {
    setState(() {
      if (_waitingForOperand || _display == 'Error') {
        _display = '0.';
        _waitingForOperand = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _chooseOperator(String operator) {
    setState(() {
      final currentValue = double.tryParse(_display) ?? 0;
      if (_firstOperand != null && _operator != null && !_waitingForOperand) {
        _display = _formatNumber(
          _calculate(_firstOperand!, currentValue, _operator!),
        );
      } else {
        _firstOperand = currentValue;
      }
      _operator = operator;
      _waitingForOperand = true;
    });
  }

  void _calculateResult() {
    if (_firstOperand == null || _operator == null) return;

    setState(() {
      final secondOperand = double.tryParse(_display) ?? 0;
      if (_operator == '/' && secondOperand == 0) {
        _display = 'Error';
      } else {
        _display = _formatNumber(
          _calculate(_firstOperand!, secondOperand, _operator!),
        );
      }
      _firstOperand = null;
      _operator = null;
      _waitingForOperand = true;
    });
  }

  double _calculate(double first, double second, String operator) {
    return switch (operator) {
      '+' => first + second,
      '-' => first - second,
      '×' => first * second,
      '/' => first / second,
      _ => second,
    };
  }

  String _formatNumber(double number) {
    if (number == number.truncateToDouble()) return number.toInt().toString();
    return number.toString();
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstOperand = null;
      _operator = null;
      _waitingForOperand = false;
    });
  }

  void _toggleSign() {
    if (_display == '0' || _display == 'Error') return;
    setState(() {
      _display = _display.startsWith('-')
          ? _display.substring(1)
          : '-$_display';
    });
  }

  void _percent() {
    final value = double.tryParse(_display);
    if (value == null) return;
    setState(() => _display = _formatNumber(value / 100));
  }

  Widget _button(
    String label, {
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.white,
            foregroundColor: foregroundColor ?? const Color(0xff17333b),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(vertical: 21),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simple Calculator',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _display,
                      key: const Key('calculator-display'),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff17333b),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 18),
              decoration: const BoxDecoration(
                color: Color(0xffdcebed),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _button(
                        'C',
                        onPressed: _clear,
                        backgroundColor: const Color(0xffb8d8dc),
                        foregroundColor: const Color(0xff124c5d),
                      ),
                      _button(
                        '±',
                        onPressed: _toggleSign,
                        backgroundColor: const Color(0xffb8d8dc),
                        foregroundColor: const Color(0xff124c5d),
                      ),
                      _button(
                        '%',
                        onPressed: _percent,
                        backgroundColor: const Color(0xffb8d8dc),
                        foregroundColor: const Color(0xff124c5d),
                      ),
                      _button(
                        '÷',
                        onPressed: () => _chooseOperator('/'),
                        backgroundColor: const Color(0xfff2a65a),
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _button('7', onPressed: () => _inputDigit('7')),
                      _button('8', onPressed: () => _inputDigit('8')),
                      _button('9', onPressed: () => _inputDigit('9')),
                      _button(
                        '×',
                        onPressed: () => _chooseOperator('×'),
                        backgroundColor: const Color(0xfff2a65a),
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _button('4', onPressed: () => _inputDigit('4')),
                      _button('5', onPressed: () => _inputDigit('5')),
                      _button('6', onPressed: () => _inputDigit('6')),
                      _button(
                        '-',
                        onPressed: () => _chooseOperator('-'),
                        backgroundColor: const Color(0xfff2a65a),
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _button('1', onPressed: () => _inputDigit('1')),
                      _button('2', onPressed: () => _inputDigit('2')),
                      _button('3', onPressed: () => _inputDigit('3')),
                      _button(
                        '+',
                        onPressed: () => _chooseOperator('+'),
                        backgroundColor: const Color(0xfff2a65a),
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _button('0', onPressed: () => _inputDigit('0'), flex: 2),
                      _button('.', onPressed: _inputDecimal),
                      _button(
                        '=',
                        onPressed: _calculateResult,
                        backgroundColor: const Color(0xff176b87),
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
