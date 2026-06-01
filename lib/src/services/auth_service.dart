import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usuarioKey = 'auth_usuario';
  static const String _senhaKey = 'auth_senha';
  static const String _tutorialVistoKey = 'tutorial_visto';
  static const String _boasVindasFechadaKey = 'boas_vindas_fechada';
  static const String _boasVindasLoginCountKey = 'boas_vindas_login_count';

  Future<bool> existeUsuarioCadastrado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_usuarioKey) && prefs.containsKey(_senhaKey);
  }

  Future<bool> login(String usuario, String senha) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!await existeUsuarioCadastrado()) {
      return false;
    }

    final credenciais = await obterCredenciais();
    return usuario.trim() == credenciais.usuario && senha == credenciais.senha;
  }

  Future<AuthCredentials> obterCredenciais() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthCredentials(
      usuario: prefs.getString(_usuarioKey) ?? '',
      senha: prefs.getString(_senhaKey) ?? '',
    );
  }

  Future<void> criarPrimeiroAcesso({
    required String usuario,
    required String senha,
  }) async {
    await atualizarCredenciais(usuario: usuario, senha: senha);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialVistoKey, false);
  }


  Future<void> registrarLoginBoasVindas() async {
    final prefs = await SharedPreferences.getInstance();
    final atual = prefs.getInt(_boasVindasLoginCountKey) ?? 0;
    await prefs.setInt(_boasVindasLoginCountKey, atual + 1);
  }

  Future<bool> deveExibirBoasVindas() async {
    final prefs = await SharedPreferences.getInstance();
    final fechada = prefs.getBool(_boasVindasFechadaKey) ?? false;
    final totalLogins = prefs.getInt(_boasVindasLoginCountKey) ?? 0;

    if (fechada) return false;
    return totalLogins <= 3;
  }

  Future<void> fecharBoasVindas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_boasVindasFechadaKey, true);
  }

  Future<bool> deveExibirTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_tutorialVistoKey) ?? false);
  }

  Future<void> marcarTutorialComoVisto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialVistoKey, true);
  }

  Future<void> atualizarCredenciais({
    required String usuario,
    required String senha,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usuarioKey, usuario.trim());
    await prefs.setString(_senhaKey, senha);
  }
}

class AuthCredentials {
  final String usuario;
  final String senha;

  const AuthCredentials({required this.usuario, required this.senha});
}
