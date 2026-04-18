// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../main_2.dart';
//
//
// enum RouteAction { push, pushReplacement, popAndPush, pushNamedAndRemoveUntil }
//
// class RouterHelper {
//   static const String splashScreen = '/splash';
//   static const String loginScreen = '/login';
//   static const String dashboard = '/';
//   static const String maintain = '/maintain';
//
//   static const String homeScreen = '/home';
//
//   static const String realEstateFormScreen = '/real-estate-form';
//   static const String rentalContractFormScreen = '/rental-contract-form';
//   static const String generalExpenseFormScreen = '/general-expense-form';
//   static const String financeFormScreen = '/finance-form';
//   static const String employeeFormScreen = '/employee-form';
//   static const String userFormScreen = '/user-form';
//   static const String carFormScreen = '/car-form';
//   static const String maintenanceFormScreen = '/maintenance-form';
//   static const String bankFinanceFormScreen = '/bank-finance-form';
//
// /*  static String getCarForm({
//     RouteAction? action,
//     Car? car,
//     VoidCallback? onSubmitted,
//   }) {
//     String path = carFormScreen;
//     if (car != null) {
//       final jsonStr = jsonEncode(car.toJson());
//       final encodedData = base64Encode(utf8.encode(jsonStr));
//       path = '$path?car=$encodedData';
//     }
//     return _navigateRoute(path, route: action, extra: onSubmitted);
//   }*/
//
// /*
//   static String getBankFinanceForm({
//     RouteAction? action,
//     BankDetailsResponse? bank,
//     VoidCallback? onSubmitted,
//   }) {
//     String path = bankFinanceFormScreen;
//     if (bank != null) {
//       final jsonStr = jsonEncode(bank.toJson());
//       final encodedData = base64Encode(utf8.encode(jsonStr));
//       path = '$path?bank=$encodedData';
//     }
//     return _navigateRoute(path, route: action, extra: onSubmitted);
//   }*/
// /*
//   static String getMaintenanceForm({
//     RouteAction? action,
//     MaintenanceRecord? maintenance,
//     VoidCallback? onSubmitted,
//   }) {
//     String path = maintenanceFormScreen;
//     try {
//       if (maintenance != null) {
//         final jsonStr = jsonEncode(maintenance.toJson());
//         final encodedData = base64Encode(utf8.encode(jsonStr));
//         path = '$path?maintenance=$encodedData';
//       }
//     } catch (e) {
//       debugPrint('Error encoding maintenance data: $e');
//     }
//     return _navigateRoute(path, route: action, extra: onSubmitted);
//   }*/
//
// /*
//   static String getRealEstateForm({
//     RouteAction? action,
//     RealEstateDetails? realEstate,
//     VoidCallback? onSubmitted,
//   }) {
//     String path = realEstateFormScreen;
//     if (realEstate != null) {
//       final jsonStr = jsonEncode(realEstate.toJson());
//       final encodedData = base64Encode(utf8.encode(jsonStr));
//       path = '$path?realEstate=$encodedData';
//     }
//     return _navigateRoute(path, route: action, extra: onSubmitted);
//   }*/
//
//  /* static String getGeneralExpensesRoute({
//     RouteAction? action,
//     GeneralExpense? expense,
//     VoidCallback? onSubmitted,
//   }) {
//     String path = generalExpenseFormScreen;
//     if (expense != null) {
//       final jsonStr = jsonEncode(expense.toJson());
//       final encodedData = base64Encode(utf8.encode(jsonStr));
//       path = '$path?expense=$encodedData';
//     }
//     return _navigateRoute(path, route: action);
//   }*/
//
// /*  static String getRentalContractForm({
//     RouteAction? action,
//     RentalContractDetails? contract,
//     VoidCallback? onSubmitted,
//   }) {
//     String path = rentalContractFormScreen;
//     if (contract != null) {
//       final jsonStr = jsonEncode(contract.toJson());
//       final encodedData = base64Encode(utf8.encode(jsonStr));
//       path = '$path?contract=$encodedData';
//     }
//     return _navigateRoute(path, route: action, extra: onSubmitted);
//   }*/
//
//   /*static String getFinanceFormRoute({
//     RouteAction? action,
//     Expense? expense,
//     String? projectId,
//     required ExpenseType expenseType,
//   }) {
//     String path = financeFormScreen;
//     if (expense != null) {
//       final jsonStr = jsonEncode(expense.toJson());
//       final encodedData = base64Encode(utf8.encode(jsonStr));
//       path = '$path?expense=$encodedData&expenseType=${expenseType.name}&projectId=${expense.project.toString()}';
//     } else {
//       path = '$path?expenseType=${expenseType.name}&projectId=$projectId';
//     }
//     return _navigateRoute(path, route: action);
//   }*/
//
// /*
//   static String getEmployeeFormRoute({
//     RouteAction? action,
//     Employee? employee,
//     VoidCallback? onSubmitted,
//   }) {
//     String path = employeeFormScreen;
//     if (employee != null) {
//       final jsonStr = jsonEncode(employee.toJson());
//       final encodedData = base64Encode(utf8.encode(jsonStr));
//       path = '$path?employee=$encodedData';
//     }
//     return _navigateRoute(path, route: action, extra: onSubmitted);
//   }
// */
//
// /*  static String getUserFormRoute({
//     RouteAction? action,
//     User? user,
//     VoidCallback? onSubmitted,
//   }) {
//     String path = userFormScreen;
//     if (user != null) {
//       final jsonStr = jsonEncode(user.toJson());
//       final encodedData = base64Encode(utf8.encode(jsonStr));
//       path = '$path?user=$encodedData';
//     }
//     return _navigateRoute(path, route: action, extra: onSubmitted);
//   }*/
//
//   static String getSplashRoute({RouteAction? action}) => _navigateRoute(splashScreen, route: action);
//
//   static String getLoginRoute({RouteAction? action}) => _navigateRoute(loginScreen, route: action);
//
//   static String getMainRoute({RouteAction? action}) => _navigateRoute(homeScreen, route: action);
//
//   static String getMaintainRoute({RouteAction? action}) => _navigateRoute(maintain, route: RouteAction.pushReplacement);
//
//   static String getDashboardRoute(String page, {RouteAction? action}) => _navigateRoute('$homeScreen?page=$page', route: action);
//
//   static String _navigateRoute(String path, {RouteAction? route = RouteAction.push, dynamic extra}) {
//     if (route == RouteAction.pushNamedAndRemoveUntil) {
//       Get.context?.go(path);
//     } else if (route == RouteAction.pushReplacement) {
//       Get.context?.pushReplacement(path);
//     } else {
//       Get.context?.push(path, extra: extra);
//     }
//     return path;
//   }
//
//   static Widget _routeHandler(BuildContext context, Widget route) {
//     // if (Provider.of<SplashCubit>(context, listen: false).maintenanceMode) {
//     //   return const MaintenanceScreen();
//     // }
//     return route;
//   }
//
//   static final GoRouter goRoutes = GoRouter(
//     navigatorKey: navigatorKey,
//     initialLocation: getSplashRoute(),
//     errorBuilder: (BuildContext ctx, _) =>  Container(),
//     routes: <RouteBase>[
//  /*     GoRoute(
//           path: realEstateFormScreen,
//           builder: (BuildContext context, GoRouterState state) {
//             RealEstateDetails? model;
//             final realEstateParam = state.uri.queryParameters['realEstate'];
//             if (realEstateParam != null) {
//               try {
//                 final decodedBytes = base64Decode(realEstateParam);
//                 final jsonStr = utf8.decode(decodedBytes);
//                 final Map<String, dynamic> realEstate = jsonDecode(jsonStr) as Map<String, dynamic>;
//                 model = RealEstateDetails.fromJson(realEstate);
//               } catch (e) {
//                 print('Error decoding real estate data: $e');
//               }
//             }
//             return RealEstateFormWidget(
//               realEstate: model,
//               onSubmitted: () {
//                 if (state.extra is VoidCallback) {
//                   (state.extra as VoidCallback).call();
//                 }
//               },
//             );
//           }),*/
// /*      GoRoute(
//           path: carFormScreen,
//           builder: (BuildContext context, GoRouterState state) {
//             Car? model;
//             final realEstateParam = state.uri.queryParameters['car'];
//             if (realEstateParam != null) {
//               try {
//                 final decodedBytes = base64Decode(realEstateParam);
//                 final jsonStr = utf8.decode(decodedBytes);
//                 final Map<String, dynamic> realEstate = jsonDecode(jsonStr) as Map<String, dynamic>;
//                 model = Car.fromJson(realEstate);
//               } catch (e) {
//                 print('Error decoding real estate data: $e');
//               }
//             }
//             return CarFormWidget(
//               car: model,
//               onSubmitted: () {
//                 if (state.extra is VoidCallback) {
//                   (state.extra as VoidCallback).call();
//                 }
//               },
//             );
//           }),*/
// /*      GoRoute(
//           path: bankFinanceFormScreen,
//           builder: (BuildContext context, GoRouterState state) {
//             BankDetailsResponse? model;
//             final bankParam = state.uri.queryParameters['bank'];
//             if (bankParam != null) {
//               try {
//                 final decodedBytes = base64Decode(bankParam);
//                 final jsonStr = utf8.decode(decodedBytes);
//                 final Map<String, dynamic> realEstate = jsonDecode(jsonStr) as Map<String, dynamic>;
//                 model = BankDetailsResponse.fromJson(realEstate);
//               } catch (e) {
//                 print('Error decoding real estate data: $e');
//               }
//             }
//             return BankFinancingFormWidget(bankFinancing: model);
//           }),*/
// /*      GoRoute(
//           path: maintenanceFormScreen,
//           builder: (BuildContext context, GoRouterState state) {
//             MaintenanceRecord? model;
//             final maintenance = state.uri.queryParameters['maintenance'];
//             if (maintenance != null) {
//               try {
//                 final decodedBytes = base64Decode(maintenance);
//                 final jsonStr = utf8.decode(decodedBytes);
//                 final Map<String, dynamic> _maintenance = jsonDecode(jsonStr) as Map<String, dynamic>;
//                 model = MaintenanceRecord.fromJson(_maintenance);
//               } catch (e) {
//                 print('Error decoding real estate data: $e');
//               }
//             }
//             return MaintenanceForm(
//               maintenance: model,
//               onSubmitted: () {
//                 if (state.extra is VoidCallback) {
//                   (state.extra as VoidCallback).call();
//                 }
//               },
//             );
//           }),*/
//    /*   GoRoute(
//           path: generalExpenseFormScreen,
//           builder: (BuildContext context, GoRouterState state) {
//             GeneralExpense? model;
//             final generalEstateParam = state.uri.queryParameters['expense'];
//             if (generalEstateParam != null) {
//               try {
//                 final decodedBytes = base64Decode(generalEstateParam);
//                 final jsonStr = utf8.decode(decodedBytes);
//                 final Map<String, dynamic> generalExpense = jsonDecode(jsonStr) as Map<String, dynamic>;
//                 model = GeneralExpense.fromJson(generalExpense);
//               } catch (e) {
//                 print('Error decoding real estate data: $e');
//               }
//             }
//             return GeneralExpensesFormWidget(expense: model);
//           }),*/
// /*      GoRoute(
//           path: rentalContractFormScreen,
//           builder: (BuildContext context, GoRouterState state) {
//             RentalContractDetails? model;
//             final contractParam = state.uri.queryParameters['contract'];
//             if (contractParam != null) {
//               try {
//                 final decodedBytes = base64Decode(contractParam);
//                 final jsonStr = utf8.decode(decodedBytes);
//                 final Map<String, dynamic> contract = jsonDecode(jsonStr) as Map<String, dynamic>;
//                 model = RentalContractDetails.fromJson(contract);
//               } catch (e) {
//                 print('Error decoding contract data: $e');
//               }
//             }
//             return RentalContractForm(
//                 contract: model,
//                 onSubmitted: () {
//                   if (state.extra is VoidCallback) {
//                     (state.extra as VoidCallback).call();
//                   }
//                 });
//           }),*/
// /*      GoRoute(
//           path: financeFormScreen,
//           builder: (BuildContext context, GoRouterState state) {
//             Expense? model;
//             final String projectId = state.uri.queryParameters['projectId'].toString();
//             final expenseParam = state.uri.queryParameters['expense'];
//             final expenseTypeParam = state.uri.queryParameters['expenseType'];
//             if (expenseParam != null) {
//               try {
//                 final decodedBytes = base64Decode(expenseParam);
//                 final jsonStr = utf8.decode(decodedBytes);
//                 final Map<String, dynamic> expense = jsonDecode(jsonStr) as Map<String, dynamic>;
//                 model = Expense.fromJson(expense);
//               } catch (e) {
//                 print('Error decoding expense data: $e');
//               }
//             }
//             return FinanceFormWidget(
//               expense: model,
//               projectId: projectId,
//               expenseType: ExpenseType.values.byName(expenseTypeParam!),
//             );
//           }),*/
// /*      GoRoute(
//           path: employeeFormScreen,
//           builder: (BuildContext context, GoRouterState state) {
//             Employee? model;
//             final employeeParam = state.uri.queryParameters['employee'];
//             if (employeeParam != null) {
//               try {
//                 final decodedBytes = base64Decode(employeeParam);
//                 final jsonStr = utf8.decode(decodedBytes);
//                 final Map<String, dynamic> employee = jsonDecode(jsonStr) as Map<String, dynamic>;
//                 model = Employee.fromJson(employee);
//               } catch (e) {
//                 print('Error decoding employee data: $e');
//               }
//             }
//             return EmployeeFormWidget(employee: model);
//           }),*/
//       // GoRoute(
//       //     path: userFormScreen,
//       //     builder: (BuildContext context, GoRouterState state) {
//       //       User? model;
//       //       final userParam = state.uri.queryParameters['user'];
//       //       if (userParam != null) {
//       //         try {
//       //           final decodedBytes = base64Decode(userParam);
//       //           final jsonStr = utf8.decode(decodedBytes);
//       //           final Map<String, dynamic> user = jsonDecode(jsonStr) as Map<String, dynamic>;
//       //           model = User.fromJson(user);
//       //         } catch (e) {
//       //           print('Error decoding user data: $e');
//       //         }
//       //       }
//       //       return UserFormWidget(user: model);
//       //     }),
// /*
//       GoRoute(path: homeScreen, builder: (BuildContext context, GoRouterState state) => const DashBoard()),
// */
// /*
//       GoRoute(path: splashScreen, builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
// */
// /*
//       GoRoute(path: loginScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const LoginScreen())),
// */
//     ],
//   );
// }
