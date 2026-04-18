import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../helper/router_helper.dart';
import '../../../utils/ui_utils.dart';
import '../../base/index.dart';
import '../../base/rounded_loading_button.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordCtrl = TextEditingController();
  final RoundedLoadingButtonController _psswordController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const CloseButton(),
          title: Text('profile.delete_account.title'.tr()),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(height: 5.h),
          Padding(padding: const EdgeInsets.all(12.0), child: Text('profile.delete_account.description'.tr())),
          SizedBox(height: 5.h),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: formKey,
              child: InputField(
                hintText: 'profile.delete_account.password_hint'.tr(),
                controller: passwordCtrl,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'profile.delete_account.password_empty_error'.tr();
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 5.h),
          BlocConsumer<AuthCubit, AuthState>(listener: (BuildContext context, AuthState state) {
            if (state is AuthLoading) {
              _psswordController.start();
            }
            if (state is AuthError) {
              _psswordController.reset();
              showSnackBar(context, state.error, color: Colors.red);
            }
            if (state is RemoveAccountSuccess) {
              _psswordController.reset();
              Future<void>.delayed(const Duration(seconds: 1), () {
                RouterHelper.getDashboardRoute('home', action: RouteAction.pushNamedAndRemoveUntil);
              }).then((Object? value) async {
                await context.read<AuthCubit>().signOut();
                // await context.read<ProfileCubit>().getProfile();
              });
            }
            if (state is AuthError) {
              showSnackBar(context, state.error, color: Colors.red);
            }
          }, builder: (BuildContext context, AuthState state) {
            return RoundedButtonWidget(
              title: 'profile.delete_account.confirm'.tr(),
              controller: _psswordController,
              onPressed: () => _onSubmit(),
              color: Theme.of(context).primaryColor,
            );
          })
        ]),
      ),
    );
  }

  void _onSubmit() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthCubit>(context).removeAccount(/*password: passwordCtrl.text*/);
    } else {
      _psswordController.reset();
    }
  }
}
