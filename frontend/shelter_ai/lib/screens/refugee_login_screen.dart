import 'package:flutter/material.dart';
import 'package:shelter_ai/providers/auth_state.dart';
import 'package:shelter_ai/services/auth_service.dart';
import 'package:shelter_ai/widgets/auth_button.dart';
import 'package:shelter_ai/widgets/auth_screen_scaffold.dart';
import 'package:shelter_ai/utils/auth_helper.dart';

class RefugeeLoginScreen extends StatefulWidget {
  const RefugeeLoginScreen({super.key});

  @override
  State<RefugeeLoginScreen> createState() => _RefugeeLoginScreenState();
}

class _RefugeeLoginScreenState extends State<RefugeeLoginScreen> {
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
      title: 'Sign In',
      showAppBar: true,
      onBackPressed: () =>
          Navigator.pushReplacementNamed(context, '/refugee-landing'),
      isLoading: _isLoading,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthFormHeader(
            title: 'Refugee Access',
            subtitle: 'Use your email, phone or username to access.',
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
            text: 'Don\'t have an account? Register',
            route: '/refugee-register',
            isLoading: _isLoading,
            isPrimary: true,
          ),
          AuthNavigationButton(
            text: 'Back',
            route: '/refugee-landing',
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
