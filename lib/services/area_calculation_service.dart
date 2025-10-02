class AreaCalculationService {
  static double calculateSquare(double side) {
    if (side <= 0) throw ArgumentError('Sisi harus > 0');
    return side * side;
  }

  static double calculateRectangle(double length, double width) {
    if (length <= 0 || width <= 0) throw ArgumentError('Panjang & lebar harus > 0');
    return length * width;
  }

  static double calculateTriangle(double base, double height) {
    if (base <= 0 || height <= 0) throw ArgumentError('Alas & tinggi harus > 0');
    return 0.5 * base * height;
  }

  static double calculateParallelogram(double base, double height) {
    if (base <= 0 || height <= 0) throw ArgumentError('Alas & tinggi harus > 0');
    return base * height;
  }

  static double calculateTrapezoid(double base1, double base2, double height) {
    if (base1 <= 0 || base2 <= 0 || height <= 0) throw ArgumentError('Sisi sejajar & tinggi harus > 0');
    return 0.5 * (base1 + base2) * height;
  }

  static double calculateRhombus(double diagonal1, double diagonal2) {
    if (diagonal1 <= 0 || diagonal2 <= 0) throw ArgumentError('Diagonal harus > 0');
    return 0.5 * diagonal1 * diagonal2;
  }

  static double calculateCircle(double radius) {
    if (radius <= 0) throw ArgumentError('Jari-jari harus > 0');
    return 3.141592653589793 * radius * radius;
  }
}
