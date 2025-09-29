import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calculate,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kalkulator Kit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Koleksi kalkulator praktis',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calculate, color: Colors.blue),
            title: const Text(
              'Kalkulator',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Kalkulator dasar angka'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/calculator');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_gas_station, color: Colors.orange),
            title: const Text(
              'Kalkulator BBM',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Hitung biaya bahan bakar'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/fuel');
            },
          ),
          ListTile(
            leading: const Icon(Icons.monitor_weight, color: Colors.teal),
            title: const Text(
              'Kalkulator BMI',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Hitung indeks massa tubuh'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/bmi');
            },
          ),
          ListTile(
            leading: const Icon(Icons.sim_card, color: Colors.green),
            title: const Text(
              'Kalkulator Kuota',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Hitung batas kuota harian'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/quota');
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time, color: Colors.purple),
            title: const Text(
              'Kalkulator Waktu',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Operasi HH:MM'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/time');
            },
          ),
          ListTile(
            leading: const Icon(Icons.date_range, color: Colors.indigo),
            title: const Text(
              'Kalkulator Tanggal',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Perhitungan tanggal dan hari'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/date');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text(
              'Pengaturan',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Tema dan pengaturan umum'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.orange),
            title: const Text(
              'Tentang Aplikasi',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Informasi aplikasi'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/about');
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Versi 1.0.0',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
