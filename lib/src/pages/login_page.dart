import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/theme_toggle_button.dart';
import 'cadastro_usuario_page.dart';
import 'consulta_cnpj_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;
  bool _verificandoPrimeiroAcesso = true;
  bool _primeiroAcesso = false;

  @override
  void initState() {
    super.initState();
    _verificarPrimeiroAcesso();
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _verificarPrimeiroAcesso() async {
    final existeUsuario = await _authService.existeUsuarioCadastrado();
    if (!mounted) return;
    setState(() {
      _primeiroAcesso = !existeUsuario;
      _verificandoPrimeiroAcesso = false;
    });
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final sucesso = await _authService.login(
      _usuarioController.text,
      _senhaController.text,
    );

    if (!mounted) return;
    setState(() => _carregando = false);

    if (sucesso) {
      await _authService.registrarLoginBoasVindas();
      final exibirTutorial = await _authService.deveExibirTutorial();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ConsultaCnpjPage(
            exibirTutorialInicial: exibirTutorial,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário ou senha inválidos.')),
      );
    }
  }

  void _abrirCadastro() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CadastroUsuarioPage()),
    ).then((_) => _verificarPrimeiroAcesso());
  }

  @override
  Widget build(BuildContext context) {
    if (_verificandoPrimeiroAcesso) {
      return const Scaffold(
        body: SafeArea(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: _primeiroAcesso ? _buildPrimeiroAcesso(context) : _buildLogin(context),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: ThemeToggleButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeMode,
      builder: (context, mode, _) {
        final logo = Image.asset(
          'assets/images/logo_cnpj_facil.png',
          height: 160,
          fit: BoxFit.contain,
        );

        if (mode != ThemeMode.dark) return logo;

        return Container(
          width: 172,
          height: 172,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: logo,
        );
      },
    );
  }

  Widget _buildPrimeiroAcesso(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLogo(),
        const SizedBox(height: 24),
        Text(
          'Cadastre-se para acessar o CNPJ Fácil.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _abrirCadastro,
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Cadastre-se'),
        ),
      ],
    );
  }

  Widget _buildLogin(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLogo(),
          const SizedBox(height: 16),
          Text(
            'Consulta rápida de empresas',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _usuarioController,
            label: 'Usuário',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Informe o usuário';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _senhaController,
            label: 'Senha',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Informe a senha';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _carregando ? null : _entrar,
            icon: _carregando
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.login),
            label: Text(_carregando ? 'Entrando...' : 'Entrar'),
          ),
        ],
      ),
    );
  }
}
