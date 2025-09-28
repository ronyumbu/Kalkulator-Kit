import 'package:flutter/material.dart';
import '../utils/currency_formatter.dart';

class CalculationResult extends StatelessWidget {
  final double totalCost;
  final double costPerKm;
  final double costPerPerson;
  final double fuelCost;
  final double tollCost;
  final double parkingCost;

  const CalculationResult({
    super.key,
    required this.totalCost,
    required this.costPerKm,
    required this.costPerPerson,
    required this.fuelCost,
    required this.tollCost,
    required this.parkingCost,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF2C2C2C)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green[800]?.withValues(alpha: 0.3)
                        : Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green[300]
                        : Colors.green[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Hasil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Main results in cards
            Row(
              children: [
                Expanded(
                  child: _buildResultCard(
                    context,
                    title: 'Total Biaya',
                    value: CurrencyFormatter.formatCurrencyNoDecimal(totalCost),
                    color: Colors.blue,
                    icon: Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildResultCard(
                    context,
                    title: 'Biaya per km',
                    value: CurrencyFormatter.formatCurrency(costPerKm),
                    color: Colors.orange,
                    icon: Icons.speed,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Breakdown section
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
            const SizedBox(height: 12),

            _buildBreakdownItem(
              context,
              'Biaya Bahan Bakar',
              CurrencyFormatter.formatCurrencyNoDecimal(fuelCost),
              Icons.local_gas_station,
              Colors.red[400]!,
            ),

            if (tollCost > 0)
              _buildBreakdownItem(
                context,
                'Biaya Tol',
                CurrencyFormatter.formatCurrencyNoDecimal(tollCost),
                Icons.toll,
                Colors.purple[400]!,
              ),

            if (parkingCost > 0)
              _buildBreakdownItem(
                context,
                'Biaya Parkir',
                CurrencyFormatter.formatCurrencyNoDecimal(parkingCost),
                Icons.local_parking,
                Colors.teal[400]!,
              ),

            const Divider(height: 24),

            // Cost per person
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.green[800]?.withValues(alpha: 0.2)
                    : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.green[600]!
                      : Colors.green[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person, 
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green[300]
                        : Colors.green[700], 
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Biaya per Orang',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.formatCurrencyNoDecimal(
                            costPerPerson,
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.green[300]
                                : Colors.green[700],
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
    );
  }

  Widget _buildResultCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14, 
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
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
