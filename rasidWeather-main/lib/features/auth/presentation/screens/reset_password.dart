import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/ui_utils.dart';
import '../../../../utils/validator.dart';
import '../../../../views/base/input_field_widget.dart';
import '../../../../views/base/rounded_button_widget.dart';
import '../../../../views/base/rounded_loading_button.dart';
import '../cubit/auth_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.otp, required this.email});

  final String otp;
  final String email;

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();
  final RoundedLoadingButtonController _resetButtonController = RoundedLoadingButtonController();

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: _buildAppBar(context),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: _handleAuthStateChanges,
          builder: (BuildContext context, AuthState state) {
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text('auth.reset_password.subtitle'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 50),
                    _buildPasswordField(),
                    const SizedBox(height: 20),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 80),
                    _buildSubmitButton(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the app bar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        alignment: Alignment.centerRight,
        child: IconButton(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.zero,
          icon: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Text('auth.reset_password.title'.tr(), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
    );
  }

  /// Handles auth state changes
  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is RestPasswordLoading || state is AuthLoading) {
      _resetButtonController.start();
    } else if (state is RestPasswordError) {
      _resetButtonController.reset();
      showSnackBar(context, state.error, color: Colors.red);
    } else if (state is RestPasswordSuccess) {
      _resetButtonController.success();
      showSnackBar(context, state.message!);
      // navigate after 2 second
      Future<void>.delayed(const Duration(seconds: 2), () {
        RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);
      });
    }
    // Handle generic AuthError as well
    else if (state is AuthError) {
      _resetButtonController.reset();
      showSnackBar(context, state.error, color: Colors.red);
    }
  }

  /// Builds the password field
  Widget _buildPasswordField() {
    return InputField(
      isPassword: true,
      prefixIcon: Padding(padding: const EdgeInsets.all(12.0), child: ImageView.svgAsset(Assets.svgKey)),
      hintText: 'auth.reset_password.new_password'.tr(),
      controller: passCtrl,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) => value!.validPassword(),
    );
  }

  /// Builds the confirm password field
  Widget _buildConfirmPasswordField() {
    return InputField(
      isPassword: true,
      prefixIcon: Padding(padding: const EdgeInsets.all(12.0), child: ImageView.svgAsset(Assets.svgKey)),
      hintText: 'auth.reset_password.confirm_password'.tr(),
      controller: confirmPassCtrl,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) => value!.validConfirmPassword(passCtrl.text),
    );
  }

  /// Builds the submit button
  Widget _buildSubmitButton() {
    return RoundedButtonWidget(
      title: 'auth.reset_password.submit'.tr(),
      controller: _resetButtonController,
      onPressed: _handleResetButton,
      color: Theme.of(context).primaryColor,
    );
  }

  /// Handles the reset password button press
  void _handleResetButton() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      context.read<AuthCubit>().resetPassword(widget.email, widget.otp, passCtrl.text);
    } else {
      _resetButtonController.reset();
    }
  }
}
