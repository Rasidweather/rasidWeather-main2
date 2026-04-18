import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../views/base/input_field_widget.dart';
import '../../../../views/base/rounded_button_widget.dart';
import '../../../../views/base/rounded_loading_button.dart';
import '../cubit/auth_cubit.dart';
import '../mixins/dialog_mixin.dart';

class RequestResetPasswordScreen extends StatefulWidget {
  const RequestResetPasswordScreen({super.key});

  @override
  State<RequestResetPasswordScreen> createState() => _RequestResetPasswordScreenState();
}

class _RequestResetPasswordScreenState extends State<RequestResetPasswordScreen> with DialogMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController otpCtrl = TextEditingController();
  final RoundedLoadingButtonController _requestController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _verifyController = RoundedLoadingButtonController();
  bool otpSent = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    emailCtrl.dispose();
    otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text('auth.forgot_password.title'.tr(), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500))),
      body: BlocListener<AuthCubit, AuthState>(
        listener: _handleAuthStateChanges,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'auth.forgot_password.subtitle'.tr(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff3D3C3C)),
                ),
                const SizedBox(height: 50),
                _buildEmailField(),
                const SizedBox(height: 20),
                if (otpSent) _buildOtpField(),
                const SizedBox(height: 80),
                if (!otpSent) _buildRequestButton(),
                if (otpSent) _buildVerifyButton(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles state changes from the AuthCubit
  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    print('Auth state: $state');

      // عرض مؤشر التحميل
      if (state is AuthLoading && state.message!.contains('sending_code')) {
        _requestController.start();
      } else if (state is AuthLoading && state.message!.contains('verifying_code')) {
        _verifyController.start();
      } else {}

      if (state is AuthError || state is RestPasswordError) {
        final String errorMessage = state is AuthError ? state.error : (state as RestPasswordError).error;
       
        _requestController.reset();
        _verifyController.reset();
         showErrorSnackBar(context, errorMessage);
      } else if (state is AuthSuccess) {
        if (state.message != null) {
          showSuccessSnackBar(context, state.message!);
        }

        // معالجة استجابة إرسال رمز التحقق
        if (state.message == 'auth.forgot_password.code_sent'.tr()) {
          _requestController.success();
          Future.delayed(const Duration(seconds: 1), () {
            _requestController.reset();
          });

          // عرض حقل إدخال رمز التحقق OTP
          if (!otpSent) {
            setState(() {
              otpSent = true;
            });
          }
        }

        // معالجة استجابة التحقق من رمز OTP
        if (state.message == 'auth.forgot_password.code_verified'.tr()) {
          _verifyController.success();
          Future.delayed(const Duration(seconds: 1), () {
            _verifyController.reset();

            // الانتقال إلى شاشة إعادة تعيين كلمة المرور عند التحقق من الرمز
            _navigateToResetPassword();
          });
        }
      }
  }

  /// Navigates to the reset password screen
  void _navigateToResetPassword() {
    RouterHelper.getResetPassRoute(emailCtrl.text, otpCtrl.text);
  }

  /// Builds the email input field
  Widget _buildEmailField() {
    return InputField(
      isEnabled: !otpSent,
      hintText: 'auth.forgot_password.email'.tr(),
      prefixIcon: Padding(padding: const EdgeInsets.all(12.0), child: ImageView.svgAsset(Assets.svgMail)),
      controller: emailCtrl,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'auth.forgot_password.email_required'.tr();
        }
        return null;
      },
    );
  }

  /// Builds the OTP input field
  Widget _buildOtpField() {
    return InputField(
      hintText: 'auth.forgot_password.verify_otp'.tr(),
      controller: otpCtrl,
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'common.required_field'.tr();
        }
        return null;
      },
    );
  }

  /// Builds the request OTP button
  Widget _buildRequestButton() {
    return RoundedButtonWidget(
      title: 'auth.forgot_password.submit'.tr(),
      controller: _requestController,
      onPressed: _handleRequestOtp,
      color: Theme.of(context).primaryColor,
    );
  }

  /// Builds the verify OTP button
  Widget _buildVerifyButton() {
    return RoundedButtonWidget(
      title: 'auth.forgot_password.verify_otp'.tr(),
      controller: _verifyController,
      onPressed: _handleVerifyOtp,
      color: Theme.of(context).primaryColor,
    );
  }

  /// Handles the request OTP button press
  void _handleRequestOtp() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().sendResetPasswordCode(emailCtrl.text);
      setState(() {
        otpSent = true;
      });
    }
  }

  /// Handles the verify OTP button press
  void _handleVerifyOtp() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().checkConfirmCode(emailCtrl.text, otpCtrl.text);
    }
  }
}
