# 📱 Kalkulator Kit

Proyek aplikasi android sederhana pakai Flutter.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

## ✨ Fitur Utama

### 🎨 Splash Screen
- Animasi fade in yang halus saat aplikasi dimulai
- Background gradien biru yang menarik (Colors.blue[600] → Colors.blue[400])
- Logo aplikasi dengan border putih tipis yang proporsional
- Nama aplikasi "Kalkulator Kit" dengan typography yang elegan
- Loading indicator dengan auto-navigation setelah 3 detik
- Native splash screen configuration untuk pengalaman startup yang optimal

### ⛽ Kalkulator BBM
- Hitung biaya bahan bakar berdasarkan jarak, efisiensi, dan harga
- Input biaya tambahan (tol, parkir)
- Format mata uang Rupiah otomatis
- Dialog hasil yang informatif

### ⚖️ Kalkulator BMI
- Pilih jenis kelamin (Pria/Wanita) dengan avatar gambar
- Input tinggi badan (cm) dan berat badan (kg)
- Validasi input (wajib dan angka)
- Hasil BMI ditampilkan dalam dialog custom beserta kategorinya
- Kategori (Bahasa Indonesia): Kekurangan Berat Badan, Normal, Kelebihan Berat Badan, Obesitas (warna sesuai kategori)

### 📱 Kalkulator Kuota
- Hitung batas penggunaan kuota harian
- Pilihan tanggal mulai fleksibel
- Date picker untuk masa tenggang
- Validasi input yang cerdas
- Input opsional "Total Beli Kuota" untuk mendapatkan "Kuota Terpakai"
- Dialog hasil akan menampilkan "Kuota Terpakai" jika input opsional diisi
- Validasi input

### ⏱️ Kalkulator Waktu
- Operasi tambah, kurang, kali, bagi untuk waktu
- Input rolling digit tanpa tanda ':' (contoh: 5 → 00:05 → 00:53 → 05:32)
- Tampilan hasil otomatis mm:ss jika jam = 0, dan HH:MM:SS jika jam > 0
- Keypad khusus dengan tombol angka, 00, dan operator

### 🎨 UI/UX Modern
- **Splash Screen**: Layar pembuka dengan animasi dan branding yang menarik
- **Material Design 3**: Desain modern dan konsisten
- **Hamburger Menu**: Navigasi yang mudah dan konsisten di semua halaman
- **Dialog Popup**: Hasil perhitungan dalam dialog yang informatif dan cantik
- **Responsive Design**: Tampilan optimal di berbagai ukuran layar
- **Smooth Animations**: Animasi yang halus dan engaging

## 🏗️ Struktur Proyek

```
lib/
├── main.dart                    # Entry point
├── pages/                       # Halaman utama
│   ├── splash_screen.dart       # Layar pembuka dengan animasi
│   ├── fuel_calculator_page.dart
│   ├── quota_calculator_page.dart
│   ├── time_calculator_page.dart
│   ├── bmi_calculator_page.dart
│   └── about_page.dart
├── widgets/                     # Komponen UI
│   ├── main_drawer.dart
│   ├── fuel_result_dialog.dart
│   ├── time_keypad.dart
│   ├── quota_result_dialog.dart
│   └── bmi_result_dialog.dart
├── services/                    # Business logic
│   ├── calculation_service.dart
│   ├── quota_calculation_service.dart
│   ├── time_calculation_service.dart
│   └── bmi_calculation_service.dart
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

### Kalkulator BMI
- **Input**: Pria, Tinggi 170 cm, Berat 65 kg
- **Output**: BMI ≈ 22.5, Kategori: Normal (warna hijau)

### Kalkulator Kuota  
- Tanpa input opsional:
   - **Input**: Sisa 10GB, masa tenggang 30 hari
   - **Output**: Batas penggunaan ~0.33GB per hari
- Dengan input opsional:
   - **Input**: Sisa 12GB, Total Beli Kuota 50GB, masa tenggang 30 hari
   - **Output**: Batas penggunaan ~0.40GB per hari, dan "Kuota Terpakai" = 38GB

### Kalkulator Waktu
- Contoh: 00:45 + 00:30 = 01:15
- Hasil 00:30 akan ditampilkan sebagai 00:30 (mm:ss), sedangkan 01:02:03 tetap HH:MM:SS

## 🧪 Testing

```bash
flutter test
```


