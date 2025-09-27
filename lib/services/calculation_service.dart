class CalculationService {
  /// Calculate fuel cost based on distance, efficiency, and price
  static double calculateFuelCost(
    double distance,
    double efficiency,
    double price,
  ) {
    if (efficiency <= 0) {
      throw ArgumentError('Efisiensi bahan bakar harus lebih dari 0');
    }
    return (distance / efficiency) * price;
  }

  /// Calculate total cost including fuel, toll, and parking
  static double calculateTotalCost(
    double fuelCost,
    double tollCost,
    double parkingCost,
  ) {
    return fuelCost + tollCost + parkingCost;
  }

  /// Calculate cost per kilometer
  static double calculateCostPerKm(double totalCost, double distance) {
    if (distance <= 0) {
      throw ArgumentError('Jarak harus lebih dari 0');
    }
    return totalCost / distance;
  }

  /// Validate input values
  static Map<String, String> validateInputs({
    required String distance,
    required String efficiency,
    required String price,
    required String tollCost,
    required String parkingCost,
  }) {
    Map<String, String> errors = {};

    if (distance.isEmpty) {
      errors['distance'] = 'Jarak perjalanan harus diisi';
    } else {
      final distanceValue = double.tryParse(distance);
      if (distanceValue == null || distanceValue <= 0) {
        errors['distance'] = 'Jarak harus berupa angka positif';
      }
    }

    if (efficiency.isEmpty) {
      errors['efficiency'] = 'Efisiensi bahan bakar harus diisi';
    } else {
      final efficiencyValue = double.tryParse(efficiency);
      if (efficiencyValue == null || efficiencyValue <= 0) {
        errors['efficiency'] = 'Efisiensi harus berupa angka positif';
      }
    }

    if (price.isEmpty) {
      errors['price'] = 'Harga bahan bakar harus diisi';
    } else {
      // Remove dots for validation (dots are thousand separators)
      String cleanPrice = price.replaceAll('.', '');
      final priceValue = double.tryParse(cleanPrice);
      if (priceValue == null || priceValue <= 0) {
        errors['price'] = 'Harga harus berupa angka positif';
      }
    }

    // Toll and parking costs are optional, but if provided must be valid
    if (tollCost.isNotEmpty) {
      String cleanTollCost = tollCost.replaceAll('.', '');
      final tollValue = double.tryParse(cleanTollCost);
      if (tollValue == null || tollValue < 0) {
        errors['tollCost'] = 'Biaya tol harus berupa angka positif atau nol';
      }
    }

    if (parkingCost.isNotEmpty) {
      String cleanParkingCost = parkingCost.replaceAll('.', '');
      final parkingValue = double.tryParse(cleanParkingCost);
      if (parkingValue == null || parkingValue < 0) {
        errors['parkingCost'] =
            'Biaya parkir harus berupa angka positif atau nol';
      }
    }

    return errors;
  }
}
