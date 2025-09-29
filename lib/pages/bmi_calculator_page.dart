import 'package:flutter/material.dart';
import '../services/bmi_calculation_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/main_drawer.dart';
import '../widgets/bmi_result_dialog.dart';

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _gender; // 'L' or 'P'
  Map<String, String> _errors = {};

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onCalculate() {
    setState(() {
      _errors = BMICalculationService.validateInputs(
        gender: _gender,
        heightText: _heightController.text,
        weightText: _weightController.text,
      );
    });

    if (!mounted) return;

    if (_errors.isEmpty) {
      final height = double.parse(_heightController.text.replaceAll(',', '.'));
      final weight = double.parse(_weightController.text.replaceAll(',', '.'));
      final bmi = BMICalculationService.calculateBMI(
        heightCm: height,
        weightKg: weight,
      );
      final category = BMICalculationService.getBMICategory(bmi);
      final color = BMICalculationService.getBMICategoryColor(bmi);

      if (!mounted) return;
      FocusScope.of(context).unfocus();

      BMIResultDialog.show(
        context,
        bmi: bmi,
        category: category,
        categoryColor: color,
        gender: _gender == 'L' ? 'Pria' : 'Wanita',
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon periksa input yang sudah diisi'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onReset() {
    setState(() {
      _gender = null;
      _heightController.clear();
      _weightController.clear();
      _errors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Kalkulator BMI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              try {
                Scaffold.of(context).openDrawer();
              } catch (_) {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Form',
            onPressed: _onReset,
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[600]!, Colors.teal[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.monitor_weight,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Kalkulator BMI',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kalkulator untuk menghitung Indeks Massa Tubuh (Body Mass Index).',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Form
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gender selection
                    const Text(
                      'Jenis Kelamin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _GenderTile(
                            label: 'Pria',
                            value: 'L',
                            groupValue: _gender,
                            icon: Icons.male,
                            selectedColor: Colors.teal,
                            assetPath: 'images/pria.png',
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _GenderTile(
                            label: 'Wanita',
                            value: 'P',
                            groupValue: _gender,
                            icon: Icons.female,
                            selectedColor: Colors.teal,
                            assetPath: 'images/wanita.png',
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ),
                      ],
                    ),
                    if (_errors['gender'] != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 8),
                        child: Text(
                          _errors['gender']!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),

                    NumericTextField(
                      label: 'Tinggi Badan',
                      hintText: 'Masukkan tinggi badan (cm)',
                      controller: _heightController,
                      errorText: _errors['height'],
                      prefixIcon: const Icon(Icons.height, color: Colors.teal),
                      suffixText: 'cm',
                      allowDecimals: true,
                    ),

                    NumericTextField(
                      label: 'Berat Badan',
                      hintText: 'Masukkan berat badan (kg)',
                      controller: _weightController,
                      errorText: _errors['weight'],
                      prefixIcon: const Icon(
                        Icons.monitor_weight,
                        color: Colors.teal,
                      ),
                      suffixText: 'kg',
                      allowDecimals: true,
                    ),

                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _onCalculate,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Hitung BMI'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.teal[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

class _GenderTile extends StatelessWidget {
  final String label;
  final String value;
  final String? groupValue;
  final IconData icon;
  final Color selectedColor;
  final ValueChanged<String?> onChanged;
  final String? assetPath; // optional animated/static image path

  const _GenderTile({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.selectedColor,
    required this.onChanged,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    final baseBorder = BorderSide(color: Colors.grey[300]!);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withValues(alpha: 0.12)
              : (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF2C2C2C)
                    : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? selectedColor
                : (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF404040)
                      : baseBorder.color),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // avatar + radio stacked horizontally but centered
            AnimatedScale(
              duration: const Duration(milliseconds: 160),
              scale: selected ? 1.08 : 1.0,
              child: _Avatar(
                assetPath: assetPath,
                fallbackIcon: icon,
                tint: selected ? selectedColor : Colors.grey[700]!,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected
                    ? selectedColor
                    : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Colors.grey[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? assetPath;
  final IconData fallbackIcon;
  final Color tint;
  const _Avatar({
    required this.assetPath,
    required this.fallbackIcon,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final size = 56.0;
    Widget inner;
    if (assetPath != null) {
      inner = ClipOval(
        child: Image.asset(
          assetPath!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(fallbackIcon, size: 32, color: tint),
        ),
      );
    } else {
      inner = Icon(fallbackIcon, size: 32, color: tint);
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF3C3C3C)
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: inner,
    );
  }
}
