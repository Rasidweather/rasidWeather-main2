import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../common/constants/bools.dart';
import '../../../../common/constants/strings.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/network/ApiErrorHandler.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../data/model/base/api_response.dart';
import '../../../../data/model/user_model.dart';
import '../../domain/repositories/i_auth_repository.dart';

/// Implementation of the authentication repository
class AuthRepo implements IAuthRepository {
  /// Constructor for AuthRepo
  AuthRepo({
    required this.dioClient,
    required this.sharedPreferences,
    required this.googleSignIn,
    required this.firebaseMessaging,
  });

  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  final GoogleSignIn googleSignIn;
  final FirebaseMessaging firebaseMessaging;

  // MARK: - Base Repository Methods

  @override
  Future<void> create(UserModel item) async {
    await createAccount(item.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await removeAccount(id);
  }

  @override
  Future<List<UserModel>> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getById(String id) async {
    return null;
  }

  @override
  Future<void> update(UserModel item) {
    throw UnimplementedError();
  }

  // MARK: - Authentication Methods

  @override
  Future<ApiResponse> createAccount(Map<String, dynamic> params) async {
    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.registerUrl,
        data: params,
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return _handleDioError(e, 'حدث خطأ أثناء إنشاء الحساب');
    }
  }

  @override
  Future<ApiResponse> loginWithEmail(Map<String, String> params) async {
    try {
      if (kDebugMode) {
        final String url = '${dioClient.dio.options.baseUrl}${AppStrings.loginWithEmailUrl}';
        final String username = params['username'] ?? '';
        print(
          'AUTH_DEBUG request url=$url username=$username '
          'hasPassword=${(params['password'] ?? '').isNotEmpty}',
        );
      }
      final Response<dynamic> response = await dioClient.post(
        AppStrings.loginWithEmailUrl,
        data: params,
      );

      if (kDebugMode) {
        final dynamic data = response.data;
        final String keys = data is Map
            ? (data.keys.map((dynamic k) => k.toString()).toList()..sort())
                .join(',')
            : 'non-map';
        print('AUTH_DEBUG response status=${response.statusCode} keys=$keys');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic data = response.data;
        final Map<String, dynamic>? dataMap =
            data is Map<String, dynamic> ? data : null;
        final Map<String, dynamic>? bodyMap =
            dataMap?['body'] is Map<String, dynamic>
                ? dataMap!['body'] as Map<String, dynamic>
                : dataMap;
        final String? token = bodyMap?['token']?.toString();
        if (token != null) {
          await _saveAuthToken(token);
          await updateFcmToken();
        }
      }

      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.withError(
          'فشل الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت الخاص بك',
        );
      }

      if (e.response?.statusCode == 401) {
        return ApiResponse.withError(
          'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      }

      return _handleDioError(e, 'حدث خطأ أثناء تسجيل الدخول');
    }
  }

  @override
  Future<ApiResponse> loginWithGoogle() async {
    final Map<String, String>? googleAuth = await _googleSignInHelper();
    if (googleAuth == null) {
      return ApiResponse.withError('Login with Google failed');
    } else {
      try {
        final Response<dynamic> response = await dioClient.post(
          AppStrings.loginWithGoogleUrl,
          data: <String, String?>{
            'access_token': googleAuth['accessToken'],
            'id': googleAuth['id'],
          },
        );
        return ApiResponse.withSuccess(response);
      } on DioException catch (e) {
        return _handleDioError(e, 'حدث خطأ أثناء تسجيل الدخول بواسطة Google');
      }
    }
  }

  @override
  Future<ApiResponse> signInWithApple() async {
    final Map<String, String>? appleAuth = await _appleSignInHelper();

    if (appleAuth == null) {
      return ApiResponse.withError('Login with Apple failed');
    } else {
      try {
        final Response<dynamic> response = await dioClient.post(
          AppStrings.loginWithAppleUrl,
          data: <String, String?>{
            'access_token': appleAuth['accessToken'],
            'id': appleAuth['id'],
            'name': appleAuth['name'],
          },
        );
        return ApiResponse.withSuccess(response);
      } on DioException catch (e) {
        return _handleDioError(e, 'حدث خطأ أثناء تسجيل الدخول بواسطة Apple');
      }
    }
  }

  Future<UserModel?> loginWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<void> removeAccount(String id) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> logout() async {
    try {
      // Try to call the logout API endpoint
      final Response<dynamic> response = await dioClient.post(
        AppStrings.logoutUrl,
      );

      // Always clear user data locally, regardless of API response
      await _clearUserData();

      return ApiResponse.withSuccess(response);
    } catch (e) {
      // Always clear user data locally, even if the API call fails
      await _clearUserData();

      if (kDebugMode) {
        print('Logout error: $e');
      }

      // Return a success response even if the API call fails
      // since we've cleared the local data
      return ApiResponse.withSuccess(
        Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: <String, String>{'message': 'Logged out successfully'},
        ),
      );
    }
  }

  // MARK: - Password Reset Methods

  @override
  Future<ApiResponse> sendResetEmail(String email) async {
    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.forgetPassword,
        data: <String, String>{'email': email},
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return _handleDioError(
        e,
        'حدث خطأ أثناء إرسال رمز إعادة تعيين كلمة المرور',
      );
    }
  }

  @override
  Future<ApiResponse> checkConfirmCode(String email, String code) async {
    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.checkConfirmCode,
        data: <String, String>{'email': email, 'code': code},
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return _handleDioError(e, 'حدث خطأ أثناء التحقق من الرمز');
    }
  }

  @override
  Future<ApiResponse> resetPassword(
    String email,
    String otp,
    String password,
  ) async {
    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.resetPassword,
        data: <String, String>{'email': email, 'otp': otp, 'password': password, 'password_confirmation': password},
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return _handleDioError(e, 'حدث خطأ أثناء إعادة تعيين كلمة المرور');
    }
  }

  // MARK: - Token Management

  @override
  Future<bool> checkAuthStatus() async {
    final String? token = await getToken();
    if (token == null) return false;

    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.profileUrl);
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Auth status check error: $e');
      }
      return false;
    }
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(AppKeys.token);
  }

  @override
  Future<void> saveUserToken(String token) async {
    await sharedPreferences.setString(AppKeys.token, token);
    dioClient.updateHeader(token: token);
    if (kDebugMode) {
      print('AUTH_DEBUG saved token length=${token.length}');
    }
  }

  @override
  Future<void> setUserLogin() async {
    await sharedPreferences.setBool(AppKeys.loggedInKey, true);
    if (kDebugMode) {
      print('AUTH_DEBUG saved loggedInKey=true');
    }
  }

  @override
  Future<bool> getUserLogin() async {
    final bool value = sharedPreferences.getBool(AppKeys.loggedInKey) ?? false;
    if (kDebugMode) {
      print('AUTH_DEBUG read loggedInKey=$value');
    }
    return value;
  }

  @override
  Future<void> setUserLogout() async {
    await sharedPreferences.setBool(AppKeys.loggedInKey, false);
    await _clearUserData();
  }

  @override
  Future<void> removeGoogleAccessToken() async {
    await sharedPreferences.remove('google_access_token');
  }

  Future<void> clearAuthData() async {
    await _clearUserData();
  }

  // MARK: - FCM Token Management

  @override
  Future<ApiResponse> updateFcmToken() async {
    try {
      String deviceToken = '@';

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        final NotificationSettings settings =
        await firebaseMessaging.requestPermission();

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          // ✅ جيب FCM token
          deviceToken = await _saveDeviceToken();

          // ✅ تأكد إن APNS token جاهز قبل التوبيك
          try {
            final String? apns = await firebaseMessaging.getAPNSToken();
            if (kDebugMode) {
              printLog('APNS Token ==> $apns');
            }
          } catch (e) {
            // مش قاتل.. بس خليه واضح باللوغ
            if (kDebugMode) {
              printLog('getAPNSToken failed: $e');
            }
          }
        }
      } else {
        // Android وغيره
        deviceToken = await _saveDeviceToken();
      }

      // ✅ اشترك بالتوبيك (مع await)
      if (!kIsWeb) {
        try {
          await firebaseMessaging.subscribeToTopic(AppKeys.topic);
        } catch (e) {
          // لا تخرب تسجيل الدخول لو فشل التوبيك
          if (kDebugMode) {
            printLog('subscribeToTopic failed: $e');
          }
        }
      }

      // ✅ ابعت التوكن للباك اند زي ما هو
      final Response<dynamic> response = await dioClient.post(
        AppStrings.saveFcmToken,
        data: <String, String>{'fcm_id': deviceToken},
      );

      printLog('FCM ${response.statusMessage}');
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return _handleDioError(e, 'حدث خطأ أثناء تحديث رمز الإشعارات');
    }
  }

  // MARK: - Private Helper Methods

  /// Save authentication token and update headers
  Future<void> _saveAuthToken(String token) async {
    await sharedPreferences.setString(AppKeys.token, token);
    dioClient.updateHeader(token: token);
  }

  /// Clear user data from shared preferences
  Future<void> _clearUserData() async {
    // Clear token and update Dio headers
    await sharedPreferences.remove(AppKeys.token);
    dioClient.updateHeader();

    // Clear login status
    await sharedPreferences.remove(AppKeys.loggedInKey);

    // Clear user information
    await sharedPreferences.remove('user_id');
    await sharedPreferences.remove('user_email');
    await sharedPreferences.remove('user_name');

    // Clear social login tokens
    await removeGoogleAccessToken();

    // Reset VIP status properly
    await AppStrings.clearVip();
  }


  /// Handle Google sign-in process
  Future<Map<String, String>?> _googleSignInHelper() async {
    try {
      await removeGoogleAccessToken();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final String userId = googleUser!.id;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (Booleans.viewSocialToken) {
        printLog('access token: ${googleAuth.accessToken}');
        printLog('access token: ${googleAuth.idToken}');
        printLog('user id: $userId');
      }
      return <String, String>{
        'accessToken': googleAuth.accessToken!,
        'id': userId,
      };
    } catch (e) {
      printLog(e.toString());
      return null;
    }
  }

  /// Handle Apple sign-in process
  Future<Map<String, String>?> _appleSignInHelper() async {
    try {
      final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (Booleans.viewSocialToken) {
        printLog('response $credential');
        printLog('appleAuth ${credential.identityToken}');
        printLog('userIdentifier ${credential.userIdentifier}');
        printLog('givenName ${credential.givenName}');
      }
      return <String, String>{
        'accessToken': credential.identityToken!,
        'id': credential.userIdentifier!,
      };
    } catch (e) {
      printLog(e.toString());
      return null;
    }
  }

  /// Save device token for push notifications
  Future<String> _saveDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await firebaseMessaging.getToken();
    } catch (error) {
      if (kDebugMode) {
        printLog('error is: $error');
      }
    }
    if (deviceToken != null) {
      if (kDebugMode) {
        printLog('Device Token ==> $deviceToken');
      }
    }
    return deviceToken!;
  }

  /// Handle Dio errors with default fallback message
  ApiResponse _handleDioError(DioException e, String fallbackMessage) {
    final String errorMessage = ApiErrorHandler.getMessage(e) ?? fallbackMessage;
    return ApiResponse.withError(errorMessage);
  }
}
