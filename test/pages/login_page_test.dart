import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rarolabs/src/view/pages/home/home_page.dart';
import 'package:rarolabs/src/view/pages/login/login_page.dart';
import 'package:rarolabs/src/view/pages/login/login_viewmodel.dart';

// Criação manual da classe de Mock.
// Esta classe herda de `Mock` (do pacote mockito) para ter os comportamentos de mock (when, verify, etc.)
// e implementa `LoginViewModel` para ter o mesmo "contrato" (métodos e propriedades) da classe original.
class MockLoginViewModel extends Mock implements LoginViewModel {}

void main() {
  // Declaração do ViewModel mockado que será usado em todos os testes.
  late MockLoginViewModel mockLoginViewModel;

  // Função auxiliar para criar a árvore de widgets para os testes.
  // Envolve a LoginPage com MaterialApp (para navegação e temas) e
  // ChangeNotifierProvider (para injetar o ViewModel mockado).
  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: mockLoginViewModel,
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  // A função setUp é executada antes de cada teste no grupo.
  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    // Configuração padrão para o mock: por padrão, `isLoading` é falso.
    // Isso evita que o teste falhe por um valor nulo.
    when(mockLoginViewModel.isLoading).thenReturn(false);
  });

  group('LoginPage Widget Tests', () {
    testWidgets('Deve exibir os elementos da UI inicial corretamente',
        (WidgetTester tester) async {
      // Arrange: Constrói o widget.
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert: Verifica se todos os componentes iniciais estão na tela.
      expect(find.text('Bem-vindo!'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'E-mail'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Senha'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'ENTRAR'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Deve exibir erros de validação para campos vazios',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act: Toca no botão de login sem preencher os campos.
      await tester.tap(find.widgetWithText(ElevatedButton, 'ENTRAR'));
      await tester
          .pump(); // Reconstrói o widget para exibir as mensagens de erro.

      // Assert: Verifica se as mensagens de validação apareceram.
      expect(find.text('Por favor, insira o e-mail'), findsOneWidget);
      expect(find.text('Por favor, insira a senha'), findsOneWidget);
    });

    testWidgets('Deve exibir o indicador de carregamento durante o login',
        (WidgetTester tester) async {
      // Arrange: Configura o mock para simular o estado de carregamento.
      when(mockLoginViewModel.isLoading).thenReturn(true);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert: Verifica se o CircularProgressIndicator está visível e o botão não.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'ENTRAR'), findsNothing);
    });

    testWidgets(
        'Deve chamar o login e navegar para HomePage em caso de sucesso',
        (WidgetTester tester) async {
      // Arrange: Configura o mock para chamar o callback de sucesso.
      when(mockLoginViewModel.login(
        'test@test.com',
        'password',
        onSuccess: () => anyNamed('onSuccess'),
        onError: (_) => anyNamed('onError'),
      )).thenAnswer((realInvocation) async {
        // Captura e executa o callback `onSuccess` passado para a função de login.
        final onSuccess = realInvocation
            .namedArguments[const Symbol('onSuccess')] as Function();
        onSuccess();
      });

      await tester.pumpWidget(createWidgetUnderTest());

      // Act: Simula a entrada de texto e o toque no botão.
      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), 'test@test.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'), 'password');
      await tester.tap(find.widgetWithText(ElevatedButton, 'ENTRAR'));
      await tester.pumpAndSettle(); // Espera a transição de navegação terminar.

      // Assert: Verifica se a função de login foi chamada e se a navegação ocorreu.
      verify(mockLoginViewModel.login(
        'test@test.com',
        'password',
        onSuccess: () => anyNamed('onSuccess'),
        onError: (_) => anyNamed('onError'),
      )).called(1);

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });

    testWidgets('Deve exibir uma SnackBar em caso de erro no login',
        (WidgetTester tester) async {
      // Arrange: Configura o mock para chamar o callback de erro.
      const errorMessage = 'Credenciais inválidas';
      when(mockLoginViewModel.login('test@test.com', 'password',
              onSuccess: () => anyNamed('onSuccess'),
              onError: (_) => anyNamed('onError')))
          .thenAnswer((realInvocation) async {
        // Captura e executa o callback `onError` com uma mensagem de erro.
        final onError = realInvocation.namedArguments[const Symbol('onError')]
            as Function(String);
        onError(errorMessage);
      });

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), 'test@test.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'), 'wrongpassword');
      await tester.tap(find.widgetWithText(ElevatedButton, 'ENTRAR'));
      await tester
          .pump(); // pump() é suficiente para o ScaffoldMessenger exibir a SnackBar.

      // Assert: Verifica se a função de login foi chamada e se a SnackBar é exibida.
      verify(mockLoginViewModel.login(
        'test@test.com',
        'wrongpassword',
        onSuccess: () => anyNamed('onSuccess'),
        onError: (_) => anyNamed('onError'),
      )).called(1);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
