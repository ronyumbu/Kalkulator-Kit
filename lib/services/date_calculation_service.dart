class DateCalculationError implements Exception {
  final String message;
  DateCalculationError(this.message);
  @override
  String toString() => message;
}

class DateCalculationService {
  // Fungsi selisih tanggal
  static int calculateDateDifference(DateTime start, DateTime end) {
    if (end.isBefore(start)) {
      throw DateCalculationError(
        'Tanggal akhir tidak boleh sebelum tanggal awal',
      );
    }
    return end.difference(start).inDays;
  }

  // Fungsi tambah/kurang hari
  static DateTime addSubtractDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  // Fungsi get hari Indonesia
  static String getIndonesianDay(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[date.weekday - 1];
  }

  // Fungsi get bulan Indonesia
  static String getIndonesianMonth(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[date.month - 1];
  }

  // Format tanggal lengkap dalam bahasa Indonesia
  static String formatIndonesianDate(DateTime date) {
    return '${date.day} ${getIndonesianMonth(date)} ${date.year}';
  }

  // Format hasil perhitungan selisih tanggal
  static String formatDateDifferenceResult(
    DateTime start,
    DateTime end,
    int difference,
  ) {
    final startFormatted = formatIndonesianDate(start);
    final endFormatted = formatIndonesianDate(end);
    final startDay = getIndonesianDay(start);
    final endDay = getIndonesianDay(end);

    if (difference == 0) {
      return 'SAME_DAY|0|$startFormatted|$startDay|$endFormatted|$endDay';
    } else if (difference == 1) {
      return 'SINGLE_DAY|1|$startFormatted|$startDay|$endFormatted|$endDay';
    } else {
      return 'MULTIPLE_DAYS|$difference|$startFormatted|$startDay|$endFormatted|$endDay';
    }
  }

  // Format hasil penambahan/pengurangan hari
  static String formatAddSubtractResult(
    DateTime originalDate,
    int days,
    DateTime resultDate,
  ) {
    final originalFormatted = formatIndonesianDate(originalDate);
    final resultFormatted = formatIndonesianDate(resultDate);
    final originalDay = getIndonesianDay(originalDate);
    final resultDay = getIndonesianDay(resultDate);

    if (days > 0) {
      if (days == 1) {
        return 'ADD_SINGLE|$days|$originalFormatted|$originalDay|$resultFormatted|$resultDay';
      } else {
        return 'ADD_MULTIPLE|$days|$originalFormatted|$originalDay|$resultFormatted|$resultDay';
      }
    } else if (days < 0) {
      final absDays = days.abs();
      if (absDays == 1) {
        return 'SUBTRACT_SINGLE|$absDays|$originalFormatted|$originalDay|$resultFormatted|$resultDay';
      } else {
        return 'SUBTRACT_MULTIPLE|$absDays|$originalFormatted|$originalDay|$resultFormatted|$resultDay';
      }
    } else {
      return 'SAME_DATE|0|$originalFormatted|$originalDay|$resultFormatted|$resultDay';
    }
  }

  // Validasi range tanggal
  static bool isValidDateRange(DateTime date) {
    final minDate = DateTime(1900, 1, 1);
    final maxDate = DateTime(2100, 12, 31);
    return date.isAfter(minDate.subtract(const Duration(days: 1))) &&
        date.isBefore(maxDate.add(const Duration(days: 1)));
  }

  // Fungsi untuk mendapatkan tanggal hari ini
  static DateTime getToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // Fungsi untuk mendapatkan informasi hari lengkap
  static String getFullDayInfo(DateTime date) {
    final dayName = getIndonesianDay(date);
    final formattedDate = formatIndonesianDate(date);
    return '$dayName, $formattedDate';
  }
}
