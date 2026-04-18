import 'package:flutter/material.dart';

import '../../../utils/ui_utils.dart';

class SubscriptionPlanView extends StatefulWidget {
  const SubscriptionPlanView(
      {super.key,
      required this.isSelected,
      required this.title,
      required this.plan,
      required this.planSubTitle,
      required this.index,
      required this.onTap,
      this.isPlanDisable = false});

  final bool isSelected;
  final String title;
  final String plan;
  final String planSubTitle;
  final int index;
  final int Function(int) onTap;
  final bool isPlanDisable;

  @override
  State<SubscriptionPlanView> createState() => _SubscriptionPlanViewState();
}

class _SubscriptionPlanViewState extends State<SubscriptionPlanView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _subscriptionPlanView(widget.isSelected, widget.title, widget.plan, widget.planSubTitle, widget.index);
  }

  Widget _subscriptionPlanView(bool isSelected, String title, String plan, String planSubTitle, int index) => InkWell(
        onTap: widget.isPlanDisable
            ? () {
                showSnackBar(context, 'activeSubscription');
                // CommonUtils.displayToast(context, StringConstant.activeSubscription);
              }
            : () {
                _onPlanViewTap(index);
              },
        child: _circularPlanView(isSelected, title, index, plan),
      );

  void _onPlanViewTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTap(_selectedIndex);
  }

  Widget _circularPlanView(bool isSelected, String title, int index, String plan) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.red : Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _planUpperView(title, isSelected),
            _planCenterView(plan),
          ],
        ),
      );

  Widget _planUpperView(String title, bool isSelected) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ).copyWith(letterSpacing: 1),
          ),
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_off,
            color: isSelected ? Colors.red : Colors.grey,
          )
        ],
      );

  Widget _planCenterView(String plan) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          plan,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal),
        ),
      );
}
