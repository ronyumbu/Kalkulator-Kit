# 📱 KALKULATOR KIT

Aplikasi Flutter yang menyediakan koleksi kalkulator praktis untuk kebutuhan sehari-hari dengan antarmuka yang modern dan user-friendly.

## 📋 DESKRIPSI APLIKASI

Kalkulator Kit adalah aplikasi mobile yang menyediakan kalkulator-kalkulator utama berikut:
1. **Kalkulator BBM** - Menghitung biaya bahan bakar perjalanan
2. **Kalkulator Kuota** - Menghitung batas penggunaan kuota harian
3. **Kalkulator Waktu** - Operasi waktu (tambah, kurang, kali, bagi)
4. **Kalkulator BMI** - Menghitung indeks massa tubuh dan kategorinya

Aplikasi ini dirancang dengan Material Design 3, hamburger menu yang konsisten, dan dialog hasil yang informatif.

## ✨ FITUR UTAMA

### ⛽ Kalkulator BBM
- **Input Lengkap**: Jarak, efisiensi, harga BBM, tol, parkir
- **Format Otomatis**: Angka dengan pemisah ribuan
- **Hasil Detail**: Total biaya, biaya per km, breakdown lengkap
- **Dialog Cantik**: Hasil dalam popup dengan header bergradient

### ⚖️ Kalkulator BMI
- **Input**: Jenis kelamin (Pria/Wanita), Tinggi (cm), Berat (kg)
- **Validasi**: Wajib diisi dan angka
- **Hasil**: Nilai BMI dan kategori (Underweight, Normal, Overweight, Obese)
- **Dialog**: Popup hasil dengan warna sesuai kategori

### 📱 Kalkulator Kuota
### ⏱️ Kalkulator Waktu
- **Operasi**: +, −, ×, ÷
- **Input**: Rolling digit tanpa ':' (contoh 5 → 00:05 → 00:53 → 05:32)
- **Tampilan Hasil**: Otomatis mm:ss ketika jam = 0, HH:MM:SS ketika jam > 0
- **Keypad**: Tombol angka, 00, dan operator khusus
- **Tanggal Fleksibel**: Pilih tanggal mulai atau gunakan hari ini
- **Input Kuota**: Sisa kuota dalam GB dengan validasi
- **Masa Tenggang**: Pilih tanggal expired dengan kalender
- **Batas Harian**: Hitung berapa GB yang boleh dipakai per hari
- **Total Beli Kuota (Opsional)**: Jika diisi, aplikasi menampilkan "Kuota Terpakai" = Total − Sisa

### 🎨 UI/UX Modern
- **Hamburger Menu**: Navigasi konsisten di semua halaman
- **Material Design 3**: Desain modern dan profesional
- **Dialog Cantik**: Popup hasil dengan ikon dan gradient
- **Responsive**: Tampilan optimal di berbagai ukuran layar

## 🛠️ TEKNOLOGI

### 🎨 Framework & Platform
- **Flutter 3.24+**: Cross-platform development
- **Material Design 3**: Modern UI/UX design
- **Multi-platform**: Android, iOS, Web, Desktop
- **Dart 3.9+**: Type-safe programming language

### ✨ Fitur Unggulan
- **Format Mata Uang**: Rupiah dengan pemisah ribuan
- **Validasi Pintar**: Error handling yang informatif
- **Dialog Custom**: Popup hasil yang cantik dan informatif
- **Hamburger Menu**: Navigasi konsisten di semua halaman
- **Date Picker**: Kalender untuk memilih tanggal

## 📱 STRUKTUR APLIKASI

### 🏗️ Arsitektur
```
lib/
├── main.dart                    # Entry point
├── pages/                       # Halaman utama
│   ├── fuel_calculator_page.dart
│   ├── quota_calculator_page.dart
│   ├── time_calculator_page.dart
│   ├── bmi_calculator_page.dart
│   └── about_page.dart
├── widgets/                     # Komponen UI
│   ├── main_drawer.dart
│   ├── fuel_result_dialog.dart
│   ├── quota_result_dialog.dart
│   ├── bmi_result_dialog.dart
│   └── time_keypad.dart
├── services/                    # Business logic
│   ├── calculation_service.dart
│   ├── quota_calculation_service.dart
│   ├── time_calculation_service.dart
│   └── bmi_calculation_service.dart
└── utils/                       # Utilities
    └── currency_formatter.dart
```

### 🎯 Komponen Utama
- **MainDrawer**: Hamburger menu dengan navigasi konsisten
- **ResultDialogs**: Dialog popup hasil perhitungan yang cantik
- **CalculationServices**: Logika perhitungan dan validasi
- **CurrencyFormatter**: Format mata uang Rupiah

## 🧭 CARA PENGGUNAAN

### ⚖️ Kalkulator BMI
1. Pilih jenis kelamin: Pria atau Wanita
2. Masukkan Tinggi (cm) dan Berat (kg)
3. Tekan tombol "Hitung BMI"
4. Lihat nilai BMI, kategori, dan warna indikator pada dialog

### ⛽ Kalkulator BBM
1. **Input wajib**: Jarak (km), efisiensi (km/L), harga BBM
2. **Input opsional**: Biaya tol dan parkir
3. **Hitung**: Klik tombol untuk melihat hasil
4. **Hasil**: Dialog menampilkan total biaya dan breakdown

### 📱 Kalkulator Kuota
1. **Tanggal mulai**: Gunakan hari ini atau pilih manual
2. **Sisa kuota**: Masukkan dalam GB
3. **Total Beli Kuota (Opsional)**: Masukkan total kuota yang dibeli (GB)
4. **Masa tenggang**: Pilih tanggal expired
5. **Hasil**: Lihat batas penggunaan harian; jika langkah 3 diisi, dialog juga menampilkan "Kuota Terpakai"

## 🚀 PLATFORM SUPPORT
- ✅ **Android**: APK ready
- ✅ **iOS**: iPhone & iPad
- ✅ **Web**: PWA support
- ✅ **Desktop**: Windows, macOS, Linux

## 💡 TIPS PENGGUNAAN

### Untuk Hasil Akurat:
- **Efisiensi Real**: Gunakan konsumsi BBM berdasarkan pengalaman
- **Harga Terkini**: Update harga BBM terbaru di SPBU
- **Tanggal Tepat**: Pilih tanggal mulai sesuai kebutuhan

### Fitur Unggulan:
- **Auto Format**: Angka diformat otomatis saat mengetik
- **Hamburger Menu**: Navigasi mudah antar kalkulator
- **Dialog Cantik**: Hasil perhitungan dalam popup yang informatif

## 🛠️ DEVELOPMENT

### Build Commands:
```bash
# Install dependencies
flutter pub get

# Run aplikasi
flutter run

# Build APK
flutter build apk --release
```

---

**Dibuat dengan ❤️ menggunakan Flutter**
*Aplikasi praktis untuk kebutuhan perhitungan sehari-hari*

---

**Dikembangkan dengan ❤️ menggunakan Flutter**

*Aplikasi ini dirancang untuk membantu pengguna menghitung biaya perjalanan dan kuota dengan akurat dan efisien.*