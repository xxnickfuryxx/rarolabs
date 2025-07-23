// view/pages/login/login_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:rarolabs/src/domain/usecases/login_usecase.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  LoginViewModel(this._loginUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(
    String email,
    String password, {
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loginUseCase(email, password);
      onSuccess();
    } catch (e) {
      onError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}