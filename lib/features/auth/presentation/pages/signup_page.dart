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
import 'package:newsapp/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:newsapp/features/auth/presentation/bloc/signup/signup_event.dart';
import 'package:newsapp/features/auth/presentation/bloc/signup/signup_state.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/routes/route_names.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => sl<SignupBloc>(),
      child: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.go(RouteNames.login);
          }
          if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
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
                    const SizedBox(height: AppSpacing.lg),

                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    Text(l10n.signup, style: AppTextStyles.displayLarge),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      l10n.signupSubtitle,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxxl),

                    CustomTextField(
                      controller: _nameController,
                      hintText: l10n.fullName,
                      prefixIcon: Icons.person_outline,
                      validator: (value) =>
                          Validators.validateName(context, value),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _phoneController,
                      hintText: l10n.phoneNumber,
                      prefixIcon: Icons.phone_outlined,
                      validator: (value) =>
                          Validators.validatePhone(context, value),
                    ),

                    const SizedBox(height: AppSpacing.md),

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

                    const SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: l10n.confirmPassword,
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) =>
                          Validators.validateConfirmPassword(
                        context,
                        value,
                        _passwordController.text,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    BlocBuilder<SignupBloc, SignupState>(
                      builder: (context, state) {
                        if (state is SignupLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return PrimaryButton(
                          text: l10n.signup,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignupBloc>().add(
                                    SignUpRequested(
                                      fullName: _nameController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password:
                                          _passwordController.text.trim(),
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
                        onPressed: () => context.pop(),
                        child: Text(l10n.alreadyHaveAccount),
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