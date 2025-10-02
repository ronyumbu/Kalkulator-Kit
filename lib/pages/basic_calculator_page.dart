import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class BasicCalculatorPage extends StatefulWidget {
  const BasicCalculatorPage({super.key});

  @override
  State<BasicCalculatorPage> createState() => _BasicCalculatorPageState();
}

class _BasicCalculatorPageState extends State<BasicCalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _display = '0';
  String _previousValue = '0';
  String _operation = '';
  bool _shouldResetDisplay = false;
  bool _hasDecimal = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_shouldResetDisplay || _display.isEmpty) {
        _display = number;
        _shouldResetDisplay = false;
        _hasDecimal = false;
      } else {
        if (_display == '0' && number != '0') {
          _display = number;
        } else if (_display != '0') {
          _display += number;
        }
      }
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (_shouldResetDisplay || _display.isEmpty) {
        _display = '0.';
        _shouldResetDisplay = false;
        _hasDecimal = true;
      } else if (!_hasDecimal) {
        _display += '.';
        _hasDecimal = true;
      }
    });
  }

  void _onOperationPressed(String op) {
    setState(() {
      if (_operation.isNotEmpty && !_shouldResetDisplay) {
        _calculateResult();
        _previousValue = _display; // Update previous value after calculation
      } else {
        _previousValue = _display;
      }
      _operation = op;
      _shouldResetDisplay = true;
      // Clear display immediately after operation is pressed
      _display = '';
      _hasDecimal = false;
    });
  }

  void _calculateResult() {
    if (_operation.isEmpty) return;

    double prev = double.tryParse(_previousValue) ?? 0;
    double current = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operation) {
      case '+':
        result = prev + current;
        break;
      case '-':
        result = prev - current;
        break;
      case '×':
        result = prev * current;
        break;
      case '÷':
        if (current == 0) {
          _showError('Tidak dapat membagi dengan nol');
          return;
        }
        result = prev / current;
        break;
    }

    setState(() {
      // Format result to remove unnecessary decimals
      if (result == result.toInt()) {
        _display = result.toInt().toString();
      } else {
        _display = result.toString();
      }
      _operation = '';
      _previousValue = '0';
      _shouldResetDisplay = true;
      _hasDecimal = _display.contains('.');
    });
  }

  void _onEqualsPressed() {
    _calculateResult();
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _previousValue = '0';
      _operation = '';
      _shouldResetDisplay = false;
      _hasDecimal = false;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.length > 1) {
        String removedChar = _display[_display.length - 1];
        _display = _display.substring(0, _display.length - 1);
        if (removedChar == '.') {
          _hasDecimal = false;
        }
      } else {
        _display = '0';
        _hasDecimal = false;
      }
    });
  }

  void _onToggleSignPressed() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
    });
  }

  void _onPercentagePressed() {
    setState(() {
      double value = double.tryParse(_display) ?? 0;
      double result = value / 100;

      if (result == result.toInt()) {
        _display = result.toInt().toString();
      } else {
        _display = result.toString();
      }
      _hasDecimal = _display.contains('.');
      _shouldResetDisplay = true;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDisplay(String value) {
    // Return '0' if value is empty
    if (value.isEmpty) {
      return '0';
    }
    
    // Add thousand separators for whole numbers
    if (!value.contains('.')) {
      final number = int.tryParse(value);
      if (number != null) {
        return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Kalkulator'),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[400]!],
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
                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calculate,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Kalkulator Angka Dasar',
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
                  'Kalkulator untuk perhitungan angka dasar.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Display area - smaller
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? const Color(0xFF404040) : Colors.grey[300]!,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_operation.isNotEmpty) ...[
                          Text(
                            '${_formatDisplay(_previousValue)} $_operation',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(
                            _formatDisplay(_display),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Calculator buttons in card
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? const Color(0xFF404040) : Colors.grey[300]!,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: _CalculatorButtons(
                        onNumberPressed: _onNumberPressed,
                        onDecimalPressed: _onDecimalPressed,
                        onOperationPressed: _onOperationPressed,
                        onEqualsPressed: _onEqualsPressed,
                        onClearPressed: _onClearPressed,
                        onDeletePressed: _onDeletePressed,
                        onToggleSignPressed: _onToggleSignPressed,
                        onPercentagePressed: _onPercentagePressed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorButtons extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDecimalPressed;
  final Function(String) onOperationPressed;
  final VoidCallback onEqualsPressed;
  final VoidCallback onClearPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onToggleSignPressed;
  final VoidCallback onPercentagePressed;

  const _CalculatorButtons({
    required this.onNumberPressed,
    required this.onDecimalPressed,
    required this.onOperationPressed,
    required this.onEqualsPressed,
    required this.onClearPressed,
    required this.onDeletePressed,
    required this.onToggleSignPressed,
    required this.onPercentagePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: [
        // Row 1
        _CalculatorButton(
          text: 'C',
          onPressed: onClearPressed,
          color: Colors.red[600]!,
          textColor: Colors.white,
        ),
        _CalculatorButton(
          text: '⌫',
          onPressed: onDeletePressed,
          color: Colors.orange[600]!,
          textColor: Colors.white,
        ),
        _CalculatorButton(
          text: '%',
          onPressed: onPercentagePressed,
          color: Colors.purple[600]!,
          textColor: Colors.white,
        ),
        _CalculatorButton(
          text: '÷',
          onPressed: () => onOperationPressed('÷'),
          color: Colors.blue[600]!,
          textColor: Colors.white,
        ),

        // Row 2
        _CalculatorButton(
          text: '7',
          onPressed: () => onNumberPressed('7'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '8',
          onPressed: () => onNumberPressed('8'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '9',
          onPressed: () => onNumberPressed('9'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '×',
          onPressed: () => onOperationPressed('×'),
          color: Colors.blue[600]!,
          textColor: Colors.white,
        ),

        // Row 3
        _CalculatorButton(
          text: '4',
          onPressed: () => onNumberPressed('4'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '5',
          onPressed: () => onNumberPressed('5'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '6',
          onPressed: () => onNumberPressed('6'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '-',
          onPressed: () => onOperationPressed('-'),
          color: Colors.blue[600]!,
          textColor: Colors.white,
        ),

        // Row 4
        _CalculatorButton(
          text: '1',
          onPressed: () => onNumberPressed('1'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '2',
          onPressed: () => onNumberPressed('2'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '3',
          onPressed: () => onNumberPressed('3'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '+',
          onPressed: () => onOperationPressed('+'),
          color: Colors.blue[600]!,
          textColor: Colors.white,
        ),

        // Row 5
        _CalculatorButton(
          text: '+/-',
          onPressed: onToggleSignPressed,
          color: Colors.grey[600]!,
          textColor: Colors.white,
        ),
        _CalculatorButton(
          text: '0',
          onPressed: () => onNumberPressed('0'),
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '.',
          onPressed: onDecimalPressed,
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          textColor: isDark ? Colors.white : Colors.black87,
        ),
        _CalculatorButton(
          text: '=',
          onPressed: onEqualsPressed,
          color: Colors.green[600]!,
          textColor: Colors.white,
        ),
      ],
    );
  }
}

class _CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const _CalculatorButton({
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF404040) : Colors.grey[300]!,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
