import 'package:flutter/material.dart';

class _TrapezoidPainter extends CustomPainter {
  final Color color;
  _TrapezoidPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw a geometric trapezium shape
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.8); // bottom left
    path.lineTo(size.width * 0.8, size.height * 0.8); // bottom right
    path.lineTo(size.width * 0.65, size.height * 0.2); // top right
    path.lineTo(size.width * 0.35, size.height * 0.2); // top left
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}