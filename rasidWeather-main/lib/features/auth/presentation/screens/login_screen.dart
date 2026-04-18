import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../views/base/input_field_widget.dart';
import '../../../../views/base/rounded_button_widget.dart';
import '../../../../views/base/rounded_loading_button.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  // Button controllers
  final RoundedLoadingButtonController _loginController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _appleController =
      RoundedLoadingButtonController();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Track form validity
  bool _isFormValid = false;

  // Error messages
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// Navigate to dashboard after successful login
  void _afterLogin() {
    // Use Future.microtask instead of Future.delayed with Duration.zero
    // for better performance and predictability
    Future<void>.microtask(() async {
      await context.read<ProfileCubit>().getProfile();

      if (!mounted) return;

      RouterHelper.getDashboardRoute('home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: BlocListener<AuthCubit, AuthState>(
        listener: _handleAuthStateChanges,
        child: Form(
          key: _formKey,
          onChanged: _onFormChanged,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildWelcomeText(),
                SizedBox(height: 20.h),
                _buildEmailField(),
                SizedBox(height: 20.h),
                _buildPasswordField(),
                SizedBox(height: 10.h),
                _buildForgotPasswordButton(),
                SizedBox(height: 20.h),
                _buildLoginButton(),
                SizedBox(height: 20.h),
                _buildOrDivider(),
                SizedBox(height: 20.h),
                _buildSocialLoginButtons(),
                SizedBox(height: 10.h),
                _buildSignUpRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tracks form changes to update button state
  void _onFormChanged() {
    if (!mounted) {
      return;
    }

    // Validate without showing errors
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        'auth.login.title'.tr(),
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Handles auth state changes
  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    // Handle email authentication states
    if (state is AuthEmailLoading) {
      _loginController.start();
      _resetErrors();
    }
    if (state is AuthEmailSuccess) {
      _handleSuccess(_loginController);
      _resetErrors();
    }
    if (state is AuthEmailError) {
      _parseAuthError(state.error);
      _handleError(_loginController, state.error);
    }

    // Handle Google authentication states
    if (state is GoogleLoading) {
      _googleController.start();
      _resetErrors();
    }
    if (state is GoogleSuccess) {
      _handleSuccess(_googleController, markSuccess: true);
    }
    if (state is GoogleAuthError) {
      _handleError(_googleController, state.error);
      showSnackBar('auth.login.google_error'.tr(), color: Colors.red);
    }

    // Handle Apple authentication states
    if (state is AppleLoading) {
      _appleController.start();
      _resetErrors();
    }
    if (state is AppleSuccess) {
      _handleSuccess(_appleController, markSuccess: true);
    }
    if (state is AppleAuthError) {
      _handleError(_appleController, state.error);
      showSnackBar('auth.login.apple_error'.tr(), color: Colors.red);
    }
  }

  /// Parse authentication error to display field-specific errors
  void _parseAuthError(String error) {
    if (error.toLowerCase().contains('email') ||
        error.toLowerCase().contains('بريد')) {
      setState(() {
        _emailError = error;
        _passwordError = null;
      });
    } else if (error.toLowerCase().contains('password') ||
        error.toLowerCase().contains('كلمة المرور')) {
      setState(() {
        _emailError = null;
        _passwordError = error;
      });
    } else {
      // General error
      showSnackBar(error, color: Colors.red);
    }
  }

  /// Reset all error messages
  void _resetErrors() {
    if (_emailError != null || _passwordError != null) {
      setState(() {
        _emailError = null;
        _passwordError = null;
      });
    }
  }

  /// Handle successful authentication
  void _handleSuccess(RoundedLoadingButtonController controller,
      {bool markSuccess = false}) {
    if (markSuccess) {
      controller.success();
    } else {
      controller.reset();
    }

    // Add a small delay to show success animation before navigating
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _afterLogin();
      }
    });
  }

  /// Handle authentication error
  void _handleError(RoundedLoadingButtonController controller, String error) {
    controller.error();

    // Reset button after showing error
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        controller.reset();
        _resetErrors(); // Reset any field errors
      }
    });
  }

  /// Builds the welcome text
  Widget _buildWelcomeText() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Text(
      'auth.login.welcome'.tr(),
      style: textTheme.headlineSmall?.copyWith(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Builds the email input field
  Widget _buildEmailField() {
    return InputField(
      hintText: 'auth.login.email'.tr(),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ImageView.svgAsset(Assets.svgMail),
      ),
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'auth.login.email_required'.tr();
        }
        if (!value.isValidEmail()) {
          return 'auth.login.invalid_email'.tr();
        }
        return null;
      },
      errorText: _emailError,
      onChanged: (_) => _resetErrors(),
    );
  }

  /// Builds the password input field
  Widget _buildPasswordField() {
    return InputField(
      isPassword: true,
      hintText: 'auth.login.password'.tr(),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ImageView.svgAsset(Assets.svgLock),
      ),
      controller: _passCtrl,
      validator: (String? value) => value?.validPassword(),
      errorText: _passwordError,
      onChanged: (_) => _resetErrors(),
    );
  }

  /// Builds the forgot password button
  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => RouterHelper.getForgetPassRoute(),
        child: Text('auth.login.forget_password'.tr()),
      ),
    );
  }

  /// Builds the login button
  Widget _buildLoginButton() {
    return RoundedButtonWidget(
      title: 'auth.login.login'.tr(),
      controller: _loginController,
      onPressed: _handleEmailLogin,
      color: Theme.of(context).primaryColor,
      loadingText: 'auth.login.loading'.tr(),
    );
  }

  /// Handles email login
  void _handleEmailLogin() {
    // Hide keyboard when login button is pressed
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signInWithEmail(
            _emailCtrl.text.trim(),
            _passCtrl.text,
          );
    } else {
      _loginController.reset();

      // Collect all validation errors
      final List<String> errors = <String>[];

      if (_emailCtrl.text.isEmpty || !_emailCtrl.text.isValidEmail()) {
        errors.add('auth.login.invalid_email'.tr());
      }

      if (_passCtrl.text.isEmpty) {
        errors.add('auth.login.password_required'.tr());
      }

      if (errors.isNotEmpty) {
        showSnackBar(errors.join(', '), color: Colors.red);
      }
    }
  }

  /// Builds the OR divider
  Widget _buildOrDivider() {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text('auth.login.or', textAlign: TextAlign.center).tr(),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  /// Builds the social login buttons
  Widget _buildSocialLoginButtons() {
    return Column(
      children: <Widget>[
        if (Platform.isAndroid)
          RoundedButtonWidget(
            title: 'auth.login.google_signin'.tr(),
            controller: _googleController,
            icon: FontAwesomeIcons.google,
            onPressed: _handleGoogleLogin,
            color: Colors.red.shade700,
            loadingText: 'auth.login.google_loading'.tr(),
          ),
        if (Platform.isIOS)
          RoundedButtonWidget(
            title: 'auth.login.apple_signin'.tr(),
            controller: _appleController,
            icon: FontAwesomeIcons.apple,
            onPressed: _handleAppleLogin,
            loadingText: 'auth.login.apple_loading'.tr(),
          ),
      ],
    );
  }

  /// Handle Google login
  void _handleGoogleLogin() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().signInWithGoogle();
  }

  /// Handle Apple login
  void _handleAppleLogin() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().signInWithApple();
  }

  /// Builds the sign up row
  Widget _buildSignUpRow() {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('auth.login.dont_have_account'.tr()),
        TextButton(
          onPressed: () => RouterHelper.getSignUpRoute(),
          child: Text(
            'auth.signup.signup'.tr(),
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
