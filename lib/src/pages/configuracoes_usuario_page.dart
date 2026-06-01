import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/theme_toggle_button.dart';

class ConfiguracoesUsuarioPage extends StatefulWidget {
  const ConfiguracoesUsuarioPage({super.key});

  @override
  State<ConfiguracoesUsuarioPage> createState() => _ConfiguracoesUsuarioPageState();
}

class _ConfiguracoesUsuarioPageState extends State<ConfiguracoesUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = true;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _carregarCredenciais();
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _carregarCredenciais() async {
    final credenciais = await _authService.obterCredenciais();
    if (!mounted) return;
    _usuarioController.text = credenciais.usuario;
    _senhaController.text = credenciais.senha;
    _confirmarSenhaController.text = credenciais.senha;
    setState(() => _carregando = false);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar alterações'),
          content: const Text('Deseja realmente salvar o novo usuário e senha?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    setState(() => _salvando = true);

    await _authService.atualizarCredenciais(
      usuario: _usuarioController.text,
      senha: _senhaController.text,
    );

    if (!mounted) return;
    setState(() => _salvando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário e senha atualizados com sucesso.')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar usuário e senha'),
        actions: const [ThemeToggleButton()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Defina as credenciais de acesso ao app',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
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
                              label: 'Nova senha',
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
                                if (value != _senhaController.text) {
                                  return 'As senhas não conferem';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              onPressed: _salvando ? null : _salvar,
                              icon: _salvando
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.save_outlined),
                              label: Text(_salvando ? 'Salvando...' : 'Salvar alterações'),
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
