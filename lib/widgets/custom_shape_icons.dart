import 'package:flutter/material.dart';

class TrapezoidIcon extends StatelessWidget {
  final Color color;
  final double size;

  const TrapezoidIcon({
    super.key,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TrapezoidPainter(color: color),
      ),
    );
  }
}

class ParallelogramIcon extends StatelessWidget {
  final Color color;
  final double size;

  const ParallelogramIcon({
    super.key,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ParallelogramPainter(color: color),
      ),
    );
  }
}

class KiteIcon extends StatelessWidget {
  final Color color;
  final double size;

  const KiteIcon({
    super.key,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _KitePainter(color: color),
      ),
    );
  }
}

class _TrapezoidPainter extends CustomPainter {
  final Color color;

  _TrapezoidPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Trapezium: wider base, shorter top
    path.moveTo(size.width * 0.15, size.height * 0.85); // bottom left
    path.lineTo(size.width * 0.85, size.height * 0.85); // bottom right
    path.lineTo(size.width * 0.70, size.height * 0.15); // top right
    path.lineTo(size.width * 0.30, size.height * 0.15); // top left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParallelogramPainter extends CustomPainter {
  final Color color;

  _ParallelogramPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Parallelogram: slanted rectangle
    path.moveTo(size.width * 0.1, size.height * 0.85); // bottom left
    path.lineTo(size.width * 0.75, size.height * 0.85); // bottom right
    path.lineTo(size.width * 0.9, size.height * 0.15); // top right
    path.lineTo(size.width * 0.25, size.height * 0.15); // top left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _KitePainter extends CustomPainter {
  final Color color;

  _KitePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Kite shape: diamond with longer vertical axis
    path.moveTo(size.width * 0.5, size.height * 0.1); // top
    path.lineTo(size.width * 0.8, size.height * 0.45); // right
    path.lineTo(size.width * 0.5, size.height * 0.9); // bottom
    path.lineTo(size.width * 0.2, size.height * 0.45); // left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}