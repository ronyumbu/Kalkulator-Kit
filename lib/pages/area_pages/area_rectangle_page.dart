import 'package:flutter/material.dart';
import '../../services/area_calculation_service.dart';
import '../../widgets/area_result_dialog.dart';

class AreaRectanglePage extends StatefulWidget {
  const AreaRectanglePage({super.key});

  @override
  State<AreaRectanglePage> createState() => _AreaRectanglePageState();
}

class _AreaRectanglePageState extends State<AreaRectanglePage> {
  final _formKey = GlobalKey<FormState>();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();

  void _showResult(double result) {
    showDialog(
      context: context,
      builder: (ctx) => AreaResultDialog(
        icon: Icons.rectangle,
        shapeName: 'Persegi Panjang',
        formula: 'panjang × lebar',
        result: result,
        unit: 'cm²',
        color: Colors.green,
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      // Tutup keyboard terlebih dahulu
      FocusScope.of(context).unfocus();
      
      // Tambahkan delay kecil untuk memastikan keyboard sudah tertutup sepenuhnya
      Future.delayed(const Duration(milliseconds: 200), () {
        final length = double.parse(_lengthController.text);
        final width = double.parse(_widthController.text);
        final result = AreaCalculationService.calculateRectangle(length, width);
        _showResult(result);
      });
    }
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luas Persegi Panjang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: () {
              _lengthController.clear();
              _widthController.clear();
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
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.rectangle, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Kalkulator Persegi Panjang',
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
                  const Text('Masukkan panjang (cm):'),
                  TextFormField(
                    controller: _lengthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Panjang'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Panjang wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Panjang harus > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Masukkan lebar (cm):'),
                  TextFormField(
                    controller: _widthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Lebar'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Lebar wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Lebar harus > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
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
