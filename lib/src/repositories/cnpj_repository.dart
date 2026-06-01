import '../models/cnpj_model.dart';
import '../services/cnpj_service.dart';
import '../services/database_service.dart';

class CnpjRepository {
  final CnpjService _cnpjService;
  final DatabaseService _databaseService;

  CnpjRepository({
    CnpjService? cnpjService,
    DatabaseService? databaseService,
  })  : _cnpjService = cnpjService ?? CnpjService(),
        _databaseService = databaseService ?? DatabaseService.instance;

  Future<CnpjModel> consultarESalvar(String cnpj) async {
    final empresa = await _cnpjService.consultarCnpj(cnpj);
    await _databaseService.salvarConsulta(empresa);
    return empresa;
  }

  Future<List<CnpjModel>> listarHistorico() {
    return _databaseService.listarHistorico();
  }

  Future<void> limparHistorico() async {
    await _databaseService.limparHistorico();
  }
}
