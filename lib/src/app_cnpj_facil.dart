import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'services/theme_service.dart';

class AppCnpjFacil extends StatelessWidget {
  const AppCnpjFacil({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0B3D75),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4DA3FF),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'CNPJ Fácil',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          builder: (context, child) {
            return SafeArea(
              top: false,
              bottom: true,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const LoginPage(),
        );
      },
    );
  }
}
