import 'package:flutter/material.dart';

class TrapezoidPainter extends CustomPainter {
  final Color color;
  TrapezoidPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    // Draw a trapezium shape similar to the image: wider base, shorter top
    path.moveTo(size.width * 0.2, size.height);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width * 0.65, size.height * 0.3);
    path.lineTo(size.width * 0.35, size.height * 0.3);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}