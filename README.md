# 📱 Kalkulator Kit

Proyek aplikasi android sederhana pakai Flutter.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

## ✨ Fitur Utama

### 🧮 Kalkulator Basic (Halaman Default)
- Operasi matematika dasar: tambah (+), kurang (-), kali (×), bagi (÷)
- Fitur lanjutan: toggle tanda (+/-), persentase (%), titik desimal (.)
- Kontrol lengkap: Clear (C), delete (⌫), equals (=)
- Layout profesional dalam grid 4x5 dengan card yang rapi
- Format angka otomatis dengan pemisah ribuan
- Area display kompak dengan preview operasi sebelumnya
- Error handling untuk pembagian dengan nol
- UI responsif tanpa scrolling, semua tombol terlihat

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
- Format dual result: menampilkan hasil 24+ jam dan jam standar (25:50 dan 01:50)
- Format HH:MM: tampilan waktu tanpa detik untuk kemudahan baca
- Keypad khusus dengan tombol angka, 00, dan operator

### 📅 Kalkulator Tanggal
- **Dua Mode Perhitungan**: Selisih antara dua tanggal atau tambah/kurang hari
- **Mode Selisih Tanggal**: Hitung jumlah hari antara tanggal awal dan akhir
- **Mode Tambah/Kurang Hari**: Tambah atau kurangi hari dari tanggal tertentu
- **Calendar Picker**: Pilih tanggal dengan kalender yang mudah digunakan
- **Stepper Input**: Input jumlah hari dengan tombol +/- atau manual
- **Validasi Range**: Validasi tanggal dari tahun 1900-2100
- **Hasil Detail**: Dialog menampilkan tanggal lengkap dengan nama hari

### 🎂 Kalkulator Usia
- **Hitung Usia Detail**: Dari tanggal lahir hingga sekarang dalam format lengkap
- **Date Picker**: Pilih tanggal lahir dengan kalender (mendukung hingga 150 tahun lalu)
- **Format Lengkap**: Tampilkan usia dalam "X tahun, Y bulan, Z hari"
- **Perhitungan Total**: Menampilkan total dalam berbagai format:
  - Total tahun, bulan, minggu, hari
  - Total jam, menit, dan detik hidup
- **Format Angka**: Pemisah ribuan otomatis (1.234.567)
- **Validasi**: Tanggal lahir tidak boleh di masa depan

### 🎨 UI/UX Modern
- **Material Design 3**: Desain modern dan konsisten
- **Dark Mode Support**: Mode gelap otomatis mengikuti pengaturan sistem
- **Hamburger Menu**: Navigasi yang mudah dan konsisten di semua halaman
- **Dialog Popup**: Hasil perhitungan dalam dialog yang informatif

## 🏗️ Struktur Proyek

```
lib/
├── main.dart                    # Entry point
├── pages/                       # Halaman utama
│   ├── splash_screen.dart       # Layar pembuka dengan animasi
│   ├── basic_calculator_page.dart # Kalkulator basic (halaman default)
│   ├── fuel_calculator_page.dart
│   ├── quota_calculator_page.dart
│   ├── time_calculator_page.dart
│   ├── date_calculator_page.dart
│   ├── age_calculator_page.dart # Kalkulator usia (baru!)
│   ├── bmi_calculator_page.dart
│   ├── settings_page.dart       # Pengaturan tema
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
│   ├── date_calculation_service.dart
│   ├── age_calculation_service.dart # Service untuk kalkulator usia (baru!)
│   ├── bmi_calculation_service.dart
│   └── settings_service.dart    # Service pengaturan tema
└── utils/                       # Utilities
    └── currency_formatter.dart
```

## 🚀 Quick Start

### Yang saya gunakan
- Flutter SDK 3.24+
- Dart SDK 3.9+

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

## 🧪 Testing

```bash
flutter test
```


