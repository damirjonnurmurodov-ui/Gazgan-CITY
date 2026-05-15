import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../data/auth_repository.dart';
import '../models/auth_user.dart';
import '../widgets/google_auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.repository, this.redirectPath});

  final AuthRepository? repository;
  final String? redirectPath;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;
  late final AuthRepository _repository;
  StreamSubscription<AuthUser?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? SupabaseAuthRepository();
    _authSubscription = _repository.authStateChanges.listen((user) {
      if (user == null || !mounted) return;
      context.go(_safeRedirectPath(widget.redirectPath));
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email va parolni kiriting.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _repository.signInWithEmail(email: email, password: password);
      if (!mounted) return;
      context.go(_safeRedirectPath(widget.redirectPath));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Kirishda xatolik. Ma\'lumotlarni tekshiring.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    try {
      await _repository.signInWithGoogle();
    } on AuthFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Google orqali kirishda xatolik yuz berdi.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: <Widget>[
            _AuthHeader(
              title: 'Kirish',
              subtitle: 'Gazgan City xizmatlaridan foydalanish uchun kiring.',
              icon: LucideIcons.logIn,
            ),
            const SizedBox(height: 22),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: LucideIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  _AuthTextField(
                    controller: _passwordController,
                    label: 'Parol',
                    icon: LucideIcons.lock,
                    obscureText: true,
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    _AuthError(message: _errorMessage!),
                  ],
                  const SizedBox(height: 18),
                  AppButton(
                    label: _isLoading ? 'Tekshirilmoqda...' : 'Kirish',
                    icon: LucideIcons.chevronRight,
                    isExpanded: true,
                    onPressed: _isLoading || _isGoogleLoading ? null : _submit,
                  ),
                  const SizedBox(height: 12),
                  GoogleAuthButton(
                    isLoading: _isGoogleLoading,
                    onPressed: _isLoading ? null : _submitGoogle,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Ro\'yxatdan o\'tish',
                    icon: LucideIcons.userPlus,
                    variant: AppButtonVariant.ghost,
                    isExpanded: true,
                    onPressed: () {
                      final redirect = widget.redirectPath;
                      if (redirect == null || redirect.trim().isEmpty) {
                        context.push('/register');
                        return;
                      }

                      context.push(
                        '/register?redirect=${Uri.encodeComponent(redirect)}',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _safeRedirectPath(String? redirectPath) {
  final redirect = redirectPath?.trim();
  if (redirect == null || redirect.isEmpty || !redirect.startsWith('/')) {
    return '/profile';
  }
  if (redirect.startsWith('//')) return '/profile';
  return redirect;
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.screenTitle,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}

class _AuthError extends StatelessWidget {
  const _AuthError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.caption.copyWith(color: AppColors.redDanger),
    );
  }
}
