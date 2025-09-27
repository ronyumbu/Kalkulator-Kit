import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../utils/thousands_separator_input_formatter.dart';

class FuelCalculatorForm extends StatelessWidget {
  final TextEditingController distanceController;
  final TextEditingController efficiencyController;
  final TextEditingController priceController;
  final TextEditingController tollCostController;
  final TextEditingController parkingCostController;
  final Map<String, String> errors;
  final VoidCallback onCalculate;

  const FuelCalculatorForm({
    super.key,
    required this.distanceController,
    required this.efficiencyController,
    required this.priceController,
    required this.tollCostController,
    required this.parkingCostController,
    required this.errors,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Input Data Perjalanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Distance Input
            NumericTextField(
              label: 'Jarak Perjalanan',
              hintText: 'Masukkan jarak dalam kilometer',
              controller: distanceController,
              errorText: errors['distance'],
              prefixIcon: const Icon(Icons.route, color: Colors.blue),
              suffixText: 'km',
            ),

            // Fuel Efficiency Input
            NumericTextField(
              label: 'Efisiensi Bahan Bakar',
              hintText: 'Contoh: 12 untuk 12 km/liter',
              controller: efficiencyController,
              errorText: errors['efficiency'],
              prefixIcon: const Icon(
                Icons.local_gas_station,
                color: Colors.red,
              ),
              suffixText: 'km/L',
            ),

            // Fuel Price Input with auto formatting
            CustomTextField(
              label: 'Harga Bahan Bakar',
              hintText: 'Contoh: 12.200',
              controller: priceController,
              keyboardType: TextInputType.number,
              errorText: errors['price'],
              prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
              suffixText: 'per liter',
              inputFormatters: [ThousandsSeparatorInputFormatter()],
            ),

            // Additional Costs Section
            Divider(
              height: 32,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[600]
                  : Colors.grey[300],
            ),
            Text(
              'Biaya Tambahan (Opsional)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Toll Cost Input with auto formatting
            CustomTextField(
              label: 'Biaya Tol',
              hintText: 'Contoh: 25.000 (opsional)',
              controller: tollCostController,
              keyboardType: TextInputType.number,
              errorText: errors['tollCost'],
              prefixIcon: const Icon(Icons.toll, color: Colors.purple),
              suffixText: 'Rp',
              inputFormatters: [ThousandsSeparatorInputFormatter()],
            ),

            // Parking Cost Input with auto formatting
            CustomTextField(
              label: 'Biaya Parkir',
              hintText: 'Contoh: 5.000 (opsional)',
              controller: parkingCostController,
              keyboardType: TextInputType.number,
              errorText: errors['parkingCost'],
              prefixIcon: const Icon(Icons.local_parking, color: Colors.teal),
              suffixText: 'Rp',
              inputFormatters: [ThousandsSeparatorInputFormatter()],
            ),

            const SizedBox(height: 24),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onCalculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Hitung',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
