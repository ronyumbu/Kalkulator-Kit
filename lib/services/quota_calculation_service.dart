import '../models/quota_data.dart';

class QuotaCalculationService {
  static Map<String, String> validateInputs({
    required DateTime? expiryDate,
    required String quotaText,
    String? totalPurchasedText,
    DateTime? currentDate,
  }) {
    Map<String, String> errors = {};
    DateTime useCurrentDate = currentDate ?? DateTime.now();

    // Validate expiry date
    if (expiryDate == null) {
      errors['expiryDate'] = 'Pilih tanggal masa tenggang yang valid';
    } else {
      if (expiryDate.isBefore(useCurrentDate) ||
          expiryDate.isAtSameMomentAs(
            DateTime(useCurrentDate.year, useCurrentDate.month, useCurrentDate.day),
          )) {
        errors['expiryDate'] = 'Tanggal masa tenggang harus setelah hari ini';
      } else if (expiryDate.isAfter(
        useCurrentDate.add(const Duration(days: 365)),
      )) {
        errors['expiryDate'] =
            'Tanggal tidak boleh lebih dari 1 tahun ke depan';
      }
    }

    // Validate quota
    if (quotaText.isEmpty) {
      errors['quota'] = 'Masukkan sisa kuota';
    } else {
      double? quota = double.tryParse(quotaText.replaceAll(',', '.'));
      if (quota == null) {
        errors['quota'] = 'Masukkan angka yang valid';
      } else if (quota <= 0) {
        errors['quota'] = 'Sisa kuota harus lebih dari 0';
      }
    }

    // Validate optional total purchased quota
    if (totalPurchasedText != null && totalPurchasedText.trim().isNotEmpty) {
      final total = double.tryParse(totalPurchasedText.replaceAll(',', '.'));
      final remaining = double.tryParse(quotaText.replaceAll(',', '.'));
      if (total == null) {
        errors['totalPurchased'] = 'Masukkan total beli kuota yang valid';
      } else if (total <= 0) {
        errors['totalPurchased'] = 'Total beli kuota harus lebih dari 0';
      } else if (remaining != null && total < remaining) {
        errors['totalPurchased'] = 'Total beli kuota tidak boleh kurang dari sisa kuota';
      }
    }

    return errors;
  }

  static QuotaData? calculateQuota({
    required DateTime? expiryDate,
    required String quotaText,
    String? totalPurchasedText,
    DateTime? currentDate,
  }) {
    if (expiryDate == null || quotaText.isEmpty) return null;

    double? quota = double.tryParse(quotaText.replaceAll(',', '.'));
    if (quota == null || quota <= 0) return null;

    double? totalPurchased;
    if (totalPurchasedText != null && totalPurchasedText.trim().isNotEmpty) {
      final parsed = double.tryParse(totalPurchasedText.replaceAll(',', '.'));
      if (parsed != null && parsed > 0) {
        totalPurchased = parsed;
      }
    }

    DateTime useCurrentDate = currentDate ?? DateTime.now();

    return QuotaData(
      currentDate: useCurrentDate,
      expiryDate: expiryDate,
      remainingQuota: quota,
      totalPurchasedQuota: totalPurchased,
    );
  }

  static String formatDate(DateTime date) {
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String getResultMessage(QuotaData data) {
    if (data.daysRemaining == 1) {
      return 'Batas harian: ${data.dailyLimit.toStringAsFixed(2)} GB (untuk besok saja)';
    } else if (data.daysRemaining == 0) {
      return 'Kuota harus habis hari ini';
    } else {
      return 'Batas harian: ${data.dailyLimit.toStringAsFixed(2)} GB/hari';
    }
  }

  static String getExplanationMessage(QuotaData data) {
    return 'Agar kuota ${data.remainingQuota.toStringAsFixed(1)}GB cukup sampai ${formatDate(data.expiryDate)} (${data.daysRemaining} hari lagi)';
  }
}
