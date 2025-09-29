import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';
import '../widgets/section_title.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Consumer<SettingsService>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              // Tema Aplikasi Section
              const SectionTitle(title: 'Tema Aplikasi'),

              // Theme Mode Selection
              ListTile(
                leading: Icon(
                  Icons.palette_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Mode Tema'),
                subtitle: Text(_getThemeModeDescription(settings.themeMode)),
                trailing: DropdownButton<String>(
                  value: settings.themeMode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'light', child: Text('Terang')),
                    DropdownMenuItem(value: 'dark', child: Text('Gelap')),
                    DropdownMenuItem(value: 'auto', child: Text('Otomatis')),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      settings.setThemeMode(value);
                      _showSnackBar('Tema berhasil diubah');
                    }
                  },
                ),
              ),

              // Reset to Defaults (Optional)
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Pengaturan'),
                        content: const Text(
                          'Apakah Anda yakin ingin mengembalikan semua pengaturan ke default?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Batal'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await settings.resetToDefaults();
                      if (mounted) {
                        _showSnackBar('Pengaturan berhasil direset ke default');
                      }
                    }
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text('Reset ke Default'),
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  String _getThemeModeDescription(String mode) {
    switch (mode) {
      case 'light':
        return 'Selalu gunakan tema terang';
      case 'dark':
        return 'Selalu gunakan tema gelap';
      case 'auto':
      default:
        return 'Ikuti pengaturan sistem';
    }
  }
}
