import 'package:flutter/material.dart';

class BMICalculationService {
  static double? _parseNumber(String text) {
    final s = text.trim().replaceAll(' ', '').replaceAll(',', '.');
    return double.tryParse(s);
  }

  static Map<String, String> validateInputs({
    required String? gender,
    required String heightText,
    required String weightText,
  }) {
    final errors = <String, String>{};

    if (gender == null || gender.isEmpty) {
      errors['gender'] = 'Pilih jenis kelamin';
    }

    if (heightText.trim().isEmpty) {
      errors['height'] = 'Tinggi badan wajib diisi';
    } else {
      final h = _parseNumber(heightText);
      if (h == null) {
        errors['height'] = 'Tinggi harus berupa angka';
      } else if (h <= 0) {
        errors['height'] = 'Tinggi harus lebih dari 0';
      }
    }

    if (weightText.trim().isEmpty) {
      errors['weight'] = 'Berat badan wajib diisi';
    } else {
      final w = _parseNumber(weightText);
      if (w == null) {
        errors['weight'] = 'Berat harus berupa angka';
      } else if (w <= 0) {
        errors['weight'] = 'Berat harus lebih dari 0';
      }
    }

    return errors;
  }

  static double calculateBMI({
    required double heightCm,
    required double weightKg,
  }) {
    final heightM = heightCm / 100.0;
    return weightKg / (heightM * heightM);
  }

  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  static Color getBMICategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.amber[700]!; // underweight
    if (bmi < 25.0) return Colors.green[600]!; // normal
    if (bmi < 30.0) return Colors.orange[700]!; // overweight
    return Colors.red[700]!; // obese
  }
}
