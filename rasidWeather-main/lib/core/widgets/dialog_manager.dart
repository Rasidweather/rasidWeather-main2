import 'package:flutter/material.dart';

import '../../../../core/services/dialog_service.dart';
import '../../data/model/base/dialog_models.dart';
import '../../locator.dart';

class DialogManager extends StatefulWidget {
  const DialogManager({super.key, required this.child});

  final Widget child;

  @override
  DialogManagerState createState() => DialogManagerState();
}

class DialogManagerState extends State<DialogManager> {
  final DialogService _dialogService = sl<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    final bool isConfirmationDialog = request.cancelTitle != null;
    showDialog<DialogRequest>(
        context: context,
        builder: (BuildContext context) {
          return request.widget != null
              ? AlertDialog(content: request.widget)
              : AlertDialog(title: Text(request.title!), content: Text(request.description!), actions: <Widget>[
                  if (isConfirmationDialog)
                    TextButton(
                        child: Text(request.cancelTitle!),
                        onPressed: () {
                          _dialogService.dialogComplete(
                            DialogResponse(confirmed: false),
                          );
                        }),
                  TextButton(
                      child: Text(request.buttonTitle!),
                      onPressed: () {
                        _dialogService.dialogComplete(
                          DialogResponse(confirmed: true),
                        );
                      }),
                ]);
        });
  }
}
