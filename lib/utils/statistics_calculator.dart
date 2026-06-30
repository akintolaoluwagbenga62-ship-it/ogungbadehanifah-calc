import 'dart:math' as math;

/// Descriptive statistics over a list of numbers.
class StatisticsCalculator {
  static double mean(List<double> data) {
    if (data.isEmpty) throw Exception('Dataset is empty');
    return data.reduce((a, b) => a + b) / data.length;
  }

  static double median(List<double> data) {
    if (data.isEmpty) throw Exception('Dataset is empty');
    final sorted = List<double>.from(data)..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length % 2 == 0) {
      return (sorted[mid - 1] + sorted[mid]) / 2;
    }
    return sorted[mid];
  }

  static List<double> mode(List<double> data) {
    if (data.isEmpty) throw Exception('Dataset is empty');
    final counts = <double, int>{};
    for (final value in data) {
      counts[value] = (counts[value] ?? 0) + 1;
    }
    final maxCount = counts.values.reduce(math.max);
    return counts.entries
        .where((e) => e.value == maxCount)
        .map((e) => e.key)
        .toList()
      ..sort();
  }

  static double variance(List<double> data, {bool sample = true}) {
    if (data.length < (sample ? 2 : 1)) {
      throw Exception('Not enough data points');
    }
    final m = mean(data);
    final sumSq = data.fold<double>(0, (sum, x) => sum + math.pow(x - m, 2));
    return sumSq / (sample ? data.length - 1 : data.length);
  }

  static double standardDeviation(List<double> data, {bool sample = true}) {
    return math.sqrt(variance(data, sample: sample));
  }

  static double sum(List<double> data) {
    if (data.isEmpty) throw Exception('Dataset is empty');
    return data.fold(0, (a, b) => a + b);
  }

  static double range(List<double> data) {
    if (data.isEmpty) throw Exception('Dataset is empty');
    return data.reduce(math.max) - data.reduce(math.min);
  }
}
