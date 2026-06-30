import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_panel.dart';
import 'calculator_screen.dart';
import 'matrix_screen.dart';
import 'stats_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _screens = const [
    CalculatorScreen(),
    MatrixScreen(),
    StatsScreen(),
  ];

  final _tabs = const [
    ('Calculator', Icons.calculate_outlined),
    ('Matrix', Icons.grid_4x4),
    ('Stats', Icons.bar_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient background glow for the liquid-glass feel.
          Positioned(
            top: -100,
            right: -80,
            child: _glow(AppColors.accentBlue),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: _glow(AppColors.accentPurple),
          ),
          IndexedStack(index: _index, children: _screens),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: GlassPanel(
            borderRadius: 24,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final (label, icon) = _tabs[i];
                final selected = i == _index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _index = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: selected
                            ? AppColors.accentBlue.withValues(alpha: 0.16)
                            : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            size: 22,
                            color: selected ? AppColors.accentBlue : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 11,
                              color: selected ? AppColors.accentBlue : AppColors.textSecondary,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
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

  Widget _glow(Color color) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.18),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 120, spreadRadius: 40),
        ],
      ),
    );
  }
}
