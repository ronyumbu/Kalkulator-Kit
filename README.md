# 📱 Kalkulator Kit

Proyek aplikasi android sederhana pakai Flutter.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

## ✨ Fitur Utama

### ⛽ Kalkulator BBM
- Hitung biaya bahan bakar berdasarkan jarak, efisiensi, dan harga
- Input biaya tambahan (tol, parkir)
- Format mata uang Rupiah otomatis
- Dialog hasil yang informatif

### 📱 Kalkulator Kuota
- Hitung batas penggunaan kuota harian
- Pilihan tanggal mulai fleksibel
- Date picker untuk masa tenggang
<<<<<<< HEAD
- Validasi input yang cerdas
- Input opsional "Total Beli Kuota" untuk mendapatkan "Kuota Terpakai"
- Dialog hasil akan menampilkan "Kuota Terpakai" jika input opsional diisi

- Validasi input

### 🎨 UI/UX Modern
- Material Design 3
- Hamburger menu konsisten
- Dialog popup
- Dialog popup yang ok
- Responsive design

## 🏗️ Struktur Proyek

```
lib/
├── main.dart                    # Entry point
├── pages/                       # Halaman utama
│   ├── fuel_calculator_page.dart
│   ├── quota_calculator_page.dart
│   └── about_page.dart
├── widgets/                     # Komponen UI
│   ├── main_drawer.dart
│   ├── fuel_result_dialog.dart
│   └── quota_result_dialog.dart
├── services/                    # Business logic
│   ├── calculation_service.dart
│   └── quota_calculation_service.dart
└── utils/                       # Utilities
    └── currency_formatter.dart
```

## 🚀 Quick Start

### Yang saya gunakan
- Flutter SDK 3.35.3
- Dart SDK 3.9.2

### Instalasi

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

3. **Build APK**
   ```bash
   flutter build apk --release
   ```

## 📱 Platform pada pengujian ini

- ✅ **Android**

## 🎯 Usage Example

### Kalkulator BBM
- **Input**: Jarak 100km, efisiensi 12km/L, harga Rp15.000/L
- **Output**: Total biaya, biaya per km, breakdown detail

### Kalkulator Kuota  
- Tanpa input opsional:
   - **Input**: Sisa 10GB, masa tenggang 30 hari
   - **Output**: Batas penggunaan ~0.33GB per hari
- Dengan input opsional:
   - **Input**: Sisa 12GB, Total Beli Kuota 50GB, masa tenggang 30 hari
   - **Output**: Batas penggunaan ~0.40GB per hari, dan "Kuota Terpakai" = 38GB

## 🧪 Testing

```bash
flutter test
```


