import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rarolabs/src/domain/usecases/login_usecase.dart';
import 'package:rarolabs/src/view/pages/login/login_viewmodel.dart';

// 1. Manual mock class creation for the ViewModel's dependency.
class MockLoginUseCase extends Mock implements LoginUseCase {}

// Mock listener to verify if `notifyListeners` was called.
class MockListener extends Mock {
  void call();
}

void main() {
  // 2. Declaration of the variables that will be used in the tests.
  late LoginViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;

  // 3. The `setUp` function is executed before each test, ensuring a clean environment.
  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    viewModel = LoginViewModel(mockLoginUseCase);
  });

  group('LoginViewModel Unit Tests', () {
    const tEmail = 'test@rarolabs.com.br';
    const tPassword = 'password';

    test('Initial state should be correct (isLoading = false)', () {
      // Assert
      expect(viewModel.isLoading, isFalse);
    });

    group('login', () {
      test(
          'Should call LoginUseCase and the onSuccess callback on success',
          () async {
        // Arrange: Configure the mock to return a successful Future.
        when(mockLoginUseCase.call(tEmail, tPassword))
            .thenAnswer((_) async {});

        bool onSuccessCalled = false;
        String? errorMessage;

        // Act: Execute the login function.
        final future = viewModel.login(
          tEmail,
          tPassword,
          onSuccess: () => onSuccessCalled = true,
          onError: (error) => errorMessage = error,
        );

        // Assert: Verify that the loading state was activated.
        expect(viewModel.isLoading, isTrue);

        // Wait for the Future to complete.
        await future;

        // Assert: Verify the final result.
        expect(viewModel.isLoading, isFalse,
            reason: 'isLoading should be false after login');
        verify(mockLoginUseCase.call(tEmail, tPassword)).called(1);
        expect(onSuccessCalled, isTrue,
            reason: 'onSuccess should have been called');
        expect(errorMessage, isNull,
            reason: 'onError should not have been called');
      });

      test('Should call LoginUseCase and the onError callback on failure',
          () async {
        // Arrange: Configure the mock to throw an exception.
        final tException = Exception('Credenciais inválidas');
        when(mockLoginUseCase.call(tEmail, tPassword)).thenThrow(tException);

        bool onSuccessCalled = false;
        String? errorMessage;

        // Act
        await viewModel.login(
          tEmail,
          tPassword,
          onSuccess: () => onSuccessCalled = true,
          onError: (error) => errorMessage = error,
        );

        // Assert
        expect(viewModel.isLoading, isFalse);
        verify(mockLoginUseCase.call(tEmail, tPassword)).called(1);
        expect(onSuccessCalled, isFalse);
        expect(errorMessage, 'Credenciais inválidas');
      });

      test('Should notify listeners when the loading state changes',
          () async {
        // Arrange
        when(mockLoginUseCase.call(tEmail, tPassword))
            .thenAnswer((_) async {});
        final listener = MockListener();
        viewModel.addListener(listener);

        // Act
        await viewModel.login(tEmail, tPassword,
            onSuccess: () {}, onError: (_) {});

        // Assert: Verify that the listener was called twice (once for true, once for false).
        verify(listener.call()).called(2);
      });
    });
  });
}
