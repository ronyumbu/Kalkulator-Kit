import 'package:flutter/material.dart';
import '../utils/currency_formatter.dart';

class FuelResultDialog extends StatelessWidget {
  final double totalCost;
  final double costPerKm;
  final double fuelCost;
  final double tollCost;
  final double parkingCost;
  final double distance;
  final double efficiency;
  final double fuelPrice;

  const FuelResultDialog({
    super.key,
    required this.totalCost,
    required this.costPerKm,
    required this.fuelCost,
    required this.tollCost,
    required this.parkingCost,
    required this.distance,
    required this.efficiency,
    required this.fuelPrice,
  });

  static void show(
    BuildContext context, {
    required double totalCost,
    required double costPerKm,
    required double fuelCost,
    required double tollCost,
    required double parkingCost,
    required double distance,
    required double efficiency,
    required double fuelPrice,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => FuelResultDialog(
        totalCost: totalCost,
        costPerKm: costPerKm,
        fuelCost: fuelCost,
        tollCost: tollCost,
        parkingCost: parkingCost,
        distance: distance,
        efficiency: efficiency,
        fuelPrice: fuelPrice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fuelNeeded = distance / efficiency;
    
    return Dialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1C1C1C)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_gas_station,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Hasil Perhitungan BBM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Details Section
                    Text(
                      'Rincian Biaya',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDetailRow(
                      'Jarak Tempuh',
                      '${distance.toStringAsFixed(0)} km',
                      Icons.straighten,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Konsumsi BBM',
                      '$efficiency km/L',
                      Icons.speed,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'BBM Dibutuhkan',
                      '${fuelNeeded.toStringAsFixed(2)} liter',
                      Icons.local_gas_station,
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Biaya BBM',
                      CurrencyFormatter.formatCurrencyNoDecimal(fuelCost),
                      Icons.attach_money,
                      Colors.red,
                    ),
                    
                    if (tollCost > 0) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Biaya Tol',
                        CurrencyFormatter.formatCurrencyNoDecimal(tollCost),
                        Icons.toll,
                        Colors.purple,
                      ),
                    ],
                    
                    if (parkingCost > 0) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Biaya Parkir',
                        CurrencyFormatter.formatCurrencyNoDecimal(parkingCost),
                        Icons.local_parking,
                        Colors.indigo,
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Total Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF2C2C2C)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.blue[400]
                                      : Colors.blue[600],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calculate,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TOTAL BIAYA',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.black54,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      CurrencyFormatter.formatCurrencyNoDecimal(totalCost),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.blue[300]
                                            : Colors.blue[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF2C2C2C)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF404040)
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Biaya per km:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey[300]
                                        : Colors.black87,
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.formatCurrency(costPerKm),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
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
    return Builder(
      builder: (context) => Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[300]
                    : Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}