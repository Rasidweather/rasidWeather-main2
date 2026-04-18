import 'package:flutter/material.dart';

class DialogRequest {
  DialogRequest({this.title, this.description, this.buttonTitle, this.cancelTitle, this.widget});
  final String? title;
  final String? description;
  final String? buttonTitle;
  final String? cancelTitle;
  final Widget? widget;
}

class DialogResponse {
  DialogResponse({
    this.fieldOne,
    this.fieldTwo,
    this.confirmed,
  });
  final String? fieldOne;
  final String? fieldTwo;
  final bool? confirmed;
}
