import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rarolabs/src/domain/entities/user.dart';
import 'package:rarolabs/src/domain/usecases/get_users_usecase.dart';
import 'package:rarolabs/src/domain/usecases/logout_usecase.dart';
import 'package:rarolabs/src/view/pages/user_list/user_list_viewmodel.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late UserListViewModel viewModel;
  late MockGetUsersUseCase mockGetUsersUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockGetUsersUseCase = MockGetUsersUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    viewModel = UserListViewModel(mockGetUsersUseCase, mockLogoutUseCase);
  });

  final tUsersPage1 = [
    const User(
        id: 1,
        email: 'george.bluth@reqres.in',
        firstName: 'George',
        lastName: 'Bluth',
        avatar: ''),
    const User(
        id: 2,
        email: 'janet.weaver@reqres.in',
        firstName: 'Janet',
        lastName: 'Weaver',
        avatar: ''),
  ];

  final tUsersPage2 = [
    const User(
        id: 3,
        email: 'emma.wong@reqres.in',
        firstName: 'Emma',
        lastName: 'Wong',
        avatar: ''),
  ];

  test('initial state is correct', () {
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.isLoadingNextPage, isFalse);
    expect(viewModel.errorMessage, isNull);
    expect(viewModel.users, isEmpty);
    expect(viewModel.filteredUsers, isEmpty);
  });


  group('search', () {
    test('should filter users based on search query', () {
      // arrange
      viewModel.users.addAll(tUsersPage1);

      // act
      viewModel.search('George');

      // assert
      expect(viewModel.filteredUsers.length, 1);
      expect(viewModel.filteredUsers.first.firstName, 'George');
    });

    test('should return all users when search query is empty', () {
      // arrange
      viewModel.users.addAll(tUsersPage1);
      viewModel.search('George'); // First, filter

      // act
      viewModel.search(''); // Then, clear filter

      // assert
      expect(viewModel.filteredUsers.length, 2);
      expect(viewModel.filteredUsers, tUsersPage1);
    });
  });

}
