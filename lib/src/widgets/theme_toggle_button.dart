import 'package:flutter/material.dart';

import '../services/theme_service.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          tooltip: isDark ? 'Usar tema claro' : 'Usar tema escuro',
          onPressed: ThemeService.alternarTema,
          icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
        );
      },
    );
  }
}
