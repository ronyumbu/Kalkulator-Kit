import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

extension SettingsExtension on BuildContext {
  SettingsService get settings => read<SettingsService>();
  SettingsService get watchSettings => watch<SettingsService>();
}
