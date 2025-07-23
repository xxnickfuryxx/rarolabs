// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:rarolabs/src/domain/usecases/check_auth_status_usecase.dart';
import 'package:rarolabs/src/utils/dependencies.dart';
import 'package:rarolabs/src/view/pages/home/home_page.dart';
import 'package:rarolabs/src/view/pages/login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    final checkAuthUseCase = getIt<CheckAuthStatusUseCase>();
    final isAuthenticated = await checkAuthUseCase();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              isAuthenticated ? const HomePage() : const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flutter_dash,
                size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 20),
            const Text('Raro Labs MVVM',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
