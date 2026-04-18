import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../data/model/base/dialog_models.dart';

class DialogService {
  final GlobalKey<NavigatorState> _dialogNavigationKey = GlobalKey<NavigatorState>();
  // ignore: inference_failure_on_function_return_type
  late Function(DialogRequest) _showDialogListener;
  late Completer<DialogResponse> _dialogCompleter;

  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;

  /// Registers a callback function. Typically to show the dialog
  // ignore: inference_failure_on_function_return_type, use_setters_to_change_properties
  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future<DialogResponse> showDialog({
    required String title,
    required String description,
    String buttonTitle = 'Ok',
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
      title: title,
      description: description,
      buttonTitle: buttonTitle,
    ));
    return _dialogCompleter.future;
  }

  /// Shows a confirmation dialog
  Future<DialogResponse> showConfirmationDialog(
      {required String title, required String description, String confirmationTitle = 'Ok', String cancelTitle = 'Cancel'}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(title: title, description: description, buttonTitle: confirmationTitle, cancelTitle: cancelTitle));
    return _dialogCompleter.future;
  }

  /// Shows a widget
  Future<DialogResponse> showWidget({required Widget widget}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(widget: widget));
    return _dialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(DialogResponse response) {
    _dialogNavigationKey.currentState!.pop();
    _dialogCompleter.complete(response);
    // _dialogCompleter = null;
  }
}
