class QuotaData {
  final DateTime currentDate;
  final DateTime expiryDate;
  final double remainingQuota;

  QuotaData({
    required this.currentDate,
    required this.expiryDate,
    required this.remainingQuota,
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
}
