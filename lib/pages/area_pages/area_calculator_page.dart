import 'package:flutter/material.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/custom_shape_icons.dart';

class AreaCalculatorPage extends StatelessWidget {
  const AreaCalculatorPage({super.key});

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  Widget _buildShapeCard(BuildContext context, String name, IconData? icon, Color color, String route, {Widget? customIcon}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _navigateTo(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customIcon ?? Icon(icon!, color: color, size: 48),
              const SizedBox(height: 8),
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Luas Bangun'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Menu',
          ),
        ),
      ),
  drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.pink,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.2 * 255).toInt()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(Icons.straighten, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kalkulator Luas Bangun',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Kalkulator untuk menghitung luas berbagai bangun datar.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
                const SizedBox(height: 16),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int cross = 2;
                      if (width > 1200) {
                        cross = 4;
                      } else if (width > 800) {
                        cross = 3;
                      }
                      return GridView.count(
                        crossAxisCount: cross,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          _buildShapeCard(context, 'Persegi', Icons.crop_square, Colors.blue, '/area_square'),
                          _buildShapeCard(context, 'Persegi Panjang', Icons.rectangle, Colors.green, '/area_rectangle'),
                          _buildShapeCard(context, 'Segitiga', Icons.change_history, Colors.orange, '/area_triangle'),
                          _buildShapeCard(context, 'Jajar Genjang', null, Colors.purple, '/area_parallelogram', 
                            customIcon: ParallelogramIcon(color: Colors.purple, size: 48)),
                          _buildShapeCard(context, 'Trapesium', null, const Color(0xFFC1311C), '/area_trapezoid',
                            customIcon: TrapezoidIcon(color: const Color(0xFFC1311C), size: 48)),
                          _buildShapeCard(context, 'Layang-Layang', null, Colors.cyan, '/area_rhombus',
                            customIcon: KiteIcon(color: Colors.cyan, size: 48)),
                          _buildShapeCard(context, 'Lingkaran', Icons.circle, Colors.pink, '/area_circle'),
                        ],
                      );
                    },
                  ),
                ),
          ],
            ),
          ),
        ),
      ),
    );
  }
}
