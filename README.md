# Scientific Calculator (Flutter)

A dark, "liquid glass" scientific calculator built for the SEN 104 & 214
mobile assignment. Demonstrates core Android/Flutter lifecycle concepts
through a multi-mode calculator app.

## Features

**Basic arithmetic**
- Addition, subtraction, multiplication, division, percentage, sign toggle

**Scientific**
- Trigonometric functions: sin, cos, tan
- Hyperbolic functions: sinh, cosh, tanh
- Degrees/Radians toggle
- log, ln, √, powers (xʸ), factorial (!), π, e, parentheses

**Matrix operations** (2×2 up to 4×4)
- Addition, subtraction, multiplication
- Transpose, determinant, inverse

**Statistics**
- Mean, median, mode, variance, standard deviation, sum, range

**Combinatorics**
- Permutations (nPr), combinations (nCr), factorial (n!)

## Design

- Pure black background with a frosted "liquid glass" aesthetic:
  `BackdropFilter` blur + translucent gradient + soft borders/glow on every button and panel
- Color-coded keys: white (numbers), blue (operators), purple (functions),
  orange (equals), red (clear), green (toggles)
- Space Grotesk typography via `google_fonts`

## Project structure

```
lib/
  main.dart                     # App entry point
  theme/app_theme.dart          # Dark theme + color palette
  widgets/
    glass_button.dart           # Liquid-glass calculator key
    glass_panel.dart            # Liquid-glass display/card panel
  utils/
    expression_evaluator.dart   # Recursive-descent expression parser
    matrix_calculator.dart      # Matrix add/sub/mul/transpose/det/inverse
    combinatorics.dart          # nPr, nCr, factorial
    statistics_calculator.dart  # mean/median/mode/variance/stddev/etc
  screens/
    home_shell.dart             # Bottom-nav shell (Calculator/Matrix/Stats)
    calculator_screen.dart      # Basic + scientific calculator
    matrix_screen.dart          # Matrix operations screen
    stats_screen.dart           # Statistics + combinatorics screen
```

## Running the project

This repo ships only the Dart source (`lib/`) and `pubspec.yaml` — the
platform scaffolding (`android/`, `ios/`, etc.) is generated locally so the
repo stays clean for GitHub.

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. From the project root, generate the platform folders:
   ```
   flutter create .
   ```
3. Get dependencies:
   ```
   flutter pub get
   ```
4. Run on a connected device/emulator:
   ```
   flutter run
   ```

## Lifecycle notes (for the assignment writeup)

- `main()` → `runApp()` mounts `ScientificCalculatorApp`, analogous to an
  Activity's `onCreate()`.
- `HomeShell` keeps all three screens alive via `IndexedStack`, so switching
  tabs behaves like `onPause()`/`onResume()` between Activities/Fragments
  rather than destroying and recreating state.
- Each screen's `State` object holds UI state (`TextEditingController`s,
  current expression, results) for the lifetime of the widget, mirroring how
  an Activity retains instance state between `onStart()` and `onStop()`.
