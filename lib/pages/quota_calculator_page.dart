import 'package:flutter/material.dart';
import '../services/quota_calculation_service.dart';
import '../widgets/quota_calculator_form.dart';
import '../widgets/quota_result_dialog.dart';
import '../widgets/main_drawer.dart';

class QuotaCalculatorPage extends StatefulWidget {
  const QuotaCalculatorPage({super.key});

  @override
  State<QuotaCalculatorPage> createState() => _QuotaCalculatorPageState();
}

class _QuotaCalculatorPageState extends State<QuotaCalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _quotaController = TextEditingController();
  final TextEditingController _totalPurchasedController = TextEditingController();
  DateTime? _selectedDate;
  DateTime _currentDate = DateTime.now();
  Map<String, String> _errors = {};

  @override
  void dispose() {
    _quotaController.dispose();
    _totalPurchasedController.dispose();
    super.dispose();
  }

  Future<void> _selectCurrentDate() async {
    final DateTime initialDate = _currentDate;

    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pilih Tanggal Mulai',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: CalendarDatePicker(
              initialDate: initialDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              onDateChanged: (DateTime date) {
                Navigator.of(context).pop(date);
              },
            ),
          ),
        );
      },
    );

    if (picked != null && picked != _currentDate) {
      setState(() {
        _currentDate = picked;
        // Reset tanggal masa tenggang jika tanggal mulai berubah
        if (_selectedDate != null && _selectedDate!.isBefore(_currentDate.add(const Duration(days: 1)))) {
          _selectedDate = null;
        }
      });
    }
  }

  Future<void> _selectExpiryDate() async {
    final DateTime initialDate =
        _selectedDate ?? _currentDate.add(const Duration(days: 30));

    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pilih Tanggal Masa Tenggang',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: CalendarDatePicker(
              initialDate: initialDate,
              firstDate: _currentDate.add(const Duration(days: 1)),
              lastDate: _currentDate.add(const Duration(days: 365)),
              onDateChanged: (DateTime date) {
                // Langsung tutup dialog dan return tanggal yang dipilih
                Navigator.of(context).pop(date);
              },
            ),
          ),
          contentPadding: const EdgeInsets.all(16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _onInputChanged();
    }
  }

  void _onInputChanged() {
    // Clear errors when user is typing (real-time feedback without showing errors)
    if (_errors.isNotEmpty) {
      setState(() {
        _errors.clear();
      });
    }
  }

  void _calculateQuota() {
    setState(() {
      // Validate inputs only when user clicks calculate button
      _errors = QuotaCalculationService.validateInputs(
        expiryDate: _selectedDate,
        quotaText: _quotaController.text,
        totalPurchasedText: _totalPurchasedController.text,
        currentDate: _currentDate,
      );
    });

    // Show result dialog if no errors
    if (_errors.isEmpty) {
      final result = QuotaCalculationService.calculateQuota(
        expiryDate: _selectedDate,
        quotaText: _quotaController.text,
        totalPurchasedText: _totalPurchasedController.text,
        currentDate: _currentDate,
      );

      if (result != null) {
        QuotaResultDialog.show(context, result);
      }
    } else {
      // Show snackbar if there are errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon periksa input yang sudah diisi'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _quotaController.clear();
      _totalPurchasedController.clear();
      _selectedDate = null;
      _currentDate = DateTime.now();
      _errors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Kalkulator Kuota',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              try {
                Scaffold.of(context).openDrawer();
              } catch (e) {
                // Fallback dengan GlobalKey
                _scaffoldKey.currentState?.openDrawer();
              }
            },
            tooltip: 'Menu',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetForm,
            tooltip: 'Reset Form',
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
            // Header section with app description (icon left, text right)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[600]!, Colors.green[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.sim_card,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Kalkulator Kuota',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kalo ini buat itung berapa batas maksimal abisin kuota dalam 1 hari yawww',
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

            // Form input section
            QuotaCalculatorForm(
              quotaController: _quotaController,
              totalPurchasedController: _totalPurchasedController,
              selectedDate: _selectedDate,
              currentDate: _currentDate,
              errors: _errors,
              onDateSelect: _selectExpiryDate,
              onCalculate: _calculateQuota,
              onInputChanged: _onInputChanged,
              onCurrentDateSelect: _selectCurrentDate,
            ),

            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }
}
