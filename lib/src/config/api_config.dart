class ApiConfig {
  static const String baseUrl = 'receitaws.com.br';
  static const String endpointCnpj = '/v1/cnpj';

  // API pública da ReceitaWS não exige autenticação.
  // Limite informado pela ReceitaWS: 3 consultas por minuto.
}
