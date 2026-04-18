// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rasid_weather/bloc/notification_cubit/notification_cubit.dart';
//
// class NotificationWidget extends StatefulWidget {
//   const NotificationWidget({super.key});
//
//   @override
//   State<NotificationWidget> createState() => _NotificationWidgetState();
// }
//
// class _NotificationWidgetState extends State<NotificationWidget> {
//   bool status = false;
//
//   @override
//   void initState() {
//     context.read<NotificationCubit>().getNotificationAllowed();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NotificationCubit, NotificationState>(
//       builder: (BuildContext context, NotificationState state) {
//         final bool status = state is NotificationPermissionStatus ? state.isAllowed! : false;
//         return Column(
//           children: <Widget>[
//             SwitchListTile(
//               contentPadding: EdgeInsets.zero,
//               value: status,
//               onChanged: (bool value) {
//                 context.read<NotificationCubit>().setNotificationAllowed(value);
//               },
//               title: Text(
//                 'notifications',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xff3D3C3C),
//                 ),
//               ).tr(),
//             ),
//             ListTile(
//                 dense: true,
//                 visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
//                 title: Text(
//                   'notification_time',
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w400,
//                     color: const Color(0xff3D3C3C),
//                   ),
//                 ).tr(),
//                 trailing: Switch(
//                   value: status,
//                   onChanged: (bool value) {
//                     // context.read<NotificationCubit>().setNotificationAllowed(value);
//                   },
//                 ))
//           ],
//         );
//       },
//     );
//   }
// }
