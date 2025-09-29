class AgeCalculationResult {
  final int years;
  final int months;
  final int days;
  final int totalYears;
  final int totalMonths;
  final int totalWeeks;
  final int totalDays;
  final int totalHours;
  final int totalMinutes;
  final int totalSeconds;

  AgeCalculationResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalYears,
    required this.totalMonths,
    required this.totalWeeks,
    required this.totalDays,
    required this.totalHours,
    required this.totalMinutes,
    required this.totalSeconds,
  });

  String get formattedAge {
    if (years == 0 && months == 0) {
      return '$days hari';
    } else if (years == 0) {
      return '$months bulan, $days hari';
    } else {
      return '$years tahun, $months bulan, $days hari';
    }
  }
}

class AgeCalculationService {
  static AgeCalculationResult calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    
    if (birthDate.isAfter(now)) {
      throw ArgumentError('Tanggal lahir tidak boleh lebih dari hari ini');
    }

    // Calculate detailed age (years, months, days)
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    // Adjust for negative days
    if (days < 0) {
      months--;
      final lastMonth = DateTime(now.year, now.month, 0);
      days += lastMonth.day;
    }

    // Adjust for negative months
    if (months < 0) {
      years--;
      months += 12;
    }

    // Calculate totals
    final difference = now.difference(birthDate);
    
    final totalDays = difference.inDays;
    final totalHours = difference.inHours;
    final totalMinutes = difference.inMinutes;
    final totalSeconds = difference.inSeconds;
    
    // Calculate approximate totals
    final totalYears = (totalDays / 365.25).floor();
    final totalMonths = (totalDays / 30.44).floor(); // Average days per month
    final totalWeeks = (totalDays / 7).floor();

    return AgeCalculationResult(
      years: years,
      months: months,
      days: days,
      totalYears: totalYears,
      totalMonths: totalMonths,
      totalWeeks: totalWeeks,
      totalDays: totalDays,
      totalHours: totalHours,
      totalMinutes: totalMinutes,
      totalSeconds: totalSeconds,
    );
  }

  static String formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  static DateTime getToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime getMinBirthDate() {
    // Allow births up to 150 years ago
    final now = DateTime.now();
    return DateTime(now.year - 150, 1, 1);
  }

  static DateTime getMaxBirthDate() {
    // Maximum birth date is today
    return getToday();
  }
}