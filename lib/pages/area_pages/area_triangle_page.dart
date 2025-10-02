import 'package:flutter/material.dart';
import '../../services/area_calculation_service.dart';
import '../../widgets/area_result_dialog.dart';

class AreaTrianglePage extends StatefulWidget {
  const AreaTrianglePage({super.key});

  @override
  State<AreaTrianglePage> createState() => _AreaTrianglePageState();
}

class _AreaTrianglePageState extends State<AreaTrianglePage> {
  final _formKey = GlobalKey<FormState>();
  final _baseController = TextEditingController();
  final _heightController = TextEditingController();

  void _showResult(double result) {
    showDialog(
      context: context,
      builder: (ctx) => AreaResultDialog(
        icon: Icons.change_history,
        shapeName: 'Segitiga',
        formula: '½ × alas × tinggi',
        result: result,
        unit: 'cm²',
        color: Colors.orange,
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      // Tutup keyboard terlebih dahulu
      FocusScope.of(context).unfocus();
      
      // Tambahkan delay kecil untuk memastikan keyboard sudah tertutup sepenuhnya
      Future.delayed(const Duration(milliseconds: 200), () {
        final base = double.parse(_baseController.text);
        final height = double.parse(_heightController.text);
        final result = AreaCalculationService.calculateTriangle(base, height);
        _showResult(result);
      });
    }
  }

  @override
  void dispose() {
    _baseController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luas Segitiga'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: () {
              _baseController.clear();
              _heightController.clear();
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
              color: Colors.orange,
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
                      child: const Icon(Icons.change_history, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Kalkulator Segitiga',
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
                  const Text('Masukkan alas (cm):'),
                  TextFormField(
                    controller: _baseController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Alas'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Alas wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Alas harus > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Masukkan tinggi (cm):'),
                  TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Tinggi'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Tinggi wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Tinggi harus > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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
