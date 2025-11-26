import 'package:flutter/material.dart';
import '../services/loan_calculation_service.dart';
import '../utils/currency_formatter.dart';

class LoanResultDialog extends StatefulWidget {
  final LoanResult result;
  final double originalPrice;
  final double downPayment;
  final double principal;
  final double annualInterestRate;
  final int tenorMonths;

  const LoanResultDialog({
    super.key,
    required this.result,
    required this.originalPrice,
    required this.downPayment,
    required this.principal,
    required this.annualInterestRate,
    required this.tenorMonths,
  });

  static void show(
    BuildContext context, {
    required LoanResult result,
    required double originalPrice,
    required double downPayment,
    required double principal,
    required double annualInterestRate,
    required int tenorMonths,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoanResultDialog(
        result: result,
        originalPrice: originalPrice,
        downPayment: downPayment,
        principal: principal,
        annualInterestRate: annualInterestRate,
        tenorMonths: tenorMonths,
      ),
    );
  }

  @override
  State<LoanResultDialog> createState() => _LoanResultDialogState();
}

class _LoanResultDialogState extends State<LoanResultDialog> {
  bool _showSchedule = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1C1C1C) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthlyPaymentCard(),
                    const SizedBox(height: 24),
                    _buildDetailsSection(context, isDark),
                    const SizedBox(height: 24),
                    _buildTotalPaymentCard(isDark),
                    const SizedBox(height: 16),
                    _buildScheduleToggle(isDark),
                    if (_showSchedule) ...[
                      const SizedBox(height: 16),
                      _buildScheduleTable(context),
                    ],
                  ],
                ),
              ),
            ),
            _buildFooterButton(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[500]!],
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
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Hasil Perhitungan Cicilan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.result.interestType,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyPaymentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.green[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[300]!),
      ),
      child: Column(
        children: [
          Text(
            'Cicilan Per Bulan',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.formatCurrencyNoDecimal(
              widget.result.monthlyPayment,
            ),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, bool isDark) {
    final hasDownPayment = widget.downPayment > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rincian Pinjaman',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        if (hasDownPayment) ...[
          _buildDetailRow(
            context,
            'Harga / Total',
            CurrencyFormatter.formatCurrencyNoDecimal(widget.originalPrice),
            Icons.shopping_cart,
            Colors.indigo,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            context,
            'Uang Muka (DP)',
            CurrencyFormatter.formatCurrencyNoDecimal(widget.downPayment),
            Icons.payments_outlined,
            Colors.teal,
          ),
          const SizedBox(height: 12),
        ],
        _buildDetailRow(
          context,
          hasDownPayment ? 'Sisa Pinjaman' : 'Jumlah Pinjaman',
          CurrencyFormatter.formatCurrencyNoDecimal(widget.principal),
          Icons.account_balance,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          context,
          'Suku Bunga',
          '${widget.annualInterestRate.toStringAsFixed(2)}% / tahun',
          Icons.percent,
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          context,
          'Tenor',
          '${widget.tenorMonths} bulan (${(widget.tenorMonths / 12).toStringAsFixed(1)} tahun)',
          Icons.calendar_month,
          Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          context,
          'Total Bunga',
          CurrencyFormatter.formatCurrencyNoDecimal(
            widget.result.totalInterest,
          ),
          Icons.trending_up,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildTotalPaymentCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.payments, color: Colors.green[600], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.formatCurrencyNoDecimal(
                    widget.result.totalPayment,
                  ),
                  style: TextStyle(
                    color: Colors.green[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleToggle(bool isDark) {
    return InkWell(
      onTap: () {
        setState(() {
          _showSchedule = !_showSchedule;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF404040) : Colors.blue[200]!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _showSchedule ? Icons.visibility_off : Icons.visibility,
              color: Colors.blue[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _showSchedule
                  ? 'Sembunyikan Jadwal Cicilan'
                  : 'Lihat Jadwal Cicilan',
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Tutup',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleTable(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final schedule = widget.result.schedule;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? const Color(0xFF404040) : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                _buildTableHeaderCell('Bln', flex: 1),
                _buildTableHeaderCell('Pokok', flex: 2),
                _buildTableHeaderCell('Bunga', flex: 2),
                _buildTableHeaderCell('Sisa', flex: 2),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final item = schedule[index];
                final isEven = index % 2 == 0;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isEven
                        ? (isDark ? Colors.transparent : Colors.white)
                        : (isDark ? const Color(0xFF252525) : Colors.grey[50]),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? const Color(0xFF404040)
                            : Colors.grey[200]!,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildTableCell('${item.month}', flex: 1, isDark: isDark),
                      _buildTableCell(
                        _formatShortCurrency(item.principalPayment),
                        flex: 2,
                        isDark: isDark,
                      ),
                      _buildTableCell(
                        _formatShortCurrency(item.interestPayment),
                        flex: 2,
                        isDark: isDark,
                      ),
                      _buildTableCell(
                        _formatShortCurrency(item.remainingPrincipal),
                        flex: 2,
                        isDark: isDark,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    required int flex,
    required bool isDark,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: isDark ? Colors.grey[300] : Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatShortCurrency(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}M';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}rb';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}
