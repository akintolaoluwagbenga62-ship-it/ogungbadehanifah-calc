/// Permutation and combination utilities (nPr, nCr, n!).
class Combinatorics {
  static double factorial(int n) {
    if (n < 0) throw Exception('Factorial is undefined for negative numbers');
    if (n > 170) throw Exception('n is too large (max 170)');
    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  /// nPr = n! / (n - r)!
  static double permutation(int n, int r) {
    if (n < 0 || r < 0 || r > n) {
      throw Exception('Invalid values: require 0 <= r <= n');
    }
    return factorial(n) / factorial(n - r);
  }

  /// nCr = n! / (r! * (n - r)!)
  static double combination(int n, int r) {
    if (n < 0 || r < 0 || r > n) {
      throw Exception('Invalid values: require 0 <= r <= n');
    }
    return factorial(n) / (factorial(r) * factorial(n - r));
  }
}
