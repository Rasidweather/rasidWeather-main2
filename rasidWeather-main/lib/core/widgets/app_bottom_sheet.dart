import 'package:flutter/material.dart';

Future<void> showBottomSheetWidget(BuildContext context,
    {required Widget child, bool isScrolled = true, bool enableDrag = true, bool wrap = false, double padding = 0.0}) {
  return showModalBottomSheet(
    context: context,
    enableDrag: enableDrag,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
    isScrollControlled: true, // Always true to handle keyboard properly
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: wrap
            ? Wrap(children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: child,
                  ),
                ),
              ])
            : AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                color: Colors.white,
                padding: EdgeInsets.only(
                  top: padding,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: child,
              ),
      );
    },
  );
}
