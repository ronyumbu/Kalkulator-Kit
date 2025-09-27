class QuotaData {
  final DateTime currentDate;
  final DateTime expiryDate;
  final double remainingQuota;
  final double? totalPurchasedQuota; // Opsional: total kuota yang dibeli

  QuotaData({
    required this.currentDate,
    required this.expiryDate,
    required this.remainingQuota,
    this.totalPurchasedQuota,
  });

  int get daysRemaining => expiryDate.difference(currentDate).inDays;

  double get dailyLimit {
    if (daysRemaining <= 0) return 0.0;
    return remainingQuota / daysRemaining;
  }

  bool get isValid =>
      expiryDate.isAfter(currentDate) &&
      remainingQuota > 0 &&
      daysRemaining <= 365;

  // Jika totalPurchasedQuota diisi, hitung kuota terpakai = total - sisa (minimal 0)
  double? get usedQuota {
    if (totalPurchasedQuota == null) return null;
    final used = totalPurchasedQuota! - remainingQuota;
    return used > 0 ? used : 0.0;
  }
}
