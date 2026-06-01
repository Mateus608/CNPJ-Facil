import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cnpj_model.dart';
import '../repositories/cnpj_repository.dart';
import '../services/auth_service.dart';
import '../widgets/cnpj_card.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/theme_toggle_button.dart';
import 'configuracoes_usuario_page.dart';
import 'historico_page.dart';
import 'login_page.dart';

class ConsultaCnpjPage extends StatefulWidget {
  final bool exibirTutorialInicial;

  const ConsultaCnpjPage({super.key, this.exibirTutorialInicial = false});

  @override
  State<ConsultaCnpjPage> createState() => _ConsultaCnpjPageState();
}

class _ConsultaCnpjPageState extends State<ConsultaCnpjPage> {
  final _formKey = GlobalKey<FormState>();
  final _cnpjController = TextEditingController();
  final _repository = CnpjRepository();
  final _authService = AuthService();
  CnpjModel? _empresa;
  bool _carregando = false;
  bool _exibirBoasVindas = false;
  String _usuario = '';

  @override
  void initState() {
    super.initState();
    _carregarUsuarioEExibirTutorial();
  }

  Future<void> _carregarUsuarioEExibirTutorial() async {
    final credenciais = await _authService.obterCredenciais();
    final deveExibirBoasVindas = await _authService.deveExibirBoasVindas();
    if (!mounted) return;
    setState(() {
      _usuario = credenciais.usuario;
      _exibirBoasVindas = deveExibirBoasVindas;
    });

    if (widget.exibirTutorialInicial && await _authService.deveExibirTutorial()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _exibirTutorialInicial());
    }
  }

  Future<void> _exibirTutorialInicial() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bem-vindo ao CNPJ Fácil!'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Veja como utilizar o app:'),
              SizedBox(height: 12),
              Text('1. Digite o CNPJ no campo de consulta.'),
              SizedBox(height: 8),
              Text('2. Toque em Consultar para buscar os dados da empresa.'),
              SizedBox(height: 8),
              Text('3. A consulta será salva automaticamente no histórico.'),
              SizedBox(height: 8),
              Text('4. Compartilhe o card em PDF quando precisar.'),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Começar'),
            ),
          ],
        );
      },
    );

    await _authService.marcarTutorialComoVisto();
  }

  @override
  void dispose() {
    _cnpjController.dispose();
    super.dispose();
  }

  Future<void> _consultarCnpj() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
      _empresa = null;
    });

    try {
      final empresa = await _repository.consultarESalvar(_cnpjController.text);
      if (!mounted) return;
      setState(() => _empresa = empresa);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consulta salva no histórico.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _abrirHistorico() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HistoricoPage()),
    );
  }

  void _abrirConfiguracoes() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ConfiguracoesUsuarioPage()),
    );
  }

  Future<void> _sair() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar saída'),
          content: const Text('Deseja realmente sair do CNPJ Fácil?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  String? _validarCnpj(String? value) {
    final cnpj = value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
    if (cnpj.isEmpty) return 'Informe o CNPJ';
    if (cnpj.length != 14) return 'O CNPJ precisa ter 14 números';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar CNPJ'),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            tooltip: 'Histórico',
            onPressed: _abrirHistorico,
            icon: const Icon(Icons.history),
          ),
          IconButton(
            tooltip: 'Alterar usuário e senha',
            onPressed: _abrirConfiguracoes,
            icon: const Icon(Icons.manage_accounts_outlined),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: _sair,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_exibirBoasVindas) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.waving_hand_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                _usuario.isEmpty
                                    ? 'Bem-vindo ao CNPJ Fácil!'
                                    : 'Bem-vindo, $_usuario! Consulte CNPJs de forma rápida e prática.',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          Material(
                            color: Theme.of(context).colorScheme.surface,
                            shape: const CircleBorder(),
                            elevation: 1,
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                tooltip: 'Fechar mensagem',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 30,
                                  minHeight: 30,
                                ),
                                visualDensity: VisualDensity.compact,
                                onPressed: () async {
                                  await _authService.fecharBoasVindas();
                                  if (!mounted) return;
                                  setState(() => _exibirBoasVindas = false);
                                },
                                icon: const Icon(Icons.close, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Informe o CNPJ da empresa',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _cnpjController,
                            label: 'CNPJ',
                            icon: Icons.business,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CnpjInputFormatter(),
                            ],
                            validator: _validarCnpj,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _carregando ? null : _consultarCnpj,
                            icon: _carregando
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.search),
                            label: Text(_carregando ? 'Consultando...' : 'Consultar'),
                          ),
                          const SizedBox(height: 8),
                          const Text('Consulte até 3 CNPJs por minuto no plano gratuito!'),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_empresa != null) ...[
                  const SizedBox(height: 16),
                  CnpjCard(empresa: _empresa!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length && i < 14; i++) {
      if (i == 2 || i == 5) buffer.write('.');
      if (i == 8) buffer.write('/');
      if (i == 12) buffer.write('-');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
