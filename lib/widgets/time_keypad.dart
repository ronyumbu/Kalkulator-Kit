import 'package:flutter/material.dart';

class TimeKeypad extends StatelessWidget {
  final void Function(String key) onKey;
  const TimeKeypad({super.key, required this.onKey});

  @override
  Widget build(BuildContext context) {
    final buttons = <_KeySpec>[
      // Row 1 (backspace removed). AC and C will expand to fill the freed space equally.
      _KeySpec('AC', color: Colors.red),
      _KeySpec('C', color: Colors.orange),
      _KeySpec('÷', color: Colors.blue, mapTo: '/'),
      // Row 2
      _KeySpec('7'),
      _KeySpec('8'),
      _KeySpec('9'),
      _KeySpec('×', color: Colors.blue, mapTo: '*'),
      // Row 3
      _KeySpec('4'),
      _KeySpec('5'),
      _KeySpec('6'),
      _KeySpec('-', color: Colors.blue),
      // Row 4
      _KeySpec('1'),
      _KeySpec('2'),
      _KeySpec('3'),
      _KeySpec('+', color: Colors.blue),
      // Row 5 (exclude +24 and -24 as requested; '=' also excluded as per prior instruction)
      _KeySpec('0'), _KeySpec('00'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const spacing = 12.0;
        final columns = 4;
        final cellWidth = (width - (spacing * (columns - 1))) / columns;
        // Target height so buttons are roughly square-ish
        final targetHeight = cellWidth * 0.9;
        final wideWidth = cellWidth * 1.5 + (spacing / 2);
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: buttons.map((b) {
            final label = b.label;
            final value = b.mapTo ?? label;
            final w = (label == 'AC' || label == 'C' || label == '00')
                ? wideWidth
                : cellWidth;
            final isAC = label == 'AC';
            final sideColor = isAC ? Colors.red[600]! : Colors.grey[300]!;
            final ButtonStyle style = isAC
                ? ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.red[600]!;
                      }
                      return Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF2C2C2C)
                          : Colors.white;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white;
                      }
                      return Colors.red[600]!;
                    }),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.red[400]!
                            : sideColor,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    elevation: const MaterialStatePropertyAll(0),
                  )
                : ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF2C2C2C)
                            : Colors.white,
                    foregroundColor: b.color ??
                        (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87),
                    side: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF404040)
                          : sideColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  );
            return SizedBox(
              width: w,
              height: targetHeight.clamp(48.0, 80.0),
              child: ElevatedButton(
                style: style,
                onPressed: () => onKey(value),
                child: Text(
                  label,
                  style: isAC
                      ? TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[600]!,
                        )
                      : TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: b.color ??
                              (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87),
                        ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _KeySpec {
  final String label;
  final Color? color;
  final String? mapTo;
  _KeySpec(this.label, {this.color, this.mapTo});
}
