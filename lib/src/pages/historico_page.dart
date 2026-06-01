import 'package:flutter/material.dart';

import '../models/cnpj_model.dart';
import '../repositories/cnpj_repository.dart';
import '../widgets/cnpj_card.dart';
import '../widgets/theme_toggle_button.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final _repository = CnpjRepository();
  late Future<List<CnpjModel>> _futureHistorico;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  void _carregarHistorico() {
    _futureHistorico = _repository.listarHistorico();
  }

  Future<void> _limparHistorico() async {
    await _repository.limparHistorico();
    if (!mounted) return;
    setState(_carregarHistorico);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Histórico limpo.')),
    );
  }

  Future<void> _confirmarLimpeza() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar histórico'),
        content: const Text('Deseja remover todas as consultas salvas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _limparHistorico();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Consultas'),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            tooltip: 'Limpar histórico',
            onPressed: _confirmarLimpeza,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: FutureBuilder<List<CnpjModel>>(
        future: _futureHistorico,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final historico = snapshot.data ?? [];

          if (historico.isEmpty) {
            return const Center(
              child: Text('Nenhuma consulta encontrada.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historico.length,
            itemBuilder: (context, index) {
              return CnpjCard(empresa: historico[index]);
            },
          );
        },
      ),
    );
  }
}
