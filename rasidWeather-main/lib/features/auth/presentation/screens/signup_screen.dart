import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/ui_utils.dart';
import '../../../../views/base/icons.dart';
import '../../../../views/base/input_field_widget.dart';
import '../../../../views/base/rounded_button_widget.dart';
import '../../../../views/base/rounded_loading_button.dart';
import '../cubit/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final Icon lockIcon = LockIcon().lock;
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _emailController = RoundedLoadingButtonController();

  bool signUpStarted = false;
  bool signUpCompleted = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    emailCtrl.dispose();
    passCtrl.dispose();
    nameCtrl.dispose();
    super.dispose();
  }

  /// Navigate back after successful sign up
  void afterSignUp() {
    Navigator.pop(context);
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
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: _buildAppBar(),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: _handleAuthStateChanges,
          builder: (BuildContext context, AuthState state) {
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ListView(
                  children: <Widget>[
                    _buildTitle(),
                    const SizedBox(height: 60),
                    _buildNameField(),
                    const SizedBox(height: 20),
                    _buildEmailField(),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                    const SizedBox(height: 50),
                    _buildSignUpButton(),
                    const SizedBox(height: 10),
                    _buildLoginRow(),
                    const SizedBox(height: 20),
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
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      title: Text('auth.signup.signup'.tr(), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
    );
  }

  /// Handles auth state changes
  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is AuthLoading) {
      _emailController.start();
    }
    if (state is AuthError) {
      _emailController.reset();
      showSnackBar(context, state.error, color: Colors.red);
    }
    if (state is RegisterSuccess) {
      showSnackBar(context, 'auth.signup.success'.tr());
      _emailController.success();
      afterSignUp();
    }
  }

  /// Builds the title text
  Widget _buildTitle() {
    return Text('auth.signup.title'.tr(), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500));
  }

  /// Builds the name input field
  Widget _buildNameField() {
    return InputField(
      hintText: 'auth.signup.name'.tr(),
      prefixIcon: Padding(padding: const EdgeInsets.all(12.0), child: ImageView.svgAsset(Assets.svgUser)),
      controller: nameCtrl,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'auth.signup.name_required'.tr();
        }
        if (value.replaceAll(' ', '').length <= 4) {
          return 'auth.signup.name_length'.tr();
        }
        return null;
      },
    );
  }

  /// Builds the email input field
  Widget _buildEmailField() {
    return InputField(
      hintText: 'auth.signup.email'.tr(),
      prefixIcon: Padding(padding: const EdgeInsets.all(12.0), child: ImageView.svgAsset(Assets.svgMail)),
      controller: emailCtrl,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'auth.signup.email_required'.tr();
        }
        return null;
      },
    );
  }

  /// Builds the password input field
  Widget _buildPasswordField() {
    return InputField(
      hintText: 'auth.signup.password'.tr(),
      prefixIcon: Padding(padding: const EdgeInsets.all(12.0), child: ImageView.svgAsset(Assets.svgKey)),
      controller: passCtrl,
      isPassword: true,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'auth.signup.password_required'.tr();
        }
        if (value.length < 6) {
          return 'auth.signup.password_short'.tr();
        }
        return null;
      },
    );
  }

  /// Builds the sign up button
  Widget _buildSignUpButton() {
    return RoundedButtonWidget(
      title: 'auth.signup.signup'.tr(),
      controller: _emailController,
      onPressed: _handleCreateAccount,
      color: Theme.of(context).primaryColor,
    );
  }

  /// Builds the login row
  Widget _buildLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('auth.signup.already_have_account'.tr()),
        TextButton(
          onPressed: () => RouterHelper.getLoginRoute(),
          child: Text('auth.login.login'.tr(), style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }

  /// Handles the create account button press
  void _handleCreateAccount() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      context.read<AuthCubit>().signUp(nameCtrl.text, emailCtrl.text, passCtrl.text);
    } else {
      _emailController.reset();
    }
  }
}
