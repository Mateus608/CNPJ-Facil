import 'package:flutter/material.dart';
import 'src/app_cnpj_facil.dart';
import 'src/services/theme_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.carregarTema();
  runApp(const AppCnpjFacil());
}
