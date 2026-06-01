class CnpjModel {
  final int? id;
  final String cnpj;
  final String abertura;
  final String nome;
  final String fantasia;
  final String tipo;
  final String porte;
  final String naturezaJuridica;
  final String atividadePrincipal;
  final String situacao;
  final String dataSituacao;
  final String capitalSocial;
  final String logradouro;
  final String numero;
  final String complemento;
  final String bairro;
  final String municipio;
  final String uf;
  final String cep;
  final String email;
  final String telefone;
  final String dataConsulta;

  CnpjModel({
    this.id,
    required this.cnpj,
    required this.abertura,
    required this.nome,
    required this.fantasia,
    required this.tipo,
    required this.porte,
    required this.naturezaJuridica,
    required this.atividadePrincipal,
    required this.situacao,
    required this.dataSituacao,
    required this.capitalSocial,
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.municipio,
    required this.uf,
    required this.cep,
    required this.email,
    required this.telefone,
    required this.dataConsulta,
  });

  factory CnpjModel.fromReceitaWsJson(Map<String, dynamic> json) {
    final atividadePrincipal = json['atividade_principal'];
    String atividade = '';

    if (atividadePrincipal is List && atividadePrincipal.isNotEmpty) {
      final primeira = atividadePrincipal.first;
      if (primeira is Map<String, dynamic>) {
        final code = primeira['code']?.toString() ?? '';
        final text = primeira['text']?.toString() ?? '';
        atividade = code.isEmpty ? text : '$code - $text';
      }
    }

    return CnpjModel(
      cnpj: json['cnpj']?.toString() ?? '',
      abertura: json['abertura']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      fantasia: json['fantasia']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      porte: json['porte']?.toString() ?? '',
      naturezaJuridica: json['natureza_juridica']?.toString() ?? '',
      atividadePrincipal: atividade,
      situacao: json['situacao']?.toString() ?? '',
      dataSituacao: json['data_situacao']?.toString() ?? '',
      capitalSocial: json['capital_social']?.toString() ?? '',
      logradouro: json['logradouro']?.toString() ?? '',
      numero: json['numero']?.toString() ?? '',
      complemento: json['complemento']?.toString() ?? '',
      bairro: json['bairro']?.toString() ?? '',
      municipio: json['municipio']?.toString() ?? '',
      uf: json['uf']?.toString() ?? '',
      cep: json['cep']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      dataConsulta: DateTime.now().toIso8601String(),
    );
  }

  factory CnpjModel.fromMap(Map<String, dynamic> map) {
    return CnpjModel(
      id: map['id'] as int?,
      cnpj: map['cnpj']?.toString() ?? '',
      abertura: map['abertura']?.toString() ?? '',
      nome: map['nome']?.toString() ?? '',
      fantasia: map['fantasia']?.toString() ?? '',
      tipo: map['tipo']?.toString() ?? '',
      porte: map['porte']?.toString() ?? '',
      naturezaJuridica: map['natureza_juridica']?.toString() ?? '',
      atividadePrincipal: map['atividade_principal']?.toString() ?? '',
      situacao: map['situacao']?.toString() ?? '',
      dataSituacao: map['data_situacao']?.toString() ?? '',
      capitalSocial: map['capital_social']?.toString() ?? '',
      logradouro: map['logradouro']?.toString() ?? '',
      numero: map['numero']?.toString() ?? '',
      complemento: map['complemento']?.toString() ?? '',
      bairro: map['bairro']?.toString() ?? '',
      municipio: map['municipio']?.toString() ?? '',
      uf: map['uf']?.toString() ?? '',
      cep: map['cep']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      telefone: map['telefone']?.toString() ?? '',
      dataConsulta: map['data_consulta']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cnpj': cnpj,
      'abertura': abertura,
      'nome': nome,
      'fantasia': fantasia,
      'tipo': tipo,
      'porte': porte,
      'natureza_juridica': naturezaJuridica,
      'atividade_principal': atividadePrincipal,
      'situacao': situacao,
      'data_situacao': dataSituacao,
      'capital_social': capitalSocial,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'municipio': municipio,
      'uf': uf,
      'cep': cep,
      'email': email,
      'telefone': telefone,
      'data_consulta': dataConsulta,
    };
  }
}
