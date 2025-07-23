import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rarolabs/src/domain/entities/user.dart';
import 'package:rarolabs/src/domain/usecases/get_users_usecase.dart';
import 'package:rarolabs/src/domain/usecases/logout_usecase.dart';
import 'package:rarolabs/src/utils/dependencies.dart';
import 'package:rarolabs/src/view/pages/login/login_page.dart';
import 'package:rarolabs/src/view/pages/user_list/user_list_page.dart';
import 'package:rarolabs/src/view/pages/user_list/user_list_viewmodel.dart';
import 'package:rarolabs/src/view/pages/user_profile/user_profile_page.dart';
import 'package:rarolabs/src/view/widgets/error_message.dart';

// Mock classes
class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockGetUsersUseCase mockGetUsersUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  // Sample data for mocking
  final tUser1 = User(
      id: 1,
      email: 'george.bluth@reqres.in',
      firstName: 'George',
      lastName: 'Bluth',
      avatar: 'https://reqres.in/img/faces/1-image.jpg');
  final tUser2 = User(
      id: 2,
      email: 'janet.weaver@reqres.in',
      firstName: 'Janet',
      lastName: 'Weaver',
      avatar: 'https://reqres.in/img/faces/2-image.jpg');
  final tUsersPage1 = [tUser1, tUser2];

  final tUser3 = User(
      id: 3,
      email: 'emma.wong@reqres.in',
      firstName: 'Emma',
      lastName: 'Wong',
      avatar: 'https://reqres.in/img/faces/3-image.jpg');
  final tUsersPage2 = [tUser3];

  // This setup function will run before each test
  setUp(() {
    // Reset GetIt to ensure a clean state for each test
    getIt.reset();

    // Create new mock instances
    mockGetUsersUseCase = MockGetUsersUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    // Register mocks in GetIt
    getIt.registerLazySingleton<GetUsersUseCase>(() => mockGetUsersUseCase);
    getIt.registerLazySingleton<LogoutUseCase>(() => mockLogoutUseCase);

    // Register the real ViewModel which will now use the mocked use cases
    getIt.registerFactory(() => UserListViewModel(getIt(), getIt()));
  });

  // Helper to build the widget tree for testing
  Widget createTestWidget() {
    return ChangeNotifierProvider<UserListViewModel>(
      create: (_) => getIt<UserListViewModel>(),
      child: const MaterialApp(
        home: UserListPage(),
      ),
    );
  }

  group('UserListPage Integration Tests', () {
    testWidgets('should display a list of users on successful load',
        (tester) async {
      // Arrange
      when(mockGetUsersUseCase.call(page: 1))
          .thenAnswer((_) async => tUsersPage1);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Wait for loading and animations

      // Assert
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('George Bluth'), findsOneWidget);
      expect(find.text('Janet Weaver'), findsOneWidget);
      verify(mockGetUsersUseCase.call(page: 1)).called(1);
    });

    testWidgets('should display an error message when fetching users fails',
        (tester) async {
      // Arrange
      when(mockGetUsersUseCase.call(page: 1))
          .thenThrow(Exception('Failed to fetch'));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ErrorMessage), findsOneWidget);
      expect(find.text('Failed to fetch'), findsOneWidget);
      expect(find.text('Tentar Novamente'), findsOneWidget);
    });

    testWidgets('should filter users based on search input', (tester) async {
      // Arrange
      when(mockGetUsersUseCase.call(page: 1))
          .thenAnswer((_) async => tUsersPage1);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField), 'Janet');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('George Bluth'), findsNothing);
      expect(find.text('Janet Weaver'), findsOneWidget);
    });

    testWidgets('should load the next page when scrolling to the bottom',
        (tester) async {
      // Arrange
      when(mockGetUsersUseCase.call(page: 1))
          .thenAnswer((_) async => tUsersPage1);
      when(mockGetUsersUseCase.call(page: 2))
          .thenAnswer((_) async => tUsersPage2);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert initial state
      expect(find.text('George Bluth'), findsOneWidget);
      expect(find.text('Emma Wong'), findsNothing);

      // Act
      await tester.drag(
          find.byType(ListView), const Offset(0, -500)); // Scroll down
      await tester.pump(); // Show loading indicator at the bottom

      // Assert loading indicator is visible at the bottom
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(); // Wait for new items to load

      // Assert
      expect(find.text('Emma Wong'), findsOneWidget); // New user is visible
      verify(mockGetUsersUseCase.call(page: 2)).called(1);
    });

    testWidgets('should navigate to UserProfilePage on user tap',
        (tester) async {
      // Arrange
      when(mockGetUsersUseCase.call(page: 1))
          .thenAnswer((_) async => tUsersPage1);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('George Bluth'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(UserProfilePage), findsOneWidget);
      expect(find.byType(UserListPage), findsNothing);
    });

    testWidgets('should navigate to LoginPage on logout', (tester) async {
      // Arrange
      when(mockGetUsersUseCase.call(page: 1))
          .thenAnswer((_) async => tUsersPage1);
      when(mockLogoutUseCase.call()).thenAnswer((_) async {});
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Assert
      verify(mockLogoutUseCase.call()).called(1);
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(UserListPage), findsNothing);
    });
  });
}
