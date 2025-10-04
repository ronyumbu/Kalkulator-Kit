import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/main_drawer.dart';
import '../services/age_calculation_service.dart';

class AgeCalculatorPage extends StatefulWidget {
  const AgeCalculatorPage({super.key});

  @override
  State<AgeCalculatorPage> createState() => _AgeCalculatorPageState();
}

class _AgeCalculatorPageState extends State<AgeCalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late FocusNode _keyboardFocusNode;
  
  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final initialDate = _selectedBirthDate ?? DateTime(now.year - 25, now.month, now.day);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: AgeCalculationService.getMinBirthDate(),
      lastDate: AgeCalculationService.getMaxBirthDate(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.teal[600],
            ),
            dialogTheme: DialogThemeData(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 1,
                minimumSize: const Size(60, 36),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 1,
                minimumSize: const Size(60, 36),
              ),
            ),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: child!,
          ),
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _calculateAge() async {
    if (_selectedBirthDate == null) {
      // Only show a snackbar to avoid duplicating the same text in the page
      _showSnackBar('Silakan pilih tanggal lahir terlebih dahulu');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Add small delay for better UX
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final result = AgeCalculationService.calculateAge(_selectedBirthDate!);
      
      // Haptic feedback
      HapticFeedback.mediumImpact();
      
      if (mounted) {
        _showResultDialog(result);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showResultDialog(AgeCalculationResult result) {
    showDialog(
      context: context,
      builder: (context) => _AgeResultDialog(result: result),
    );
  }

  void _resetCalculator() {
    setState(() {
      _selectedBirthDate = null;
      _isLoading = false;
      _errorMessage = null;
    });
    
    // Haptic feedback
    HapticFeedback.lightImpact();
  }

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
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _handleRawKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      final ch = event.character ?? key.keyLabel;
      if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
        _calculateAge();
      } else if ((ch.toLowerCase()) == 'r') {
        _resetCalculator();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Kalkulator Usia',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _resetCalculator,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: RawKeyboardListener(
        focusNode: _keyboardFocusNode,
        onKey: _handleRawKey,
        child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    if (_errorMessage != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                                  Icons.cake,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  'Kalkulator Usia',
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
                            'Hitung usia Anda secara detail dari tanggal lahir hingga sekarang.',
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

                    // Instruction Card (tests expect 'Cara Penggunaan' and some guidance text)
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.help_outline, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Cara Penggunaan', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('1. Tap pada kolom "Tanggal Lahir" untuk membuka pemilih tanggal.'),
                                  Text('2. Pilih tanggal lahir Anda.'),
                                  Text('3. Tap tombol "Hitung Usia" untuk melihat hasil perhitungan.'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Birth Date Selection Card
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
                            Text(
                              'Tanggal Lahir',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Date Selection Button
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isDark 
                                    ? const Color(0xFF404040)
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark 
                                      ? const Color(0xFF555555)
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _selectBirthDate,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedBirthDate != null
                                              ? AgeCalculationService.formatDate(_selectedBirthDate!)
                                              : 'Tap untuk pilih tanggal lahir',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _selectedBirthDate != null
                                                ? (isDark ? Colors.white : Colors.black87)
                                                : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          color: Colors.teal[600],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            if (_selectedBirthDate != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.teal[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.teal[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.teal[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Tanggal lahir: ${AgeCalculationService.formatDate(_selectedBirthDate!)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.teal[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Calculate Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _calculateAge,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[600],
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calculate, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Hitung Usia',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
  }
}

class _AgeResultDialog extends StatelessWidget {
  final AgeCalculationResult result;

  const _AgeResultDialog({required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark 
          ? const Color(0xFF1C1C1C)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[600]!, Colors.teal[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.cake,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Hasil Perhitungan Usia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Main Age Result
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.teal[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? Colors.grey[600]! : Colors.teal[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Usia Anda',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey[300] : Colors.teal[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.formattedAge,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.grey[200] : Colors.teal[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Detailed Results
                    Text(
                      'Perhitungan Detail',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDetailRow('Total Tahun', '${AgeCalculationService.formatNumber(result.totalYears)} tahun', context),
                    _buildDetailRow('Total Bulan', '${AgeCalculationService.formatNumber(result.totalMonths)} bulan', context),
                    _buildDetailRow('Total Minggu', '${AgeCalculationService.formatNumber(result.totalWeeks)} minggu', context),
                    _buildDetailRow('Total Hari', '${AgeCalculationService.formatNumber(result.totalDays)} hari', context),
                    _buildDetailRow('Total Jam', '${AgeCalculationService.formatNumber(result.totalHours)} jam', context),
                    _buildDetailRow('Total Menit', '${AgeCalculationService.formatNumber(result.totalMinutes)} menit', context),
                    _buildDetailRow('Total Detik', '${AgeCalculationService.formatNumber(result.totalSeconds)} detik', context),
                  ],
                ),
              ),
            ),

            // Close Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}