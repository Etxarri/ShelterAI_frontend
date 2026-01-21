import 'package:flutter/material.dart';
import 'package:shelter_ai/providers/auth_state.dart';
import 'package:shelter_ai/services/auth_service.dart';
import 'package:shelter_ai/widgets/form_card_container.dart';
import 'package:shelter_ai/widgets/auth_button.dart';
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
    final color = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _isLoading
                ? null
                : () =>
                    Navigator.pushReplacementNamed(context, '/refugee-landing'),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FormCardContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Refugee Access',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use your email, phone or username to access.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
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
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.pushReplacementNamed(
                              context,
                              '/refugee-register',
                            ),
                    child: Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(color: color.primary),
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.pushReplacementNamed(
                              context,
                              '/refugee-landing',
                            ),
                    child: const Text('Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
