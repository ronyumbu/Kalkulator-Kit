import 'package:flutter/material.dart';
import '../models/quota_data.dart';
import '../services/quota_calculation_service.dart';

class QuotaResultDisplay extends StatelessWidget {
  final QuotaData? quotaData;

  const QuotaResultDisplay({super.key, this.quotaData});

  @override
  Widget build(BuildContext context) {
    if (quotaData == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[600]!, Colors.green[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.sim_card,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Hasil Perhitungan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Main Result
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Daily Limit
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.trending_down,
                            color: Colors.green[700],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                QuotaCalculationService.getResultMessage(
                                  quotaData!,
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                QuotaCalculationService.getExplanationMessage(
                                  quotaData!,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Details
                    _buildDetailRow(
                      'Sisa Kuota',
                      '${quotaData!.remainingQuota.toStringAsFixed(1)} GB',
                      Icons.storage,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Hari Tersisa',
                      '${quotaData!.daysRemaining} hari',
                      Icons.calendar_today,
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Masa Tenggang',
                      QuotaCalculationService.formatDate(quotaData!.expiryDate),
                      Icons.event,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
