class TimeCalculationError implements Exception {
  final String message;
  TimeCalculationError(this.message);
  @override
  String toString() => message;
}

class TimeCalculationService {
  // Parser internal: HH:MM:SS -> detik total. Menit/detik 0..59, jam >= 0.
  static int parseToSeconds(String input) {
    final trimmed = input.trim();
    // Allow hours to be any length (1+), minutes/seconds exactly two digits
    final parts = trimmed.split(':');
    if (parts.length != 3) {
  throw TimeCalculationError('Format waktu harus HH:MM:SS');
    }
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final s = int.tryParse(parts[2]);
    if (h == null || m == null || s == null) {
      throw TimeCalculationError('Format waktu tidak valid');
    }
    if (m < 0 || m > 59 || s < 0 || s > 59 || h < 0) {
      throw TimeCalculationError('Nilai menit/detik harus 00..59 dan jam >= 0');
    }
    return h * 3600 + m * 60 + s;
  }

  static String formatSeconds(int totalSeconds) {
    if (totalSeconds < 0) {
      throw TimeCalculationError('Hasil waktu tidak boleh negatif');
    }
    final h = totalSeconds ~/ 3600;
    final rem = totalSeconds % 3600;
    final m = rem ~/ 60;
    final s = rem % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:${two(m)}:${two(s)}';
  }

  static int add(String t1, String t2) {
    final a = parseToSeconds(t1);
    final b = parseToSeconds(t2);
    return a + b;
  }

  static int subtract(String t1, String t2) {
    final a = parseToSeconds(t1);
    final b = parseToSeconds(t2);
    final res = a - b;
    if (res < 0) {
      throw TimeCalculationError('Hasil negatif tidak diizinkan');
    }
    return res;
  }

  static int multiply(String t, num factor) {
    if (factor.isNaN) {
      throw TimeCalculationError('Faktor tidak valid');
    }
    final a = parseToSeconds(t);
    final res = (a * factor).round();
    if (res < 0) {
      throw TimeCalculationError('Hasil negatif tidak diizinkan');
    }
    return res;
  }

  static int divide(String t, num divisor) {
    if (divisor == 0) {
      throw TimeCalculationError('Pembagian dengan 0 tidak diizinkan');
    }
    final a = parseToSeconds(t);
    final res = (a / divisor).round();
    if (res < 0) {
      throw TimeCalculationError('Hasil negatif tidak diizinkan');
    }
    return res;
  }

  // Evaluasi ekspresi sederhana: <operand1> <op> <operand2>
  // Operan bisa berupa waktu (HH:MM:SS) atau angka.
  // Hanya waktu-waktu untuk +/-, dan waktu-angka (atau angka-waktu untuk *) untuk operasi * dan waktu-angka untuk /.
  static String evaluate(String expression) {
    final exp = expression.trim();
    if (exp.isEmpty) {
      throw TimeCalculationError('Ekspresi kosong');
    }

    // Normalize operators ascii
    final normalized = exp
        .replaceAll('×', '*')
        .replaceAll('x', '*')
        .replaceAll('X', '*')
        .replaceAll('÷', '/')
        .replaceAll('–', '-')
        .replaceAll('—', '-');

    // Split by operator while keeping operator
    final opMatch = RegExp(r"([+\-*/])").allMatches(normalized).toList();
    if (opMatch.isEmpty) {
      // Single token: if time, just validate and echo; if number, invalid
      if (_isTime(normalized)) {
        final secs = parseToSeconds(normalized);
        return formatSeconds(secs);
      }
      throw TimeCalculationError('Masukkan ekspresi lengkap, mis. 01:00:00 + 00:30:00');
    }
    if (opMatch.length > 1) {
      throw TimeCalculationError('Hanya satu operasi yang didukung per hitung');
    }
    final op = opMatch.first.group(0)!;
    final parts = normalized.split(RegExp(r"[+\-*/]"));
    if (parts.length != 2) {
      throw TimeCalculationError('Ekspresi tidak valid');
    }
    final left = parts[0].trim();
    final right = parts[1].trim();

    switch (op) {
      case '+':
        if (!_isTime(left) || !_isTime(right)) {
          throw TimeCalculationError('Penjumlahan harus waktu + waktu');
        }
        return formatSeconds(add(left, right));
      case '-':
        if (!_isTime(left) || !_isTime(right)) {
          throw TimeCalculationError('Pengurangan harus waktu - waktu');
        }
        return formatSeconds(subtract(left, right));
      case '*':
        // Support time * number or number * time
        if (_isTime(left) && _isNumber(right)) {
          return formatSeconds(multiply(left, num.parse(right)));
        }
        if (_isNumber(left) && _isTime(right)) {
          return formatSeconds(multiply(right, num.parse(left)));
        }
        throw TimeCalculationError('Perkalian harus waktu × angka');
      case '/':
        if (_isTime(left) && _isNumber(right)) {
          return formatSeconds(divide(left, num.parse(right)));
        }
        // number / time does not make sense in time unit
        throw TimeCalculationError('Pembagian harus waktu ÷ angka');
      default:
        throw TimeCalculationError('Operator tidak dikenal');
    }
  }

  static bool _isTime(String v) {
    final r = RegExp(r"^\d{1,}:\d{2}:\d{2}");
    if (!r.hasMatch(v)) return false;
    try {
      parseToSeconds(v);
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool _isNumber(String v) => RegExp(r"^\d+(\.\d+)?$").hasMatch(v.trim());
}
