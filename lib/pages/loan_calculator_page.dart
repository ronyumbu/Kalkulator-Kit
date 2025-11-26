import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/loan_calculation_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/main_drawer.dart';
import '../widgets/loan_result_dialog.dart';
import '../utils/thousands_separator_input_formatter.dart';

class LoanCalculatorPage extends StatefulWidget {
  const LoanCalculatorPage({super.key});

  @override
  State<LoanCalculatorPage> createState() => _LoanCalculatorPageState();
}

class _LoanCalculatorPageState extends State<LoanCalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late FocusNode _keyboardFocusNode;

  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _downPaymentController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _tenorController = TextEditingController();

  String? _interestType; // 'flat' atau 'declining'
  String _interestRatePeriod = 'yearly'; // 'yearly' atau 'monthly'
  Map<String, String> _errors = {};

  @override
  void initState() {
    super.initState();
    _keyboardFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _keyboardFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _principalController.dispose();
    _downPaymentController.dispose();
    _interestRateController.dispose();
    _tenorController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _handleRawKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      final ch = event.character ?? key.keyLabel;
      if (key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.numpadEnter) {
        _onCalculate();
      } else if ((ch.toLowerCase()) == 'r') {
        _onReset();
      }
    }
  }

  double _parseFormattedNumber(String value) {
    if (value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '.')) ??
        0.0;
  }

  void _onCalculate() {
    setState(() {
      _errors = LoanCalculationService.validateInputs(
        principalText: _principalController.text,
        downPaymentText: _downPaymentController.text,
        interestRateText: _interestRateController.text,
        tenorText: _tenorController.text,
        interestType: _interestType,
      );
    });

    if (!mounted) return;

    if (_errors.isEmpty) {
      try {
        final principal = _parseFormattedNumber(_principalController.text);
        final downPayment = _parseFormattedNumber(_downPaymentController.text);
        final loanAmount = principal - downPayment;

        double interestRate = double.parse(
          _interestRateController.text.replaceAll(',', '.'),
        );

        // Jika bunga bulanan, konversi ke tahunan
        final annualInterestRate = _interestRatePeriod == 'monthly'
            ? interestRate * 12
            : interestRate;

        final tenor = int.parse(_tenorController.text);

        LoanResult result;
        if (_interestType == 'flat') {
          result = LoanCalculationService.calculateFlatInterest(
            principal: loanAmount,
            annualInterestRate: annualInterestRate,
            tenorMonths: tenor,
          );
        } else {
          result = LoanCalculationService.calculateDecliningInterest(
            principal: loanAmount,
            annualInterestRate: annualInterestRate,
            tenorMonths: tenor,
          );
        }

        if (!mounted) return;
        FocusScope.of(context).unfocus();

        LoanResultDialog.show(
          context,
          result: result,
          originalPrice: principal,
          downPayment: downPayment,
          principal: loanAmount,
          annualInterestRate: annualInterestRate,
          tenorMonths: tenor,
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
  }

  void _onReset() {
    setState(() {
      _principalController.clear();
      _downPaymentController.clear();
      _interestRateController.clear();
      _tenorController.clear();
      _interestType = null;
      _interestRatePeriod = 'yearly';
      _errors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Kalkulator Cicilan',
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
      body: RawKeyboardListener(
        focusNode: _keyboardFocusNode,
        onKey: _handleRawKey,
        child: SingleChildScrollView(
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Kalkulator Cicilan',
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
                      'Hitung cicilan pinjaman dengan bunga flat atau menurun',
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

              // Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Pinjaman',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Jumlah Pinjaman
                    CustomTextField(
                      label: 'Harga / Jumlah Pinjaman',
                      hintText: 'Masukkan jumlah pinjaman',
                      controller: _principalController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.green[600],
                        size: 20,
                      ),
                      suffixText: 'Rp',
                      errorText: _errors['principal'],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Uang Muka (DP) - Opsional
                    CustomTextField(
                      label: 'Uang Muka / DP (Opsional)',
                      hintText: 'Kosongkan jika tidak ada DP',
                      controller: _downPaymentController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(
                        Icons.payments_outlined,
                        color: Colors.teal[600],
                        size: 20,
                      ),
                      suffixText: 'Rp',
                      errorText: _errors['downPayment'],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Suku Bunga
                    CustomTextField(
                      label: 'Suku Bunga',
                      hintText: 'Contoh: 12.5',
                      controller: _interestRateController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixIcon: Icon(
                        Icons.percent,
                        color: Colors.orange[600],
                        size: 20,
                      ),
                      suffixText: _interestRatePeriod == 'yearly'
                          ? '% / tahun'
                          : '% / bulan',
                      errorText: _errors['interestRate'],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*[,.]?\d*'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Pilihan periode bunga
                    Row(
                      children: [
                        Expanded(
                          child: _buildRatePeriodChip(
                            label: 'Per Tahun',
                            value: 'yearly',
                            isSelected: _interestRatePeriod == 'yearly',
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildRatePeriodChip(
                            label: 'Per Bulan',
                            value: 'monthly',
                            isSelected: _interestRatePeriod == 'monthly',
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tenor
                    CustomTextField(
                      label: 'Tenor (Jangka Waktu)',
                      hintText: 'Masukkan tenor dalam bulan',
                      controller: _tenorController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.purple[600],
                        size: 20,
                      ),
                      suffixText: 'bulan',
                      errorText: _errors['tenor'],
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 20),

                    // Jenis Bunga
                    Text(
                      'Jenis Bunga',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInterestTypeCard(
                            title: 'Bunga Flat',
                            subtitle: 'Cicilan tetap',
                            icon: Icons.horizontal_rule,
                            value: 'flat',
                            isSelected: _interestType == 'flat',
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInterestTypeCard(
                            title: 'Bunga Menurun',
                            subtitle: 'Cicilan efektif',
                            icon: Icons.trending_down,
                            value: 'declining',
                            isSelected: _interestType == 'declining',
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),

                    if (_errors['interestType'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errors['interestType']!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.blue[900]!.withValues(alpha: 0.3)
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.blue[700]! : Colors.blue[200]!,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[600],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Perbedaan Jenis Bunga',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '• Bunga Flat: Bunga dihitung dari pokok awal, cicilan tetap setiap bulan.\n'
                            '• Bunga Menurun: Bunga dihitung dari sisa pokok, total bunga lebih kecil.',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Calculate Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onCalculate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calculate, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Hitung Cicilan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required bool isSelected,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _interestType = value;
          _errors.remove('interestType');
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? Colors.green[900]!.withValues(alpha: 0.5)
                    : Colors.green[50])
              : (isDark ? const Color(0xFF2C2C2C) : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.green[600]!
                : (isDark ? const Color(0xFF404040) : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.green[600]
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isSelected
                    ? Colors.green[700]
                    : (isDark ? Colors.white : Colors.black87),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatePeriodChip({
    required String label,
    required String value,
    required bool isSelected,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _interestRatePeriod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? Colors.orange[900]!.withValues(alpha: 0.5)
                    : Colors.orange[50])
              : (isDark ? const Color(0xFF2C2C2C) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.orange[600]!
                : (isDark ? const Color(0xFF404040) : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? Colors.orange[600]
                  : (isDark ? Colors.grey[500] : Colors.grey[400]),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
                color: isSelected
                    ? Colors.orange[700]
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
