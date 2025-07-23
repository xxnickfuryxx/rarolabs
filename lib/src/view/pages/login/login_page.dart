import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rarolabs/l10n/app_localizations.dart';
import 'package:rarolabs/src/view/pages/login/login_viewmodel.dart';
import 'package:rarolabs/src/view/pages/home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'eve.holt@reqres.in');
  final _passwordController = TextEditingController(text: 'cityslicka');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<LoginViewModel>(context, listen: false);
      viewModel.login(
        _emailController.text,
        _passwordController.text,
        onSuccess: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()));
        },
        onError: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final locale = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.lock_open,
                    size: 80, color: Theme.of(context).primaryColor),
                const SizedBox(height: 24),
                Text(
                  '${locale.loginWelcomeTitle}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${locale.loginToContinue}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: '${locale.email}',
                      prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? '${locale.loginInsertEmail}' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: '${locale.password}',
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? '${locale.loginInsertPassword}' : null,
                ),
                const SizedBox(height: 32),
                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text('${locale.login}'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
