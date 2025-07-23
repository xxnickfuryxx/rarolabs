import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:rarolabs/src/domain/entities/user.dart';
import 'package:rarolabs/src/view/pages/user_profile/user_profile_page.dart';
import 'package:rarolabs/src/view/pages/user_profile/user_profile_viewmodel.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Define a sample user to be used in the test
  final tUser = User(
    id: 1,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/7-image.jpg',
  );

  // Helper to build the widget tree for testing
  Widget createTestWidget(User user) {
    return ChangeNotifierProvider(
      create: (_) => UserProfileViewModel(),
      child: MaterialApp(
        home: UserProfilePage(user: user),
      ),
    );
  }

  group('UserProfilePage Integration Tests', () {
    testWidgets('should display user data and generated profile info correctly',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(tUser));
      // pumpAndSettle waits for all animations and frame requests to complete,
      // including the fake data generation in initState.
      await tester.pumpAndSettle();

      // Assert - Static User Data
      // Check for the user's full name in the AppBar and the body
      expect(find.text(tUser.fullName), findsNWidgets(2));
      // Check for the user's email
      expect(find.text(tUser.email), findsOneWidget);
      // Check for the Hero widget associated with the user's avatar
      expect(
          find.byWidgetPredicate(
              (widget) => widget is Hero && widget.tag == 'avatar_${tUser.id}'),
          findsOneWidget);

      // Assert - Dynamic ViewModel Data
      // Find the widgets by the keys we added and verify they are not empty.
      final jobTitleFinder = find.byKey(const Key('profile_jobTitle'));
      final jobAreaFinder = find.byKey(const Key('profile_jobArea'));
      final biographyFinder = find.byKey(const Key('profile_biography'));

      expect(jobTitleFinder, findsOneWidget);
      expect(jobAreaFinder, findsOneWidget);
      expect(biographyFinder, findsOneWidget);

      expect((tester.widget(jobTitleFinder) as Text).data, isNotEmpty);
      expect((tester.widget(jobAreaFinder) as Text).data, isNotEmpty);
      expect((tester.widget(biographyFinder) as Text).data, isNotEmpty);
    });
  });
}
