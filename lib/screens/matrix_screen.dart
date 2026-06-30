import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_panel.dart';
import '../utils/matrix_calculator.dart';

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key});

  @override
  State<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends State<MatrixScreen> {
  int _sizeA = 2;
  int _sizeB = 2;
  bool _useB = true;

  late List<List<TextEditingController>> _controllersA = _buildControllers(2);
  late List<List<TextEditingController>> _controllersB = _buildControllers(2);

  String _resultText = '';
  bool _hasError = false;

  List<List<TextEditingController>> _buildControllers(int size) {
    return List.generate(
      size,
      (_) => List.generate(size, (_) => TextEditingController(text: '0')),
    );
  }

  List<List<double>> _readMatrix(List<List<TextEditingController>> controllers) {
    return controllers
        .map((row) => row.map((c) => double.tryParse(c.text) ?? 0).toList())
        .toList();
  }

  void _setSizeA(int size) {
    setState(() {
      _sizeA = size;
      _controllersA = _buildControllers(size);
    });
  }

  void _setSizeB(int size) {
    setState(() {
      _sizeB = size;
      _controllersB = _buildControllers(size);
    });
  }

  void _runOp(String op) {
    try {
      final a = _readMatrix(_controllersA);
      List<List<double>>? result2D;
      double? resultScalar;

      switch (op) {
        case 'add':
          result2D = MatrixCalculator.add(a, _readMatrix(_controllersB));
          break;
        case 'subtract':
          result2D = MatrixCalculator.subtract(a, _readMatrix(_controllersB));
          break;
        case 'multiply':
          result2D = MatrixCalculator.multiply(a, _readMatrix(_controllersB));
          break;
        case 'transpose':
          result2D = MatrixCalculator.transpose(a);
          break;
        case 'determinant':
          resultScalar = MatrixCalculator.determinant(a);
          break;
        case 'inverse':
          result2D = MatrixCalculator.inverse(a);
          break;
      }

      setState(() {
        _hasError = false;
        if (resultScalar != null) {
          _resultText = _formatNumber(resultScalar);
        } else if (result2D != null) {
          _resultText = result2D
              .map((row) => row.map(_formatNumber).join('   '))
              .join('\n');
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _resultText = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(3);
  }

  Widget _buildMatrixGrid(List<List<TextEditingController>> controllers, int size) {
    return GlassPanel(
      borderRadius: 20,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: List.generate(
          size,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: List.generate(size, (j) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: controllers[i][j],
                      textAlign: TextAlign.center,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true, signed: true),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.06),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizeSelector(int currentSize, ValueChanged<int> onChanged) {
    return Row(
      children: [2, 3, 4].map((size) {
        final selected = currentSize == size;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(size),
            child: GlassPanel(
              borderRadius: 12,
              tint: selected ? AppColors.accentBlue : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Text(
                '${size}x$size',
                style: TextStyle(
                  color: selected ? AppColors.accentBlue : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Matrix A',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _sizeSelector(_sizeA, _setSizeA),
            const SizedBox(height: 10),
            _buildMatrixGrid(_controllersA, _sizeA),
            const SizedBox(height: 20),
            const Text(
              'Matrix B',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _sizeSelector(_sizeB, _setSizeB),
            const SizedBox(height: 10),
            _buildMatrixGrid(_controllersB, _sizeB),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _opButton('A + B', () => _runOp('add')),
                _opButton('A − B', () => _runOp('subtract')),
                _opButton('A × B', () => _runOp('multiply')),
                _opButton('Transpose A', () => _runOp('transpose')),
                _opButton('det(A)', () => _runOp('determinant')),
                _opButton('Inverse A', () => _runOp('inverse')),
              ],
            ),
            const SizedBox(height: 20),
            GlassPanel(
              borderRadius: 18,
              tint: _hasError ? AppColors.accentRed : AppColors.accentGreen,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  _resultText.isEmpty ? 'Result will appear here' : _resultText,
                  style: TextStyle(
                    color: _hasError ? AppColors.accentRed : Colors.white,
                    fontSize: 16,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _opButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: 110,
      height: 48,
      child: GlassButton(
        label: label,
        type: GlassButtonType.function,
        fontSize: 13,
        onTap: onTap,
      ),
    );
  }
}
