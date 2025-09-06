import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/app/data/datasources/remote/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saffron Supply Chain'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                icon: const Icon(Icons.email),
                label: const Text('Sign in with Email'),
                onPressed: () {
                  // TODO: Implement email sign in
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                onPressed: () async {
                  final router = GoRouter.of(context);
                  final userCredential = await _authService.signInWithGoogle();
                  if (userCredential != null) {
                    router.go('/');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
