// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// import '../../common/constants/index.dart';
// import '../../core/constants/app_keys.dart';
// import '../../core/network/dio_helper.dart';
// import '../../utils/ui_utils.dart';
// import '../datasource/remote/exception/api_error_handler.dart';
// import '../model/base/api_response.dart';
//
// class AuthRepo {
//   AuthRepo({
//     required this.dioClient,
//     required this.googleSignIn,
//     required this.sharedPreferences,
//     required this.firebaseMessaging,
//   });
//
//   final DioClient dioClient;
//   final SharedPreferences sharedPreferences;
//   final GoogleSignIn googleSignIn;
//   final FirebaseMessaging firebaseMessaging;
//
//   Future<ApiResponse> registration(String name, String email, String password) async {
//     try {
//       final Response<dynamic> response = await dioClient.post(
//         AppStrings.registerUrl,
//         data: <String, String>{
//           'email': email,
//           'password': password,
//           'name': name,
//         },
//       );
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//     }
//   }
//
//   Future<ApiResponse> loginWithEmail(String email, String password) async {
//     printLog('signInWithEmail $email $password');
//     try {
//       final Response<dynamic> response = await dioClient.post(
//         AppStrings.loginWithEmailUrl,
//         data: <String, String>{'username': email, 'password': password},
//       );
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//     }
//   }
//
//   // Future<ApiResponse> loginWithPhone(String phoneNumber) async {
//   //   try {
//   //     final Response<dynamic> response = await dioClient.post(
//   //       AppStrings.loginWithPhoneUrl,
//   //       data: <String, String>{'phone': phoneNumber},
//   //     );
//   //     return ApiResponse.withSuccess(response);
//   //   } on DioException catch (e) {
//   //     return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//   //   }
//   // }
//   //
//   // Future<ApiResponse> verifyOTP(String phone, String otp) async {
//   //   try {
//   //     final Response<dynamic> response = await dioClient.post(
//   //       AppStrings.verifyOtpUrl,
//   //       data: <String, String>{'phone': phone, 'code': otp},
//   //     );
//   //     return ApiResponse.withSuccess(response);
//   //   } on DioException catch (e) {
//   //     return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//   //   }
//   // }
//
//   Future<Map<String, String>?> _googleSignInHelper() async {
//     try {
//       await removeGoogleAccessToken();
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//       final String userId = googleUser!.id;
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       if (Booleans.viewSocialToken) {
//         printLog('access token: ${googleAuth.accessToken}');
//         printLog('access token: ${googleAuth.idToken}');
//         printLog('user id: $userId');
//       }
//       return <String, String>{'accessToken': googleAuth.accessToken!, 'id': userId};
//     } catch (e) {
//       debugPrint(e.toString());
//       return null;
//     }
//   }
//
//   Future<void> removeGoogleAccessToken() async {
//     try {
//       await googleSignIn.isSignedIn().then((bool value) async {
//         if (value) {
//           await googleSignIn.disconnect();
//           await googleSignIn.currentUser?.clearAuthCache();
//           await googleSignIn.signOut();
//         }
//       });
//     } on DioException catch (e) {
//       printLog('googleAuth error $e');
//     }
//   }
//
//   Future<ApiResponse> signInWithGoogle() async {
//     final Map<String, String>? googleAuth = await _googleSignInHelper();
//     if (googleAuth == null) {
//       return ApiResponse.withError('Login with Google failed');
//     } else {
//       try {
//         final Response<dynamic> response = await dioClient.post(
//           AppStrings.loginWithGoogleUrl,
//           data: <String, String?>{'access_token': googleAuth['accessToken'], 'id': googleAuth['id']},
//         );
//         return ApiResponse.withSuccess(response);
//       } on DioException catch (e) {
//         return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//       }
//     }
//   }
//
//   Future<Map<String, String>?> _appleSignInHelper() async {
//     try {
//       final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
//         scopes: <AppleIDAuthorizationScopes>[
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );
//
//       if (Booleans.viewSocialToken) {
//         printLog('response $credential');
//         printLog('appleAuth ${credential.identityToken}');
//         printLog('userIdentifier ${credential.userIdentifier}');
//         printLog('givenName ${credential.givenName}');
//       }
//       return <String, String>{'accessToken': credential.identityToken!, 'id': credential.userIdentifier!};
//     } catch (e) {
//       printLog(e.toString());
//       return null;
//     }
//   }
//
//   Future<ApiResponse> signInWithApple() async {
//     final Map<String, String>? appleAuth = await _appleSignInHelper();
//
//     if (appleAuth == null) {
//       return ApiResponse.withError('Login with Apple failed');
//     } else {
//       try {
//         final Response<dynamic> response = await dioClient.post(
//           AppStrings.loginWithAppleUrl,
//           data: <String, String?>{
//             'access_token': appleAuth['accessToken'],
//             'id': appleAuth['id'],
//             'name': appleAuth['name'],
//           },
//         );
//         return ApiResponse.withSuccess(response);
//       } on DioException catch (e) {
//         return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//       }
//     }
//   }
//
//   // Future<String?> _facebookSignInHelper() async {
//   //   final FacebookAuth facebookAuth = FacebookAuth.instance;
//   //   try {
//   //     final LoginResult result = await facebookAuth.login();
//   //     if (result.status == LoginStatus.success) {
//   //       print('facebookAuth ${result.accessToken!.token}');
//   //       return result.accessToken!.token;
//   //     } else {
//   //       return null;
//   //     }
//   //   } catch (e) {
//   //     print('facebookAuth error $e');
//   //     return null;
//   //   }
//   // }
//
//   // Future<ApiResponse> signInWithFacebook() async {
//   //   String? accessToken = await _facebookSignInHelper();
//   //
//   //   if(accessToken == null) {
//   //     return ApiResponse.withError("Facebook login failed");
//   //   }else {
//   //     try {
//   //       Response response = await dioClient.post(AppStrings.loginWithFacebookUrl,
//   //         data: {"access_token": accessToken},
//   //       );
//   //       return ApiResponse.withSuccess(response);
//   //     }on DioException catch(e) {
//   //       return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//   //     }
//   //   }
//   // }
//
//   Future<void> saveUserToken(String token) async {
//     try {
//       dioClient.updateHeader(token);
//       await sharedPreferences.setString(AppKeys.token, token);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<ApiResponse> updateFcmToken() async {
//     try {
//       String deviceToken = '@';
//
//       if (defaultTargetPlatform == TargetPlatform.iOS) {
//         firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
//         final NotificationSettings settings = await firebaseMessaging.requestPermission();
//         if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//           deviceToken = await _saveDeviceToken();
//         }
//       } else {
//         deviceToken = await _saveDeviceToken();
//       }
//
//       if (!kIsWeb) {
//         firebaseMessaging.subscribeToTopic(AppKeys.topic);
//       }
//
//       final Response<dynamic> response = await dioClient.post(AppStrings.saveFcmToken, data: <String, String>{'fcm_id': deviceToken});
//       printLog('FCM ${response.statusMessage}');
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//     }
//   }
//
//   Future<String> _saveDeviceToken() async {
//     String? deviceToken = '@';
//     try {
//       deviceToken = await firebaseMessaging.getToken();
//     } catch (error) {
//       if (kDebugMode) {
//         printLog('error is: $error');
//       }
//     }
//     if (deviceToken != null) {
//       if (kDebugMode) {
//         printLog('Device Token ==> $deviceToken');
//       }
//     }
//     return deviceToken!;
//   }
//
//   // Future<String> getUserToken() async{
//   //   return await sharedPreferences.read(key:AppStrings.token) ?? "";
//   // }
//   //
//   // Future<bool> isLoggedIn() async{
//   //   return await sharedPreferences.containsKey(AppStrings.token);
//   // }
//
//   Future<bool> clearSharedData() async {
//     if (kDebugMode) {
//       printLog('clearSharedData');
//     }
//     return sharedPreferences.clear();
//   }
//
//   Future<ApiResponse> logout() async {
//     try {
//       final Response<dynamic> response = await dioClient.get(AppStrings.logoutUrl);
//       sharedPreferences.remove(AppKeys.token);
//       await removeGoogleAccessToken();
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//     }
//   }
//
//   Future<ApiResponse> removeAccount(String password) async {
//     try {
//       final Response<dynamic> response = await dioClient.post(AppStrings.removeAccount, data: <String, String>{
//         'password': password,
//       });
//       sharedPreferences.remove(AppKeys.token);
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//     }
//   }
//
//   // for  Remember Email
//   Future<void> saveUserNumberAndPassword(String number, String password) async {
//     try {
//       await sharedPreferences.setString(AppKeys.userPassword, password);
//       await sharedPreferences.setString(AppKeys.userEmail, number);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   String getUserEmail() {
//     return sharedPreferences.getString(AppKeys.userEmail) ?? '';
//   }
//
//   String getUserPassword() {
//     return sharedPreferences.getString(AppKeys.userPassword) ?? '';
//   }
//
//   Future<bool> clearUserNumberAndPassword() async {
//     await sharedPreferences.remove(AppKeys.userPassword);
//     return sharedPreferences.remove(AppKeys.userEmail);
//   }
//
//   Future<ApiResponse> sendResetEmail(String email) async {
//     try {
//       final Response<dynamic> response = await dioClient.post(
//         AppStrings.forgetPassword,
//         data: <String, String>{'email': email},
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//         ),
//       );
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//     }
//   }
//
//   Future<ApiResponse> checkConfirmCode(String email, String code) async {
//     try {
//       final Response<dynamic> response = await dioClient.post(
//         AppStrings.checkConfirmCode, data: <String, String>{'email': email, 'otp': code},
//         // options: Options(
//         //   contentType: Headers.formUrlEncodedContentType,
//         // ),
//       );
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//     }
//   }
//
//   Future<ApiResponse> resetPassword({
//     required String email,
//     required String code,
//     required String password,
//     required String passwordConfirmation,
//   }) async {
//     if (kDebugMode) {
//       printLog('email: $email otp: $code password: $password passwordConfirmation: $passwordConfirmation');
//     }
//     try {
//       final Response<dynamic> response = await dioClient.post(
//         AppStrings.resetPassword,
//         data: <String, String>{'email': email, 'otp': code, 'password': password, 'password_confirmation': passwordConfirmation},
//         options: Options(contentType: Headers.formUrlEncodedContentType),
//       );
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       // print('Error::: ${e}');
//       // print('Error:::::: ${ApiErrorHandler.getMessage(e)!}');
//       // print('Error:::::: ?? ${ApiResponse.withError(ApiErrorHandler.getMessage(e)!).error}');
//       // // return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//     }
//   }
//
//   // set user login
//   Future<void> setUserLogin() async {
//     await sharedPreferences.setBool(AppKeys.loggedInKey, true);
//     printLog('set user to login');
//   }
//
//   Future<void> setUserLogout() async {
//     await sharedPreferences.setBool(AppKeys.loggedInKey, false);
//     await removeGoogleAccessToken();
//     await sharedPreferences.remove(AppKeys.token);
//     printLog('set user to logout');
//   }
//
//   Future<bool> checkAuthStatus() async {
//     final bool isLoggedIn = sharedPreferences.getBool(AppKeys.loggedInKey) ?? false;
//     printLog('check user status is $isLoggedIn');
//     return isLoggedIn;
//   }
// }
