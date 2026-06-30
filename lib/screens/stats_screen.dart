import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_panel.dart';
import '../utils/statistics_calculator.dart';
import '../utils/combinatorics.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _rController = TextEditingController();

  String _statsResult = '';
  bool _statsError = false;

  String _comboResult = '';
  bool _comboError = false;

  List<double> _parseData() {
    final parts = _dataController.text
        .split(RegExp(r'[,\s]+'))
        .where((s) => s.trim().isNotEmpty);
    final values = parts.map((s) => double.parse(s.trim())).toList();
    if (values.isEmpty) throw Exception('Enter at least one number');
    return values;
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(4);
  }

  void _computeStat(String stat) {
    try {
      final data = _parseData();
      String label;
      String value;
      switch (stat) {
        case 'mean':
          label = 'Mean';
          value = _fmt(StatisticsCalculator.mean(data));
          break;
        case 'median':
          label = 'Median';
          value = _fmt(StatisticsCalculator.median(data));
          break;
        case 'mode':
          label = 'Mode';
          value = StatisticsCalculator.mode(data).map(_fmt).join(', ');
          break;
        case 'variance':
          label = 'Sample Variance';
          value = _fmt(StatisticsCalculator.variance(data));
          break;
        case 'stddev':
          label = 'Sample Std. Dev.';
          value = _fmt(StatisticsCalculator.standardDeviation(data));
          break;
        case 'sum':
          label = 'Sum';
          value = _fmt(StatisticsCalculator.sum(data));
          break;
        case 'range':
          label = 'Range';
          value = _fmt(StatisticsCalculator.range(data));
          break;
        default:
          label = '';
          value = '';
      }
      setState(() {
        _statsError = false;
        _statsResult = '$label: $value';
      });
    } catch (e) {
      setState(() {
        _statsError = true;
        _statsResult = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _computeCombo(String type) {
    try {
      final n = int.parse(_nController.text.trim());
      final r = int.parse(_rController.text.trim());
      double value;
      String label;
      if (type == 'nPr') {
        value = Combinatorics.permutation(n, r);
        label = 'P($n, $r)';
      } else if (type == 'nCr') {
        value = Combinatorics.combination(n, r);
        label = 'C($n, $r)';
      } else {
        value = Combinatorics.factorial(n);
        label = '$n!';
      }
      setState(() {
        _comboError = false;
        _comboResult = '$label = ${_fmt(value)}';
      });
    } catch (e) {
      setState(() {
        _comboError = true;
        _comboResult = e.toString().replaceFirst('Exception: ', '');
      });
    }
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
              'Dataset (comma or space separated)',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 8),
            GlassPanel(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: _dataController,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'e.g. 4, 8, 6, 5, 3, 9, 7',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _statButton('Mean', 'mean'),
                _statButton('Median', 'median'),
                _statButton('Mode', 'mode'),
                _statButton('Variance', 'variance'),
                _statButton('Std Dev', 'stddev'),
                _statButton('Sum', 'sum'),
                _statButton('Range', 'range'),
              ],
            ),
            const SizedBox(height: 14),
            GlassPanel(
              borderRadius: 16,
              tint: _statsError ? AppColors.accentRed : AppColors.accentGreen,
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  _statsResult.isEmpty ? 'Statistic result will appear here' : _statsResult,
                  style: TextStyle(
                    color: _statsError ? AppColors.accentRed : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Permutations & Combinations',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _numField(_nController, 'n')),
                const SizedBox(width: 10),
                Expanded(child: _numField(_rController, 'r')),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _comboButton('nPr', 'nPr'),
                _comboButton('nCr', 'nCr'),
                _comboButton('n!', 'factorial'),
              ],
            ),
            const SizedBox(height: 14),
            GlassPanel(
              borderRadius: 16,
              tint: _comboError ? AppColors.accentRed : AppColors.accentBlue,
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  _comboResult.isEmpty ? 'Combinatorics result will appear here' : _comboResult,
                  style: TextStyle(
                    color: _comboError ? AppColors.accentRed : Colors.white,
                    fontSize: 16,
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

  Widget _statButton(String label, String key) {
    return SizedBox(
      width: 100,
      height: 44,
      child: GlassButton(
        label: label,
        type: GlassButtonType.function,
        fontSize: 13,
        onTap: () => _computeStat(key),
      ),
    );
  }

  Widget _comboButton(String label, String key) {
    return SizedBox(
      width: 100,
      height: 44,
      child: GlassButton(
        label: label,
        type: GlassButtonType.operatorBtn,
        fontSize: 14,
        onTap: () => _computeCombo(key),
      ),
    );
  }

  Widget _numField(TextEditingController controller, String hint) {
    return GlassPanel(
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
