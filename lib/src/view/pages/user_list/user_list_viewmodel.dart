import 'package:flutter/foundation.dart';
import 'package:rarolabs/src/domain/entities/user.dart';
import 'package:rarolabs/src/domain/usecases/get_users_usecase.dart';
import 'package:rarolabs/src/domain/usecases/logout_usecase.dart';

class UserListViewModel extends ChangeNotifier {
  final GetUsersUseCase _getUsersUseCase;
  final LogoutUseCase _logoutUseCase;

  UserListViewModel(this._getUsersUseCase, this._logoutUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingNextPage = false;
  bool get isLoadingNextPage => _isLoadingNextPage;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<User> _users = [];
  List<User> get users => _users;

  List<User> _filteredUsers = [];
  List<User> get filteredUsers => _filteredUsers;

  int _currentPage = 1;
  bool _hasMorePages = true;
  String _searchQuery = '';
  int totalPages = 0;

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (isRefresh) {
      _users = [];
      _hasMorePages = true;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_currentPage <= 2) {
        final newUsers = await _getUsersUseCase(page: _currentPage);
        if (newUsers.isEmpty) {
          _hasMorePages = false;
        } else {
          _hasMorePages = true;
        }
        _users.addAll(newUsers);
        _applyFilter();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _currentPage = 1;
      _hasMorePages = true;
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingNextPage || !_hasMorePages || _searchQuery.isNotEmpty) return;

    _isLoadingNextPage = true;
    notifyListeners();
    _currentPage++;
    try {
      if (_currentPage <= 2) {
        final newUsers = await _getUsersUseCase(page: _currentPage);
        if (newUsers.isEmpty) {
          _hasMorePages = false;
        }
        _users.addAll(newUsers);
        _applyFilter();
      }
    } catch (e) {
      _currentPage--; // Revert page count on error
      // Optionally show a snackbar or toast for pagination error
    } finally {
      _isLoadingNextPage = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = List.from(_users);
    } else {
      _filteredUsers = _users
          .where((user) =>
              user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _logoutUseCase();
  }
}
