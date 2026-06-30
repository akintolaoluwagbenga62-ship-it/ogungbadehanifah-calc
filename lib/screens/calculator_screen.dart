import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_panel.dart';
import '../utils/expression_evaluator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';
  bool _isDegrees = true;
  bool _hasError = false;

  void _append(String value) {
    setState(() {
      _expression += value;
      _hasError = false;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '';
      _hasError = false;
    });
  }

  void _backspace() {
    if (_expression.isEmpty) return;
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1);
      _hasError = false;
    });
  }

  void _evaluate() {
    if (_expression.isEmpty) return;
    try {
      final evaluator = ExpressionEvaluator(_expression, isDegrees: _isDegrees);
      final value = evaluator.evaluate();
      setState(() {
        _result = _formatNumber(value);
        _hasError = false;
      });
    } catch (_) {
      setState(() {
        _result = 'Error';
        _hasError = true;
      });
    }
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble() && value.abs() < 1e15) {
      return value.toStringAsFixed(0);
    }
    String text = value.toStringAsPrecision(10);
    if (text.contains('.') && !text.contains('e')) {
      text = text.replaceFirst(RegExp(r'0+$'), '');
      text = text.replaceFirst(RegExp(r'\.$'), '');
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildModeBar(),
            const SizedBox(height: 12),
            _buildDisplay(),
            const SizedBox(height: 12),
            _buildScientificRow(),
            const SizedBox(height: 10),
            Expanded(child: _buildMainGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildModeBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isDegrees = !_isDegrees),
          child: GlassPanel(
            borderRadius: 14,
            tint: AppColors.accentGreen,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              _isDegrees ? 'DEG' : 'RAD',
              style: const TextStyle(
                color: AppColors.accentGreen,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Scientific',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDisplay() {
    return GlassPanel(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              _expression.isEmpty ? '0' : _expression,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 20,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              _result.isEmpty ? '' : _result,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: _hasError ? AppColors.accentRed : Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScientificRow() {
    final functions = <(String, String)>[
      ('sin', 'sin('),
      ('cos', 'cos('),
      ('tan', 'tan('),
      ('sinh', 'sinh('),
      ('cosh', 'cosh('),
      ('tanh', 'tanh('),
      ('log', 'log('),
      ('ln', 'ln('),
      ('√', 'sqrt('),
      ('xʸ', '^'),
      ('π', 'pi'),
      ('e', 'e'),
      ('!', '!'),
      ('(', '('),
      (')', ')'),
    ];

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: functions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (label, insert) = functions[index];
          return SizedBox(
            width: 64,
            child: GlassButton(
              label: label,
              type: GlassButtonType.function,
              fontSize: 16,
              onTap: () => _append(insert),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainGrid() {
    final buttons = <(String, GlassButtonType, VoidCallback)>[
      ('C', GlassButtonType.clear, _clear),
      ('⌫', GlassButtonType.clear, _backspace),
      ('%', GlassButtonType.operatorBtn, () => _append('%')),
      ('÷', GlassButtonType.operatorBtn, () => _append('/')),
      ('7', GlassButtonType.number, () => _append('7')),
      ('8', GlassButtonType.number, () => _append('8')),
      ('9', GlassButtonType.number, () => _append('9')),
      ('×', GlassButtonType.operatorBtn, () => _append('*')),
      ('4', GlassButtonType.number, () => _append('4')),
      ('5', GlassButtonType.number, () => _append('5')),
      ('6', GlassButtonType.number, () => _append('6')),
      ('−', GlassButtonType.operatorBtn, () => _append('-')),
      ('1', GlassButtonType.number, () => _append('1')),
      ('2', GlassButtonType.number, () => _append('2')),
      ('3', GlassButtonType.number, () => _append('3')),
      ('+', GlassButtonType.operatorBtn, () => _append('+')),
      ('±', GlassButtonType.number, () => _append('-')),
      ('0', GlassButtonType.number, () => _append('0')),
      ('.', GlassButtonType.number, () => _append('.')),
      ('=', GlassButtonType.equals, _evaluate),
    ];

    return GridView.builder(
      itemCount: buttons.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final (label, type, onTap) = buttons[index];
        return GlassButton(label: label, type: type, onTap: onTap);
      },
    );
  }
}
