import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  const PinCodeVerificationScreen({super.key, required this.onCompleted, required this.controller});

  final void Function(String) onCompleted;
  final TextEditingController controller;

  @override
  State<PinCodeVerificationScreen> createState() => _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  // TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  // StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    // errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 80,
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: PinCodeTextField(
            controller: widget.controller,
            appContext: context,
            // pastedTextStyle: TextStyle(
            //   color: Colors.green.shade600,
            //   fontWeight: FontWeight.bold,
            // ),
            length: 6,
            animationType: AnimationType.fade,
            validator: (String? v) {
              // if (v!.length < 3) {
              //   return "I'm from validator";
              // } else {
              return null;
              // }
            },
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              // fieldHeight: 50,
              // fieldWidth: 40,
              activeFillColor: Colors.grey.shade100,
              inactiveFillColor: Colors.grey.shade300,
              inactiveColor: Colors.grey,
              inactiveBorderWidth: .5,
              activeBorderWidth: .5
            ),
            cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            // errorAnimationController: errorController,
            // controller: textEditingController,
            keyboardType: TextInputType.number,
            // boxShadows: const [
            //   BoxShadow(
            //     offset: Offset(0, 1),
            //     color: Colors.black12,
            //     blurRadius: 10,
            //   )
            // ],
            onCompleted: (String v) {
              widget.onCompleted(v);
              debugPrint('Completed');
            },
            // onTap: () {
            //   print("Pressed");
            // },
            onChanged: (String value) {
              debugPrint(value);
              setState(() {
                currentText = value;
              });
            },
            // beforeTextPaste: (String? text) {
            //   debugPrint('Allowing to paste $text');
            //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
            //   return true;
            // },
          ),
        ),
      ),
    );
  }
}
