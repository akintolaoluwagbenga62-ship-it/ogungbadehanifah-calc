/// Matrix arithmetic for square and rectangular matrices, sized 2x2 to 4x4.
class MatrixCalculator {
  static void _checkSameDimensions(List<List<double>> a, List<List<double>> b) {
    if (a.length != b.length || a[0].length != b[0].length) {
      throw Exception('Matrices must have the same dimensions');
    }
  }

  static List<List<double>> add(List<List<double>> a, List<List<double>> b) {
    _checkSameDimensions(a, b);
    return List.generate(
      a.length,
      (i) => List.generate(a[0].length, (j) => a[i][j] + b[i][j]),
    );
  }

  static List<List<double>> subtract(List<List<double>> a, List<List<double>> b) {
    _checkSameDimensions(a, b);
    return List.generate(
      a.length,
      (i) => List.generate(a[0].length, (j) => a[i][j] - b[i][j]),
    );
  }

  static List<List<double>> multiply(List<List<double>> a, List<List<double>> b) {
    if (a[0].length != b.length) {
      throw Exception('Number of columns in A must match rows in B');
    }
    final result =
        List.generate(a.length, (_) => List<double>.filled(b[0].length, 0));
    for (int i = 0; i < a.length; i++) {
      for (int j = 0; j < b[0].length; j++) {
        double sum = 0;
        for (int k = 0; k < b.length; k++) {
          sum += a[i][k] * b[k][j];
        }
        result[i][j] = sum;
      }
    }
    return result;
  }

  static List<List<double>> transpose(List<List<double>> a) {
    return List.generate(
      a[0].length,
      (i) => List.generate(a.length, (j) => a[j][i]),
    );
  }

  static List<List<double>> scalarMultiply(List<List<double>> a, double scalar) {
    return List.generate(
      a.length,
      (i) => List.generate(a[0].length, (j) => a[i][j] * scalar),
    );
  }

  static List<List<double>> _minor(List<List<double>> matrix, int row, int col) {
    final result = <List<double>>[];
    for (int i = 0; i < matrix.length; i++) {
      if (i == row) continue;
      final newRow = <double>[];
      for (int j = 0; j < matrix[i].length; j++) {
        if (j == col) continue;
        newRow.add(matrix[i][j]);
      }
      result.add(newRow);
    }
    return result;
  }

  static double determinant(List<List<double>> matrix) {
    final n = matrix.length;
    if (n != matrix[0].length) {
      throw Exception('Determinant requires a square matrix');
    }
    if (n == 1) return matrix[0][0];
    if (n == 2) {
      return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
    }
    double det = 0;
    for (int col = 0; col < n; col++) {
      final sign = col % 2 == 0 ? 1 : -1;
      det += sign * matrix[0][col] * determinant(_minor(matrix, 0, col));
    }
    return det;
  }

  static List<List<double>> inverse(List<List<double>> matrix) {
    final n = matrix.length;
    if (n != matrix[0].length) {
      throw Exception('Inverse requires a square matrix');
    }
    final det = determinant(matrix);
    if (det.abs() < 1e-12) {
      throw Exception('Matrix is singular; inverse does not exist');
    }
    if (n == 1) return [[1 / matrix[0][0]]];

    final cofactors = List.generate(n, (_) => List<double>.filled(n, 0));
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        final sign = (i + j) % 2 == 0 ? 1 : -1;
        cofactors[i][j] = sign * determinant(_minor(matrix, i, j));
      }
    }
    final adjugate = transpose(cofactors);
    return List.generate(
      n,
      (i) => List.generate(n, (j) => adjugate[i][j] / det),
    );
  }
}
