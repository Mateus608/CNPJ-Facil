import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/cnpj_model.dart';

class PdfService {
  Future<void> compartilharCnpj(CnpjModel empresa) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blueGrey300),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'CNPJ Fácil',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text('Comprovante de consulta de CNPJ'),
                pw.Divider(),
                pw.Text(
                  empresa.nome.isEmpty ? empresa.cnpj : empresa.nome,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                _linha('CNPJ', empresa.cnpj),
                _linha('Nome fantasia', empresa.fantasia),
                _linha('Situação', empresa.situacao),
                _linha('Abertura', empresa.abertura),
                _linha('Tipo', empresa.tipo),
                _linha('Porte', empresa.porte),
                _linha('Natureza jurídica', empresa.naturezaJuridica),
                _linha('Atividade principal', empresa.atividadePrincipal),
                _linha('Capital social', empresa.capitalSocial),
                _linha('Endereço', _endereco(empresa)),
                _linha('Município/UF', '${empresa.municipio}/${empresa.uf}'),
                _linha('CEP', empresa.cep),
                _linha('E-mail', empresa.email),
                _linha('Telefone', empresa.telefone),
                _linha('Consulta', _formatarData(empresa.dataConsulta)),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'consulta_cnpj_${empresa.cnpj.replaceAll(RegExp(r'[^0-9]'), '')}.pdf',
    );
  }

  pw.Widget _linha(String titulo, String valor) {
    if (valor.trim().isEmpty || valor == '/') return pw.SizedBox.shrink();

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: '$titulo: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: valor),
          ],
        ),
      ),
    );
  }

  String _endereco(CnpjModel empresa) {
    return [
      empresa.logradouro,
      empresa.numero,
      empresa.complemento,
      empresa.bairro,
    ].where((e) => e.trim().isNotEmpty).join(', ');
  }

  String _formatarData(String data) {
    final date = DateTime.tryParse(data);
    if (date == null) return data;
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
