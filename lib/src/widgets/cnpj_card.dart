import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cnpj_model.dart';
import '../services/pdf_service.dart';

class CnpjCard extends StatelessWidget {
  final CnpjModel empresa;
  final bool mostrarBotaoCompartilhar;

  const CnpjCard({
    super.key,
    required this.empresa,
    this.mostrarBotaoCompartilhar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.business),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    empresa.nome.isEmpty ? empresa.cnpj : empresa.nome,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const Divider(),
            _LinhaInfo(titulo: 'CNPJ', valor: empresa.cnpj),
            _LinhaInfo(titulo: 'Nome fantasia', valor: empresa.fantasia),
            _LinhaInfo(titulo: 'Situação', valor: empresa.situacao),
            _LinhaInfo(titulo: 'Abertura', valor: empresa.abertura),
            _LinhaInfo(titulo: 'Tipo', valor: empresa.tipo),
            _LinhaInfo(titulo: 'Porte', valor: empresa.porte),
            _LinhaInfo(titulo: 'Natureza jurídica', valor: empresa.naturezaJuridica),
            _LinhaInfo(titulo: 'Atividade principal', valor: empresa.atividadePrincipal),
            _LinhaInfo(titulo: 'Capital social', valor: empresa.capitalSocial),
            _LinhaInfo(titulo: 'Endereço', valor: _endereco),
            _LinhaInfo(titulo: 'Município/UF', valor: '${empresa.municipio}/${empresa.uf}'),
            _LinhaInfo(titulo: 'CEP', valor: empresa.cep),
            _LinhaInfo(titulo: 'E-mail', valor: empresa.email),
            _LinhaInfo(titulo: 'Telefone', valor: empresa.telefone),
            _LinhaInfo(titulo: 'Consulta', valor: _formatarData(empresa.dataConsulta)),
            if (mostrarBotaoCompartilhar) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => PdfService().compartilharCnpj(empresa),
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Compartilhar PDF'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String get _endereco {
    final partes = [
      empresa.logradouro,
      empresa.numero,
      empresa.complemento,
      empresa.bairro,
    ].where((e) => e.trim().isNotEmpty).join(', ');
    return partes;
  }

  String _formatarData(String data) {
    final date = DateTime.tryParse(data);
    if (date == null) return data;
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}

class _LinhaInfo extends StatelessWidget {
  final String titulo;
  final String valor;

  const _LinhaInfo({required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    if (valor.trim().isEmpty || valor == '/') return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$titulo: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }
}
