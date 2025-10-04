import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/area_calculation_service.dart';
import '../../widgets/area_result_dialog.dart';
import '../../widgets/custom_shape_icons.dart';

class AreaRhombusPage extends StatefulWidget {
  const AreaRhombusPage({super.key});

  @override
  State<AreaRhombusPage> createState() => _AreaRhombusPageState();
}

class _AreaRhombusPageState extends State<AreaRhombusPage> {
  final _formKey = GlobalKey<FormState>();
  final _diagonal1Controller = TextEditingController();
  final _diagonal2Controller = TextEditingController();
  late FocusNode _keyboardFocusNode;

  void _showResult(double result) {
    showDialog(
      context: context,
      builder: (ctx) => AreaResultDialog(
        customIcon: KiteIcon(color: Colors.white, size: 40),
        shapeName: 'Layang-Layang',
        formula: '½ × diagonal 1 × diagonal 2',
        result: result,
        unit: 'cm²',
        color: Colors.cyan,
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      // Tutup keyboard terlebih dahulu
      FocusScope.of(context).unfocus();
      
      // Tambahkan delay kecil untuk memastikan keyboard sudah tertutup sepenuhnya
      Future.delayed(const Duration(milliseconds: 200), () {
        final d1 = double.parse(_diagonal1Controller.text);
        final d2 = double.parse(_diagonal2Controller.text);
        final result = AreaCalculationService.calculateRhombus(d1, d2);
        _showResult(result);
      });
    }
  }

  @override
  void dispose() {
    _diagonal1Controller.dispose();
    _diagonal2Controller.dispose();
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
        _diagonal1Controller.clear();
        _diagonal2Controller.clear();
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luas Layang-Layang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: () {
              _diagonal1Controller.clear();
              _diagonal2Controller.clear();
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
              color: Colors.cyan,
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
                      child: KiteIcon(color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Kalkulator Layang-layang',
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
                  const Text('Masukkan diagonal 1 (cm):'),
                  TextFormField(
                    controller: _diagonal1Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Diagonal 1'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Diagonal 1 wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Diagonal 1 harus > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Masukkan diagonal 2 (cm):'),
                  TextFormField(
                    controller: _diagonal2Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Diagonal 2'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Diagonal 2 wajib diisi';
                      final numValue = double.tryParse(value);
                      if (numValue == null) return 'Masukkan angka yang valid';
                      if (numValue <= 0) return 'Diagonal 2 harus > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
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
