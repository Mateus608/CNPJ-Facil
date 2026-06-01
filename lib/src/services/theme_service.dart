import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  ThemeService._();

  static const String _themeKey = 'app_theme_mode';
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static Future<void> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeKey);
    themeMode.value = value == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> alternarTema() async {
    final novoTema = themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = novoTema;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, novoTema == ThemeMode.dark ? 'dark' : 'light');
  }
}
