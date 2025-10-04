import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/area_calculation_service.dart';
import '../../widgets/area_result_dialog.dart';
import '../../widgets/custom_shape_icons.dart';

class AreaTrapezoidPage extends StatefulWidget {
  const AreaTrapezoidPage({super.key});

  @override
  State<AreaTrapezoidPage> createState() => _AreaTrapezoidPageState();
}

class _AreaTrapezoidPageState extends State<AreaTrapezoidPage> {
  final _formKey = GlobalKey<FormState>();
  final _base1Controller = TextEditingController();
  final _base2Controller = TextEditingController();
  final _heightController = TextEditingController();
  late FocusNode _keyboardFocusNode;

  void _showResult(double result) {
    showDialog(
      context: context,
      builder: (ctx) => AreaResultDialog(
        customIcon: TrapezoidIcon(color: Colors.white, size: 40),
        shapeName: 'Trapesium',
        formula: '½ × (a + b) × tinggi',
        result: result,
        unit: 'cm²',
        color: const Color(0xFFC1311C),
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      // Tutup keyboard terlebih dahulu
      FocusScope.of(context).unfocus();
      
      // Tambahkan delay kecil untuk memastikan keyboard sudah tertutup sepenuhnya
      Future.delayed(const Duration(milliseconds: 200), () {
        final base1 = double.parse(_base1Controller.text);
        final base2 = double.parse(_base2Controller.text);
        final height = double.parse(_heightController.text);
        final result = AreaCalculationService.calculateTrapezoid(base1, base2, height);
        _showResult(result);
      });
    }
  }

  @override
  void dispose() {
    _base1Controller.dispose();
    _base2Controller.dispose();
    _heightController.dispose();
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
        _base1Controller.clear();
        _base2Controller.clear();
        _heightController.clear();
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luas Trapesium'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: () {
              _base1Controller.clear();
              _base2Controller.clear();
              _heightController.clear();
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
              color: const Color(0xFFC1311C),
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
                      child: TrapezoidIcon(
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Kalkulator Trapesium',
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
                  const Text('Masukkan sisi sejajar 1 (cm):'),
                  TextFormField(
                    controller: _base1Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Sisi sejajar 1'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Sisi sejajar 1 wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Sisi sejajar 1 harus > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Masukkan sisi sejajar 2 (cm):'),
                  TextFormField(
                    controller: _base2Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Sisi sejajar 2'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Sisi sejajar 2 wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Sisi sejajar 2 harus > 0';
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
                        backgroundColor: const Color(0xFFC1311C),
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
