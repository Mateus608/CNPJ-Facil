import 'package:flutter_test/flutter_test.dart';
import 'package:cnpj_facil/src/app_cnpj_facil.dart';

void main() {
  testWidgets('App inicia com tela de login', (tester) async {
    await tester.pumpWidget(const AppCnpjFacil());
    expect(find.text('CNPJ Fácil'), findsWidgets);
  });
}
