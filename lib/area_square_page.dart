import 'package:flutter/material.dart';
import '../services/area_calculation_service.dart';
import '../widgets/area_result_dialog.dart';

class AreaSquarePage extends StatefulWidget {
  const AreaSquarePage({super.key});

  @override
  State<AreaSquarePage> createState() => _AreaSquarePageState();
}

class _AreaSquarePageState extends State<AreaSquarePage> {
  final _formKey = GlobalKey<FormState>();
  final _sideController = TextEditingController();

  void _showResult(double result) {
    showDialog(
      context: context,
      builder: (ctx) => AreaResultDialog(
        icon: Icons.crop_square,
        shapeName: 'Persegi',
        formula: 'sisi × sisi',
        result: result,
        unit: 'cm²',
        color: Colors.blue,
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final side = double.parse(_sideController.text);
      final result = AreaCalculationService.calculateSquare(side);
      _showResult(result);
    }
  }

  @override
  void dispose() {
    _sideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luas Persegi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: () {
              _sideController.clear();
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.2 * 255).toInt()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.crop_square, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Kalkulator Persegi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Masukkan panjang sisi (cm):'),
                  TextFormField(
                    controller: _sideController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Sisi'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Sisi wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Sisi harus > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _calculate,
                      child: const Text('Hitung Luas'),
                    ),
                  ),
                  const SizedBox(height: 24), // Extra padding at bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
