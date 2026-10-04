import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/gradient_background.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;
    setState(() => _isSubmitting = true);
    final created = context.read<AuthProvider>().signUp(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!created) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An account with that email already exists.')),
      );
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
        context, '/customer-shell', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 20),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(height: 12),
                        Center(
                            child: Image.asset('assets/images/logo.png',
                                height: 116)),
                        const SizedBox(height: 18),
                        Text('Create your account',
                            style: AppTextStyles.display1(34)),
                        const SizedBox(height: 6),
                        Text('A fresh batch is just around the corner.',
                            style: AppTextStyles.q(14,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 24),
                        AppTextField(
                          controller: _nameController,
                          labelText: 'Full Name',
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Your name is required'
                                  : null,
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidators.validateEmail,
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          obscureText: true,
                          validator: AppValidators.validatePassword,
                        ),
                        const SizedBox(height: 22),
                        AppButton(
                          label: _isSubmitting
                              ? 'Creating account…'
                              : 'Create Account',
                          onPressed: _isSubmitting ? null : _createAccount,
                        ),
                        const SizedBox(height: 22),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              style: AppTextStyles.q(12,
                                  color: AppColors.textSecondary),
                              children: const [
                                TextSpan(
                                    text: 'By continuing, you agree to our\n'),
                                TextSpan(
                                    text:
                                        'Terms of Service and Privacy Policy'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
