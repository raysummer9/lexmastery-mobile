import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:lexmastery_mobile/features/authentication/presentation/state/auth_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/');
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: context.spacing.md),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: context.spacing.lg),
            FilledButton(
              onPressed: authState.status == AuthStatus.authenticating
                  ? null
                  : () => ref.read(authControllerProvider.notifier).signIn(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      ),
              child: Text(
                authState.status == AuthStatus.authenticating
                    ? 'Signing in...'
                    : 'Sign in',
              ),
            ),
            if (authState.message != null) ...<Widget>[
              SizedBox(height: context.spacing.md),
              Text(
                authState.message!,
                style: context.typography.bodyMedium
                    .copyWith(color: context.colors.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
