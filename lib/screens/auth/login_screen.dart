import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/app/app_icons.dart';
import 'package:bible_app/services/auth_service.dart';
import 'package:bible_app/screens/auth/signup_screen.dart';

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
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorText;

  late final AnimationController _controller;
  late final Animation<double> _headerAnim;
  late final Animation<double> _fieldsAnim;
  late final Animation<double> _buttonAnim;
  late final Animation<double> _footerAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _headerAnim = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45, curve: Curves.easeOut));
    _fieldsAnim = CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.7, curve: Curves.easeOut));
    _buttonAnim = CurvedAnimation(parent: _controller, curve: const Interval(0.45, 0.85, curve: Curves.easeOut));
    _footerAnim = CurvedAnimation(parent: _controller, curve: const Interval(0.65, 1.0, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _fadeSlide(Animation<double> anim, Widget child) {
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(anim),
        child: child,
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      await _authService.logIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      setState(() => _errorText = _authService.friendlyError(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email above first, then tap "Forgot password?"')),
      );
      return;
    }

    try {
      await _authService.resetPassword(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to $email')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_authService.friendlyError(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _fadeSlide(
                  _headerAnim,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(AppIcons.bible, size: 32, color: AppColors.primaryGreen),
                      ),
                      const SizedBox(height: 20),
                      Text('Welcome Back', style: AppText.pageTitle.copyWith(fontSize: 26)),
                      const SizedBox(height: 6),
                      Text('Log in to continue your journey.', style: AppText.body.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _fadeSlide(
                  _fieldsAnim,
                  Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.mail_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (value) {
                          if (value == null || !value.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _handleForgotPassword,
                          child: const Text('Forgot password?'),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 4),
                  Text(_errorText!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                ],
                _fadeSlide(
                  _buttonAnim,
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Log In'),
                  ),
                ),
                const SizedBox(height: 16),
                _fadeSlide(
                  _footerAnim,
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
                        );
                      },
                      child: const Text("Don't have an account? Sign up"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
