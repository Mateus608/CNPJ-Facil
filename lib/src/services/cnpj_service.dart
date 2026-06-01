import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/cnpj_model.dart';

class CnpjService {
  Future<CnpjModel> consultarCnpj(String cnpj) async {
    final cnpjLimpo = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    if (!_cnpjValido(cnpjLimpo)) {
      throw Exception('Informe um CNPJ válido com 14 números.');
    }

    final url = Uri.https(
      ApiConfig.baseUrl,
      '${ApiConfig.endpointCnpj}/$cnpjLimpo',
    );

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Resposta inválida da API.');
    }

    if (response.statusCode == 429) {
      throw Exception('Limite de consultas excedido. Aguarde e tente novamente.');
    }

    if (response.statusCode != 200 || body['status'] == 'ERROR') {
      throw Exception(body['message']?.toString() ?? 'Erro ao consultar CNPJ.');
    }

    return CnpjModel.fromReceitaWsJson(body);
  }

  bool _cnpjValido(String cnpj) {
    if (cnpj.length != 14) return false;
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) return false;

    int calcularDigito(String base, List<int> pesos) {
      var soma = 0;
      for (var i = 0; i < base.length; i++) {
        soma += int.parse(base[i]) * pesos[i];
      }
      final resto = soma % 11;
      return resto < 2 ? 0 : 11 - resto;
    }

    final primeiro = calcularDigito(cnpj.substring(0, 12), [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);
    final segundo = calcularDigito(cnpj.substring(0, 13), [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);

    return cnpj.endsWith('$primeiro$segundo');
  }
}
