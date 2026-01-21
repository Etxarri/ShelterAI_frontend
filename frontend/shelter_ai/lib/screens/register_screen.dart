import 'package:flutter/material.dart';
import 'package:shelter_ai/providers/auth_state.dart';
import 'package:shelter_ai/services/auth_service.dart';
import 'package:shelter_ai/widgets/form_card_container.dart';
import 'package:shelter_ai/widgets/auth_button.dart';
import 'package:shelter_ai/utils/auth_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    await AuthHelper.handleWorkerRegister(
      context: context,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      onLoadingStart: () => setState(() => _isLoading = true),
      onLoadingEnd: () => setState(() => _isLoading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading
              ? null
              : () => Navigator.pushReplacementNamed(context, '/login'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FormCardContainer(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create worker account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use an organization email to maintain security.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AuthTextField(
                    controller: _nameCtrl,
                    labelText: 'Full name',
                    prefixIcon: Icons.person,
                    enabled: !_isLoading,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _emailCtrl,
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                      if (!emailRegex.hasMatch(v.trim())) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordCtrl,
                    labelText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    enabled: !_isLoading,
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Minimum 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _confirmCtrl,
                    labelText: 'Confirm password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    enabled: !_isLoading,
                    validator: (v) => (v == null || v != _passwordCtrl.text)
                        ? 'Passwords do not match'
                        : null,
                  ),
                  const SizedBox(height: 22),
                  AuthButton(
                    onPressed: _handleRegister,
                    isLoading: _isLoading,
                    label: 'Create account',
                    loadingLabel: 'Creating account...',
                    icon: Icons.person_add_alt_1,
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            ),
                    child: Text(
                      'I already have an account',
                      style: TextStyle(color: color.primary),
                    ),
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
