import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/core/themes/app_colors.dart';
import 'package:newsapp/core/themes/app_text_styles.dart';
import 'package:newsapp/core/themes/app_spacing.dart';
import 'package:newsapp/core/utils/validators.dart';
import 'package:newsapp/core/widgets/custom_text_field.dart';
import 'package:newsapp/core/widgets/primary_button.dart';
import 'package:newsapp/dependency_injection/injection.dart';
import 'package:newsapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:newsapp/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:newsapp/features/auth/presentation/bloc/login/login_event.dart';
import 'package:newsapp/features/auth/presentation/bloc/login/login_state.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/routes/route_names.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.read<AuthBloc>().add(CheckSessionRequested());
            context.go(RouteNames.news);
          }
          if (state is LoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),

                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.newspaper_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    Text(l10n.login, style: AppTextStyles.displayLarge),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      l10n.loginSubtitle,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxxl),

                    CustomTextField(
                      controller: _emailController,
                      hintText: l10n.email,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) =>
                          Validators.validateEmail(context, value),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _passwordController,
                      hintText: l10n.password,
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) =>
                          Validators.validatePassword(context, value),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return PrimaryButton(
                          text: l10n.login,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                LoginRequested(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Center(
                      child: TextButton(
                        onPressed: () => context.push(RouteNames.signup),
                        child: Text(l10n.dontHaveAccount),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
