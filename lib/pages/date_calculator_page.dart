import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/main_drawer.dart';
import '../services/date_calculation_service.dart';

enum DateCalculationMode { difference, addSubtract }

class DateCalculatorPage extends StatefulWidget {
  const DateCalculatorPage({super.key});

  @override
  State<DateCalculatorPage> createState() => _DateCalculatorPageState();
}

class _DateCalculatorPageState extends State<DateCalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateCalculationMode _selectedMode = DateCalculationMode.difference;
  DateTime _startDate = DateCalculationService.getToday();
  DateTime _endDate = DateCalculationService.getToday().add(
    const Duration(days: 1),
  );
  DateTime _baseDate = DateCalculationService.getToday();
  int _daysToAddSubtract = 1;
  bool _isLoading = false;
  bool _isManualInput = false; // Toggle between stepper and manual input

  final TextEditingController _daysController = TextEditingController(
    text: '1',
  );
  final FocusNode _daysFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _daysController.addListener(_onDaysChanged);
    _daysFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _daysController.dispose();
    _daysFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_daysFocusNode.hasFocus && _isManualInput) {
      setState(() {
        _isManualInput = false;
      });
    }
  }

  void _onDaysChanged() {
    final value = int.tryParse(_daysController.text);
    if (value != null) {
      setState(() {
        _daysToAddSubtract = value;
      });
    }
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[600]!, Colors.indigo[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.date_range, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Kalkulator Tanggal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Kalkulator untuk menghitung selisih tanggal, penambahan atau pengurangan hari dari tanggal tertentu.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = isStartDate
        ? _startDate
        : (_selectedMode == DateCalculationMode.difference ? _endDate : _baseDate);
    
    String title;
    if (_selectedMode == DateCalculationMode.difference) {
      title = isStartDate ? 'Pilih Tanggal Awal' : 'Pilih Tanggal Akhir';
    } else {
      title = 'Pilih Tanggal Dasar';
    }

    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: CalendarDatePicker(
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              onDateChanged: (DateTime date) {
                // Langsung tutup dialog dan return tanggal yang dipilih
                Navigator.of(context).pop(date);
              },
            ),
          ),
          contentPadding: const EdgeInsets.all(16),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1C1C1C)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.indigo[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (_selectedMode == DateCalculationMode.difference) {
          if (isStartDate) {
            _startDate = picked;
          } else {
            _endDate = picked;
          }
        } else {
          _baseDate = picked;
        }
      });
    }
  }

  void _calculate() {
    setState(() {
      _isLoading = true;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    try {
      String result;
      if (_selectedMode == DateCalculationMode.difference) {
        final difference = DateCalculationService.calculateDateDifference(
          _startDate,
          _endDate,
        );
        result = DateCalculationService.formatDateDifferenceResult(
          _startDate,
          _endDate,
          difference,
        );
      } else {
        final resultDate = DateCalculationService.addSubtractDays(
          _baseDate,
          _daysToAddSubtract,
        );
        result = DateCalculationService.formatAddSubtractResult(
          _baseDate,
          _daysToAddSubtract,
          resultDate,
        );
      }

      setState(() {
        _isLoading = false;
      });

      // Show result in popup
      _showResultPopup(result);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError(e.toString());
    }
  }

  void _showResultPopup(String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
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
                      colors: [Colors.indigo[600]!, Colors.indigo[400]!],
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
                          Icons.date_range,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hasil Perhitungan Tanggal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Result Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF2C2C2C)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: _buildFormattedResult(result),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormattedDateDisplay(String dateString, String dayString) {
    // Parse date string like "1 Oktober 2025", "30 September 2025", etc.
    final dateParts = dateString.trim().split(' ');
    
    if (dateParts.length >= 3) {
      final day = dateParts[0];
      // Gabungkan semua bagian setelah hari sebagai month + year
      final monthYear = dateParts.sublist(1).join(' ');
      
      return Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            monthYear,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($dayString)',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
        ],
      );
    }
    
    // Fallback jika format tidak sesuai dengan expected pattern
    return Column(
      children: [
        Text(
          dateString,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '($dayString)',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[300]
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFormattedResult(String result) {
    final parts = result.split('|');
    if (parts.length < 6) {
      return Text(
        result,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.indigo[300]
              : Colors.indigo[700],
          height: 1.5,
        ),
      );
    }

    final type = parts[0];
    final days = parts[1];
    final startDate = parts[2];
    final startDay = parts[3];
    final endDate = parts[4];
    final endDay = parts[5];

    return Column(
      children: [
        if (type == 'SINGLE_DAY') ...[
          // Format seperti gambar pertama - "1 Hari"
          Text(
            days,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hari',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 2,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]
                : Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            startDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($startDay)',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            endDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($endDay)',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
        ] else if (type == 'ADD_SINGLE') ...[
          // Format seperti gambar kedua - "30 September 2025"
          _buildFormattedDateDisplay(endDate, endDay),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 2,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]
                : Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            '$days Hari Setelah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            startDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($startDay)',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
        ] else if (type == 'SUBTRACT_SINGLE') ...[
          // Format untuk pengurangan 1 hari
          _buildFormattedDateDisplay(endDate, endDay),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 2,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]
                : Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            '$days Hari Sebelum',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            startDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($startDay)',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
        ] else if (type == 'MULTIPLE_DAYS') ...[
          // Format untuk selisih beberapa hari
          Text(
            days,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hari',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 2,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]
                : Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            startDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($startDay)',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            endDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($endDay)',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
        ] else if (type == 'ADD_MULTIPLE') ...[
          // Format untuk penambahan beberapa hari
          _buildFormattedDateDisplay(endDate, endDay),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 2,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]
                : Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            '$days Hari Setelah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            startDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($startDay)',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
        ] else if (type == 'SUBTRACT_MULTIPLE') ...[
          // Format untuk pengurangan beberapa hari
          _buildFormattedDateDisplay(endDate, endDay),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 2,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]
                : Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            '$days Hari Sebelum',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            startDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($startDay)',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
        ] else ...[
          // Fallback untuk format lain
          Text(
            result,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.indigo[300]
                  : Colors.indigo[700],
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  void _reset() {
    setState(() {
      _startDate = DateCalculationService.getToday();
      _endDate = DateCalculationService.getToday().add(const Duration(days: 1));
      _baseDate = DateCalculationService.getToday();
      _daysToAddSubtract = 1;
      _daysController.text = '1';
    });
    HapticFeedback.lightImpact();
  }

  Widget _buildModeSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mode Perhitungan',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedMode = DateCalculationMode.difference;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedMode == DateCalculationMode.difference
                              ? Colors.indigo[600]!
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[400]!
                                  : Colors.grey[600]!),
                          width: 2,
                        ),
                        color: _selectedMode == DateCalculationMode.difference
                            ? Colors.indigo[600]
                            : Colors.transparent,
                      ),
                      child: _selectedMode == DateCalculationMode.difference
                          ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Selisih antara Dua Tanggal',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Hitung jumlah hari antara dua tanggal',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedMode = DateCalculationMode.addSubtract;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedMode == DateCalculationMode.addSubtract
                              ? Colors.indigo[600]!
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[400]!
                                  : Colors.grey[600]!),
                          width: 2,
                        ),
                        color: _selectedMode == DateCalculationMode.addSubtract
                            ? Colors.indigo[600]
                            : Colors.transparent,
                      ),
                      child: _selectedMode == DateCalculationMode.addSubtract
                          ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Tambah/Kurang Hari',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tambah atau kurangi hari dari tanggal',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
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

  Widget _buildDateInputs() {
    if (_selectedMode == DateCalculationMode.difference) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Tanggal',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Awal',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 8),
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () => _selectDate(context, true),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.indigo[500]!, Colors.indigo[400]!],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateCalculationService.formatIndonesianDate(
                                            _startDate,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          DateCalculationService.getIndonesianDay(_startDate),
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Akhir',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 8),
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () => _selectDate(context, false),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.indigo[500]!, Colors.indigo[400]!],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateCalculationService.formatIndonesianDate(
                                            _endDate,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          DateCalculationService.getIndonesianDay(_endDate),
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tanggal dan Hari',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Tanggal Dasar',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 8),
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => _selectDate(context, false),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo[500]!, Colors.indigo[400]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateCalculationService.formatIndonesianDate(
                                    _baseDate,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateCalculationService.getIndonesianDay(_baseDate),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Combined stepper and manual input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Combined stepper row with clickable number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Decrease button
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              if (_daysToAddSubtract.abs() > 1) {
                                final isPositive = _daysToAddSubtract > 0;
                                final absValue = _daysToAddSubtract.abs() - 1;
                                _daysToAddSubtract = isPositive ? absValue : -absValue;
                                _daysController.text = _daysToAddSubtract.abs().toString();
                              }
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[600]
                                  : Colors.grey[600],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Clickable number display/input field
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              _isManualInput = true;
                            });
                            // Focus on the text field after a small delay to ensure it's shown
                            Future.delayed(const Duration(milliseconds: 100), () {
                              if (mounted) {
                                _daysFocusNode.requestFocus();
                              }
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[600]
                                  : Colors.grey[400],
                              borderRadius: BorderRadius.circular(20),
                              border: _isManualInput ? Border.all(
                                color: Colors.indigo[600]!,
                                width: 2,
                              ) : null,
                            ),
                            child: _isManualInput 
                                ? Center(
                                    child: IntrinsicWidth(
                                      child: TextField(
                                        controller: _daysController,
                                        focusNode: _daysFocusNode,
                                        textAlign: TextAlign.center,
                                        keyboardType: const TextInputType.numberWithOptions(
                                          signed: false,
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                        ),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                        onChanged: (value) {
                                          final intValue = int.tryParse(value);
                                          if (intValue != null && intValue > 0) {
                                            setState(() {
                                              final isPositive = _daysToAddSubtract > 0;
                                              _daysToAddSubtract = isPositive ? intValue : -intValue;
                                            });
                                          }
                                        },
                                        onSubmitted: (value) {
                                          setState(() {
                                            _isManualInput = false;
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      _daysToAddSubtract.abs().toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Increase button
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              final isPositive = _daysToAddSubtract > 0;
                              final absValue = _daysToAddSubtract.abs() + 1;
                              _daysToAddSubtract = isPositive ? absValue : -absValue;
                              _daysController.text = _daysToAddSubtract.abs().toString();
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[600]
                                  : Colors.grey[600],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Dropdown for "Hari Sebelum/Sesudah"
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[700]
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<bool>(
                          value: _daysToAddSubtract > 0,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: false,
                              child: Center(
                                child: Text(
                                  'Hari Sebelum',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: true,
                              child: Center(
                                child: Text(
                                  'Hari Sesudah',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                final absValue = _daysToAddSubtract.abs();
                                _daysToAddSubtract = value ? absValue : -absValue;
                                _daysController.text = _daysToAddSubtract.toString();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildActionButtons() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _calculate,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.calculate, color: Colors.white),
            label: Text(
              _isLoading ? 'Menghitung...' : 'Hitung',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Kalkulator Tanggal'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
            tooltip: 'Reset Form',
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildModeSelector(),
            const SizedBox(height: 16),
            _buildDateInputs(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
