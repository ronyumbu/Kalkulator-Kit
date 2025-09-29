import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/quota_calculation_service.dart';

class QuotaCalculatorForm extends StatefulWidget {
  final TextEditingController quotaController;
  final TextEditingController? totalPurchasedController;
  final DateTime? selectedDate;
  final DateTime currentDate;
  final Map<String, String> errors;
  final VoidCallback onDateSelect;
  final VoidCallback onCalculate;
  final VoidCallback? onInputChanged;
  final VoidCallback? onCurrentDateSelect;

  const QuotaCalculatorForm({
    super.key,
    required this.quotaController,
    this.totalPurchasedController,
    required this.selectedDate,
    required this.currentDate,
    required this.errors,
    required this.onDateSelect,
    required this.onCalculate,
    this.onInputChanged,
    this.onCurrentDateSelect,
  });

  @override
  State<QuotaCalculatorForm> createState() => _QuotaCalculatorFormState();
}

class _QuotaCalculatorFormState extends State<QuotaCalculatorForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF2C2C2C)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Input Data Kuota',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Current Date (Read-only)
            _buildCurrentDateField(),
            const SizedBox(height: 16),

            // Remaining Quota Input
            _buildQuotaField(),
            const SizedBox(height: 16),

            // Optional Total Purchased Quota Input
            _buildTotalPurchasedField(),
            const SizedBox(height: 16),

            // Expiry Date (Date Picker)
            _buildExpiryDateField(),
            const SizedBox(height: 24),

            // Calculate Button
            _buildCalculateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.today, color: Colors.blue, size: 18),
            const SizedBox(width: 8),
            Text(
              'Tanggal Mulai',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const Spacer(),
            if (widget.onCurrentDateSelect != null)
              TextButton.icon(
                onPressed: widget.onCurrentDateSelect,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Ubah'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.onCurrentDateSelect,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? (widget.onCurrentDateSelect != null
                        ? const Color(0xFF404040)
                        : const Color(0xFF2C2C2C))
                  : (widget.onCurrentDateSelect != null
                        ? Colors.grey[50]
                        : Colors.grey[100]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF555555)
                    : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  QuotaCalculationService.formatDate(widget.currentDate),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                if (widget.onCurrentDateSelect != null)
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpiryDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.event, color: Colors.orange, size: 18),
            const SizedBox(width: 8),
            Text(
              'Tanggal Masa Tenggang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.onDateSelect,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF404040)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.errors.containsKey('expiryDate')
                    ? Colors.red
                    : (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF555555)
                          : Colors.grey[300]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedDate != null
                      ? QuotaCalculationService.formatDate(widget.selectedDate!)
                      : 'Tap untuk pilih tanggal',
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.selectedDate != null
                        ? (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87)
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600]),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (widget.errors.containsKey('expiryDate'))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errors['expiryDate']!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildQuotaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sim_card, color: Colors.green, size: 18),
            const SizedBox(width: 8),
            Text(
              'Sisa Kuota',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.quotaController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => widget.onInputChanged?.call(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Masukkan sisa kuota dalam GB',
            hintStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
            ),
            suffixText: 'GB',
            suffixStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[700],
            ),
            errorText: widget.errors['quota'],
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2C2C2C)
                : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPurchasedField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.purple, size: 18),
            const SizedBox(width: 8),
            Text(
              'Total Beli Kuota (Opsional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.totalPurchasedController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => widget.onInputChanged?.call(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Masukkan total kuota yang dibeli (GB)',
            hintStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
            ),
            suffixText: 'GB',
            suffixStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[700],
            ),
            errorText: widget.errors['totalPurchased'],
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2C2C2C)
                : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onCalculate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
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
            Icon(Icons.calculate, size: 20),
            SizedBox(width: 8),
            Text(
              'Hitung Batas Harian',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
