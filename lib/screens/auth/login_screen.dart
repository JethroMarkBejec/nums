import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/gradient_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isSubmitting = false;
  late final AnimationController _entranceController;
  late final Animation<double> _entranceAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _entranceAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    final signedIn = context.read<AuthProvider>().signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!signedIn) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('That email and password do not match an account.')),
      );
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
        context, '/customer-shell', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeTransition(
        opacity: _entranceAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.025),
            end: Offset.zero,
          ).animate(_entranceAnimation),
          child: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Image.asset('assets/images/logo.png',
                              width: 300, fit: BoxFit.contain),
                          const SizedBox(height: 2),
                          Text(
                            'Cookie\u2019s, Baked for You',
                            style: AppTextStyles.fun(15),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Welcome back!',
                            style: AppTextStyles.fun(35),
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.validateEmail,
                            fontSize: 12,
                            verticalPadding: 12,
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            obscureText: true,
                            validator: AppValidators.validatePassword,
                            fontSize: 12,
                            verticalPadding: 12,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () =>
                                    setState(() => _rememberMe = !_rememberMe),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      activeColor: AppColors.primary,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      side: const BorderSide(
                                          color: AppColors.primary, width: 1.2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      onChanged: (v) => setState(
                                          () => _rememberMe = v ?? false),
                                    ),
                                    Text('Remember Me',
                                        style: AppTextStyles.q(13)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Password reset link sent to your email.'),
                                  ),
                                ),
                                child: Text('Forgot Password?',
                                    style: AppTextStyles.q(13)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AppButton(
                            label: _isSubmitting ? 'Signing in…' : 'Log In',
                            height: 44,
                            fontSize: 14,
                            onPressed: _isSubmitting ? null : _logIn,
                          ),
                          const SizedBox(height: 8),
                          Text('Demo: welcome@nums.com  ·  cookies123',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.q(11,
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Row(
                              children: [
                                const Expanded(
                                    child: Divider(color: AppColors.divider)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text('or', style: AppTextStyles.q(14)),
                                ),
                                const Expanded(
                                    child: Divider(color: AppColors.divider)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            label: 'Create a New Account',
                            isPrimary: false,
                            height: 44,
                            fontSize: 14,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/signup'),
                          ),
                          const SizedBox(height: 70),
                          Image.asset('assets/images/cats_login.png',
                              width: 180),
                          const SizedBox(height: 12),
                          Text.rich(
                            TextSpan(
                              style: AppTextStyles.q(12,
                                  color: AppColors.textSecondary),
                              children: [
                                const TextSpan(
                                    text: 'By continuing, you agree to our\n'),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: AppTextStyles.q(12,
                                      color: AppColors.textSecondary,
                                      decoration: TextDecoration.underline),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTextStyles.q(12,
                                      color: AppColors.textSecondary,
                                      decoration: TextDecoration.underline),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                            textAlign: TextAlign.center,
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
          ),
        ),
      ),
    );
  }
}
