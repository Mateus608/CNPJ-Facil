import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import 'login_page.dart';

class CadastroUsuarioPage extends StatefulWidget {
  const CadastroUsuarioPage({super.key});

  @override
  State<CadastroUsuarioPage> createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _authService = AuthService();
  bool _salvando = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    await _authService.criarPrimeiroAcesso(
      usuario: _usuarioController.text,
      senha: _senhaController.text,
    );

    if (!mounted) return;
    setState(() => _salvando = false);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cadastro realizado'),
        content: const Text(
          'Cadastro realizado com sucesso! Faça login e inicie suas consultas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de acesso')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Crie seu usuário e senha',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
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
                          if (value.trim().length < 4) {
                            return 'A senha precisa ter pelo menos 4 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _confirmarSenhaController,
                        label: 'Confirmar senha',
                        icon: Icons.lock_reset,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Confirme a senha';
                          }
                          if (value != _senhaController.text) {
                            return 'As senhas não conferem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _salvando ? null : _cadastrar,
                        icon: _salvando
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.person_add_alt_1),
                        label: Text(_salvando ? 'Cadastrando...' : 'Cadastrar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
