import 'package:flutter/material.dart';

class BMIResultDialog extends StatelessWidget {
  final double bmi;
  final String category;
  final Color categoryColor;
  final String gender;

  const BMIResultDialog({
    super.key,
    required this.bmi,
    required this.category,
    required this.categoryColor,
    required this.gender,
  });

  static void show(
    BuildContext context, {
    required double bmi,
    required String category,
    required Color categoryColor,
    required String gender,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BMIResultDialog(
        bmi: bmi,
        category: category,
        categoryColor: categoryColor,
        gender: gender,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String localizedCategory0(String cat) {
      switch (cat.toLowerCase()) {
        case 'underweight':
          return 'Kekurangan Berat Badan';
        case 'normal':
          return 'Normal';
        case 'overweight':
          return 'Kelebihan Berat Badan';
        case 'obese':
          return 'Obesitas';
        default:
          return cat;
      }
    }

    final localizedCategory = localizedCategory0(category);
  final recommendations = _getRecommendations(category.toLowerCase());
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header gradient with icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [categoryColor, categoryColor.withValues(alpha: 0.8)],
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
                      Icons.monitor_weight,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hasil BMI Anda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'BMI:',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[300]
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          bmi.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Kategori:',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[300]
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: categoryColor.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Text(
                            localizedCategory,
                            style: TextStyle(
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Simple legend (Indonesian)
                    Text(
                      'Klasifikasi Umum',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[300]
                            : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _legendRow('Kekurangan Berat Badan', Colors.amber[700]!),
                    const SizedBox(height: 6),
                    _legendRow('Normal', Colors.green[600]!),
                    const SizedBox(height: 6),
                    _legendRow('Kelebihan Berat Badan', Colors.orange[700]!),
                    const SizedBox(height: 6),
                    _legendRow('Obesitas', Colors.red[700]!),

                    const SizedBox(height: 16),
                    Text(
                      'Rekomendasi Kesehatan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[300]
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recommendations
                          .map(
                            (rec) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('•', style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      rec,
                                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Catatan: Sumber informasi rekomendasi kesehatan didapatkan dari berbagai sumber di internet.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: categoryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendRow(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  List<String> _getRecommendations(String cat) {
    switch (cat.toLowerCase()) {
      case 'underweight':
      case 'kekurangan berat badan':
      case 'kekurangan':
        return [
          'Periksa penyebab berat badan rendah seperti penyakit atau gangguan kesehatan.',
          'Tingkatkan asupan kalori dengan makanan sehat dan bergizi seimbang.',
          'Makan lebih sering dengan porsi kecil agar tidak cepat kenyang.',
          'Konsumsi minuman padat kalori dan nutrisi, misalnya susu atau jus buah.',
          'Rutin berolahraga, terutama latihan kekuatan untuk membentuk otot dan menambah nafsu makan.',
          'Konsultasi ke dokter untuk pemeriksaan dan penanganan lebih lanjut.',
        ];
      case 'normal':
      case 'normalnya':
        return [
          'Pertahankan pola makan sehat dan aktivitas fisik teratur.',
          'Hindari makanan olahan, makanan cepat saji, dan minuman tinggi gula.',
          'Jaga gaya hidup sehat dengan tidur cukup, mengelola stres, dan menghindari kebiasaan buruk seperti merokok atau konsumsi alkohol berlebihan.',
        ];
      case 'overweight':
      case 'kelebihan berat badan':
      case 'kelebihan':
        return [
          'Mulai perbaiki pola makan dengan mengurangi kalori dari makanan berlemak dan gula.',
          'Tingkatkan aktivitas fisik secara rutin, seperti berjalan, berlari, atau olahraga lainnya.',
          'Monitor berat badan secara berkala dan konsultasi dengan tenaga kesehatan jika perlu.',
        ];
      case 'obese':
      case 'obesitas':
        return [
          'Segera konsultasi dengan dokter untuk pemeriksaan dan rencana penurunan berat badan yang aman.',
          'Terapkan diet seimbang rendah kalori tetapi tetap bergizi.',
          'Tingkatkan aktivitas fisik secara konsisten.',
          'Pertimbangkan penanganan medis tambahan jika disarankan oleh dokter.',
        ];
      default:
        return [];
    }
  }
}
