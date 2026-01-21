import 'package:flutter/material.dart';
import 'package:shelter_ai/providers/auth_state.dart';
import 'package:shelter_ai/services/auth_service.dart';
import 'package:shelter_ai/widgets/auth_button.dart';
import 'package:shelter_ai/widgets/auth_screen_scaffold.dart';
import 'package:shelter_ai/utils/auth_helper.dart';
import 'package:shelter_ai/utils/form_validators.dart';

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
    return AuthScreenScaffold(
      title: 'Create account',
      showAppBar: true,
      onBackPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      isLoading: _isLoading,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthFormHeader(
              title: 'Create worker account',
              subtitle: 'Use an organization email to maintain security.',
            ),
            AuthTextField(
              controller: _nameCtrl,
              labelText: 'Full name',
              prefixIcon: Icons.person,
              enabled: !_isLoading,
              validator: FormValidators.required,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailCtrl,
              labelText: 'Email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
              validator: FormValidators.email,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordCtrl,
              labelText: 'Password',
              prefixIcon: Icons.lock,
              obscureText: true,
              enabled: !_isLoading,
              validator: FormValidators.password,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _confirmCtrl,
              labelText: 'Confirm password',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              enabled: !_isLoading,
              validator: (v) =>
                  FormValidators.confirmPassword(v, _passwordCtrl.text),
            ),
            const SizedBox(height: 22),
            AuthButton(
              onPressed: _handleRegister,
              isLoading: _isLoading,
              label: 'Create account',
              loadingLabel: 'Creating account...',
              icon: Icons.person_add_alt_1,
            ),
            AuthNavigationButton(
              text: 'I already have an account',
              route: '/login',
              isLoading: _isLoading,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }
}
