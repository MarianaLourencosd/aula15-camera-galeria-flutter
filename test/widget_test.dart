import 'package:flutter_test/flutter_test.dart';
import 'package:aula15_camera_galeria/main.dart';

void main() {
  testWidgets('App renderiza tela de perfil', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());
    expect(find.text('Perfil do Usuario'), findsOneWidget);
  });
}
