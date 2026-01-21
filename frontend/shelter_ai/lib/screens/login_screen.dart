import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';
import 'package:shelter_ai/providers/auth_state.dart';
import 'package:shelter_ai/services/auth_service.dart';
import 'package:shelter_ai/widgets/auth_button.dart';
import 'package:shelter_ai/widgets/auth_screen_scaffold.dart';
import 'package:shelter_ai/utils/auth_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    await AuthHelper.handleLogin(
      context: context,
      identifier: _identifierCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      onLoadingStart: () => setState(() => _isLoading = true),
      onLoadingEnd: () => setState(() => _isLoading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenScaffold(
      isLoading: _isLoading,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthFormHeader(
            title: 'Worker Access',
            subtitle: 'Receive, assign and prioritize securely.',
          ),
          AuthTextField(
            controller: _identifierCtrl,
            labelText: 'Email, phone or username',
            prefixIcon: Icons.person,
            keyboardType: TextInputType.text,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: _passwordCtrl,
            labelText: 'Password',
            prefixIcon: Icons.lock,
            obscureText: true,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 20),
          AuthButton(
            onPressed: _handleLogin,
            isLoading: _isLoading,
            label: 'Sign in',
            loadingLabel: 'Signing in...',
            icon: Icons.login,
          ),
          AuthNavigationButton(
            text: 'First time? Create account',
            route: '/register',
            isLoading: _isLoading,
            isPrimary: true,
          ),
          AuthNavigationButton(
            text: 'Back to home',
            route: '/welcome',
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
