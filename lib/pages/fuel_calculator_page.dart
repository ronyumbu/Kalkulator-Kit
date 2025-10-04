import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/calculation_service.dart';
import '../widgets/fuel_calculator_form.dart';
import '../widgets/main_drawer.dart';
import '../widgets/fuel_result_dialog.dart';

class FuelCalculatorPage extends StatefulWidget {
  const FuelCalculatorPage({super.key});

  @override
  State<FuelCalculatorPage> createState() => _FuelCalculatorPageState();
}

class _FuelCalculatorPageState extends State<FuelCalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late FocusNode _keyboardFocusNode;

  // Controllers for text fields
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _efficiencyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _tollCostController = TextEditingController();
  final TextEditingController _parkingCostController = TextEditingController();

  // State variables
  Map<String, String> _errors = {};

  @override
  void dispose() {
    _distanceController.dispose();
    _efficiencyController.dispose();
    _priceController.dispose();
    _tollCostController.dispose();
    _parkingCostController.dispose();
    _keyboardFocusNode.dispose();
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
        _calculateCosts();
      } else if ((ch.toLowerCase()) == 'r') {
        _resetForm();
      }
    }
  }

  // Helper function to parse formatted number (remove dots)
  double _parseFormattedNumber(String value) {
    if (value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll('.', '')) ?? 0.0;
  }

  void _calculateCosts() {
    setState(() {
      // Validate inputs
      _errors = CalculationService.validateInputs(
        distance: _distanceController.text,
        efficiency: _efficiencyController.text,
        price: _priceController.text,
        tollCost: _tollCostController.text,
        parkingCost: _parkingCostController.text,
      );

      // If no errors, perform calculation
      if (_errors.isEmpty) {
        try {
          // Parse input values (handle formatted numbers)
          final distance = double.parse(_distanceController.text);
          final efficiency = double.parse(_efficiencyController.text);
          final price = _parseFormattedNumber(_priceController.text);
          final tollCost = _parseFormattedNumber(_tollCostController.text);
          final parkingCost = _parseFormattedNumber(
            _parkingCostController.text,
          );

          // Perform calculations
          final fuelCost = CalculationService.calculateFuelCost(
            distance,
            efficiency,
            price,
          );
          final totalCost = CalculationService.calculateTotalCost(
            fuelCost,
            tollCost,
            parkingCost,
          );
          final costPerKm = CalculationService.calculateCostPerKm(
            totalCost,
            distance,
          );

          // Hide keyboard after calculation
          FocusScope.of(context).unfocus();

          // Show result in beautiful dialog
          FuelResultDialog.show(
            context,
            totalCost: totalCost,
            costPerKm: costPerKm,
            fuelCost: fuelCost,
            tollCost: tollCost,
            parkingCost: parkingCost,
            distance: distance,
            efficiency: efficiency,
            fuelPrice: price,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error dalam kalkulasi: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mohon periksa input yang sudah diisi'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  void _resetForm() {
    setState(() {
      _distanceController.clear();
      _efficiencyController.clear();
      _priceController.clear();
      _tollCostController.clear();
      _parkingCostController.clear();
      _errors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Kalkulator BBM',
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
      body: RawKeyboardListener(
        focusNode: _keyboardFocusNode,
        onKey: _handleRawKey,
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with app description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800), // Orange BBM icon color
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
                          Icons.calculate,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Kalkulator BBM',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Kalkulator untuk menghitung biaya bahan bakar minyak',
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
            FuelCalculatorForm(
              distanceController: _distanceController,
              efficiencyController: _efficiencyController,
              priceController: _priceController,
              tollCostController: _tollCostController,
              parkingCostController: _parkingCostController,
              errors: _errors,
              onCalculate: _calculateCosts,
            ),

            const SizedBox(height: 32),
          ],
        ), // Column
      ), // SingleChildScrollView
    ), // RawKeyboardListener
  );
  }
}
