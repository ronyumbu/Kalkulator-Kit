import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/area_calculation_service.dart';
import '../../widgets/area_result_dialog.dart';

class AreaCirclePage extends StatefulWidget {
  const AreaCirclePage({super.key});

  @override
  State<AreaCirclePage> createState() => _AreaCirclePageState();
}

class _AreaCirclePageState extends State<AreaCirclePage> {
  final _formKey = GlobalKey<FormState>();
  final _radiusController = TextEditingController();
  late FocusNode _keyboardFocusNode;

  void _showResult(double result) {
    showDialog(
      context: context,
      builder: (ctx) => AreaResultDialog(
        icon: Icons.circle,
        shapeName: 'Lingkaran',
        formula: 'π × r²',
        result: result,
        unit: 'cm²',
        color: Colors.pink,
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      // Tutup keyboard terlebih dahulu
      FocusScope.of(context).unfocus();
      
      // Tambahkan delay kecil untuk memastikan keyboard sudah tertutup sepenuhnya
      Future.delayed(const Duration(milliseconds: 200), () {
        final radius = double.parse(_radiusController.text);
        final result = AreaCalculationService.calculateCircle(radius);
        _showResult(result);
      });
    }
  }

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _keyboardFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _keyboardFocusNode.requestFocus();
    });
  }

  void _handleRawKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      final ch = event.character ?? key.keyLabel;
      if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
        _calculate();
      } else if ((ch.toLowerCase()) == 'r') {
        _radiusController.clear();
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luas Lingkaran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: () {
              _radiusController.clear();
              setState(() {});
            },
          ),
        ],
      ),
      body: RawKeyboardListener(
        focusNode: _keyboardFocusNode,
        onKey: _handleRawKey,
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.pink,
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
                      child: const Icon(Icons.circle, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Kalkulator Lingkaran',
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
                  const Text('Masukkan jari-jari (cm):'),
                  TextFormField(
                    controller: _radiusController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Jari-jari'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Jari-jari wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Jari-jari harus > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
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
        ), // Column
      ), // SingleChildScrollView
    ), // RawKeyboardListener
  );
  }
}
