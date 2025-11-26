/// Service untuk menghitung cicilan pinjaman
/// Mendukung bunga flat dan bunga menurun (efektif)
class LoanCalculationService {
  /// Menghitung cicilan dengan bunga flat (tetap)
  /// Bunga dihitung dari pokok pinjaman awal sepanjang tenor
  static LoanResult calculateFlatInterest({
    required double principal,
    required double annualInterestRate,
    required int tenorMonths,
  }) {
    // Bunga per bulan (dari rate tahunan)
    final monthlyInterestRate = annualInterestRate / 100 / 12;

    // Total bunga = Pokok × Rate bulanan × Tenor
    final totalInterest = principal * monthlyInterestRate * tenorMonths;

    // Total pembayaran
    final totalPayment = principal + totalInterest;

    // Cicilan per bulan (tetap)
    final monthlyPayment = totalPayment / tenorMonths;

    // Buat jadwal cicilan
    List<InstallmentDetail> schedule = [];
    double remainingPrincipal = principal;
    final principalPerMonth = principal / tenorMonths;
    final interestPerMonth = totalInterest / tenorMonths;

    for (int month = 1; month <= tenorMonths; month++) {
      remainingPrincipal -= principalPerMonth;
      if (remainingPrincipal < 0) remainingPrincipal = 0;

      schedule.add(
        InstallmentDetail(
          month: month,
          principalPayment: principalPerMonth,
          interestPayment: interestPerMonth,
          totalPayment: monthlyPayment,
          remainingPrincipal: remainingPrincipal,
        ),
      );
    }

    return LoanResult(
      monthlyPayment: monthlyPayment,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      schedule: schedule,
      interestType: 'Bunga Flat (Tetap)',
    );
  }

  /// Menghitung cicilan dengan bunga menurun (efektif/anuitas)
  /// Bunga dihitung dari sisa pokok pinjaman
  static LoanResult calculateDecliningInterest({
    required double principal,
    required double annualInterestRate,
    required int tenorMonths,
  }) {
    // Bunga per bulan (dari rate tahunan)
    final monthlyInterestRate = annualInterestRate / 100 / 12;

    // Rumus anuitas: M = P × [r(1+r)^n] / [(1+r)^n - 1]
    // dimana M = cicilan bulanan, P = pokok, r = bunga bulanan, n = tenor
    double monthlyPayment;

    if (monthlyInterestRate == 0) {
      monthlyPayment = principal / tenorMonths;
    } else {
      final factor = (1 + monthlyInterestRate);
      final factorPowN = _pow(factor, tenorMonths);
      monthlyPayment =
          principal * (monthlyInterestRate * factorPowN) / (factorPowN - 1);
    }

    // Buat jadwal cicilan
    List<InstallmentDetail> schedule = [];
    double remainingPrincipal = principal;
    double totalInterest = 0;

    for (int month = 1; month <= tenorMonths; month++) {
      final interestPayment = remainingPrincipal * monthlyInterestRate;
      final principalPayment = monthlyPayment - interestPayment;
      remainingPrincipal -= principalPayment;
      if (remainingPrincipal < 0) remainingPrincipal = 0;

      totalInterest += interestPayment;

      schedule.add(
        InstallmentDetail(
          month: month,
          principalPayment: principalPayment,
          interestPayment: interestPayment,
          totalPayment: monthlyPayment,
          remainingPrincipal: remainingPrincipal,
        ),
      );
    }

    final totalPayment = principal + totalInterest;

    return LoanResult(
      monthlyPayment: monthlyPayment,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      schedule: schedule,
      interestType: 'Bunga Menurun (Efektif)',
    );
  }

  /// Helper function untuk pangkat
  static double _pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  /// Validasi input
  static Map<String, String> validateInputs({
    required String principalText,
    String? downPaymentText,
    required String interestRateText,
    required String tenorText,
    required String? interestType,
  }) {
    Map<String, String> errors = {};

    double principal = 0;
    double downPayment = 0;

    if (principalText.isEmpty) {
      errors['principal'] = 'Jumlah pinjaman harus diisi';
    } else {
      String cleanPrincipal = principalText
          .replaceAll('.', '')
          .replaceAll(',', '');
      final parsedPrincipal = double.tryParse(cleanPrincipal);
      if (parsedPrincipal == null || parsedPrincipal <= 0) {
        errors['principal'] = 'Jumlah pinjaman harus berupa angka positif';
      } else {
        principal = parsedPrincipal;
      }
    }

    // DP opsional, jika diisi harus valid
    if (downPaymentText != null && downPaymentText.isNotEmpty) {
      String cleanDP = downPaymentText.replaceAll('.', '').replaceAll(',', '');
      final parsedDP = double.tryParse(cleanDP);
      if (parsedDP == null || parsedDP < 0) {
        errors['downPayment'] = 'DP harus berupa angka positif';
      } else {
        downPayment = parsedDP;
        if (principal > 0 && downPayment >= principal) {
          errors['downPayment'] = 'DP harus lebih kecil dari jumlah pinjaman';
        }
      }
    }

    if (interestRateText.isEmpty) {
      errors['interestRate'] = 'Suku bunga harus diisi';
    } else {
      String cleanRate = interestRateText.replaceAll(',', '.');
      final rate = double.tryParse(cleanRate);
      if (rate == null || rate < 0) {
        errors['interestRate'] = 'Suku bunga harus berupa angka positif';
      }
    }

    if (tenorText.isEmpty) {
      errors['tenor'] = 'Tenor harus diisi';
    } else {
      final tenor = int.tryParse(tenorText);
      if (tenor == null || tenor <= 0) {
        errors['tenor'] = 'Tenor harus berupa angka positif';
      } else if (tenor > 360) {
        errors['tenor'] = 'Tenor maksimal 360 bulan (30 tahun)';
      }
    }

    if (interestType == null || interestType.isEmpty) {
      errors['interestType'] = 'Pilih jenis bunga';
    }

    return errors;
  }
}

/// Model untuk hasil perhitungan cicilan
class LoanResult {
  final double monthlyPayment;
  final double totalPayment;
  final double totalInterest;
  final List<InstallmentDetail> schedule;
  final String interestType;

  LoanResult({
    required this.monthlyPayment,
    required this.totalPayment,
    required this.totalInterest,
    required this.schedule,
    required this.interestType,
  });
}

/// Model untuk detail cicilan per bulan
class InstallmentDetail {
  final int month;
  final double principalPayment;
  final double interestPayment;
  final double totalPayment;
  final double remainingPrincipal;

  InstallmentDetail({
    required this.month,
    required this.principalPayment,
    required this.interestPayment,
    required this.totalPayment,
    required this.remainingPrincipal,
  });
}
