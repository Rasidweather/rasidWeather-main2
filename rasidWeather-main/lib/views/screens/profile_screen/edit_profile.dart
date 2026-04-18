import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../data/model/user_model.dart';
import '../../../utils/ui_utils.dart';
import '../../base/input_field_widget.dart';
import '../../base/rounded_button_widget.dart';
import '../../base/rounded_loading_button.dart';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({super.key, required this.user});
  final UserModel user;

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  File? imageFile;
  String? fileName;
  bool loading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameCtrl = TextEditingController();

  Future<void> pickImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? imagepicked = await imagePicker.pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
      if (imagepicked != null) {
        setState(() {
          imageFile = File(imagepicked.path);
          fileName = imageFile!.path;
        });
      } else {
        printLog('No image selected!');
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  final RoundedLoadingButtonController controller = RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.user.userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile.edit_profile'.tr()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              InkWell(
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.grey[800]!),
                      color: Colors.grey[500],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageFile == null ? NetworkImage(widget.user.avatar!.original!) : FileImage(imageFile!) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.edit,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  pickImage();
                },
              ),
              const SizedBox(height: 16),
              InputField(
                hintText: 'profile.name'.tr(),
                controller: nameCtrl,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'common.required_field'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              BlocConsumer<ProfileCubit, ProfileState>(
                listener: (BuildContext context, ProfileState state) {
                  if (state is ProfileSuccess) {
                    controller.success();
                    // navigate after 2 second
                    Future<void>.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  }
                  if (state is ProfileError) {
                    controller.reset();
                    showSnackBar(context, state.error, color: Colors.red);
                  }
                  if (state is ProfileLoading) {
                    controller.start();
                  }
                },
                builder: (BuildContext context, ProfileState state) {
                  return RoundedButtonWidget(
                    title: 'profile.save'.tr(),
                    controller: controller,
                    onPressed: () => _updateProfile(),
                    color: Theme.of(context).primaryColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() {
    Map<String, dynamic> data = <String, dynamic>{};

    if (imageFile != null) {
      final List<int> imageBytes = imageFile!.readAsBytesSync();
      final String base64Image = base64Encode(imageBytes);
      data = <String, dynamic>{'avatar': base64Image};
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      data.addAll(<String, dynamic>{'name': nameCtrl.text});
      context.read<ProfileCubit>().updateProfile(data);
    } else {
      controller.reset();
    }
  }
}
