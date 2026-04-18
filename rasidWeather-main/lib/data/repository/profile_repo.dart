import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../common/constants/index.dart';
import '../../core/constants/app_keys.dart';
import '../../core/network/dio_helper.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base/api_response.dart';
import '../model/plan_model.dart';
import '../model/user_model.dart';

class ProfileRepo {
  ProfileRepo({
    required this.sharedPreferences,
    required this.dioClient,
    required this.googleSignIn,
  });

  final DioClient dioClient;
  final GoogleSignIn googleSignIn;
  final SharedPreferences sharedPreferences;

  Future<ApiResponse> getProfile() async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.profileUrl);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> getPlan() async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.subscriptionPlansUrl);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> getSubscriptionHistory() async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.subscriptionHistoryUrl);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> updateProfile(Map<String, dynamic> data) async {
    try {
      final Response<dynamic> response = await dioClient.post(AppStrings.updateProfile, data: data);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> completeProfile(Map<String, dynamic> data) async {
    try {
      final Response<dynamic> response = await dioClient.post(AppStrings.completeProfile, data: data);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> linkPhoneNumber(String phone) async {
    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.linkPhoneNumber,
        data: <String, String>{'phone': phone},
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> verifyPhoneNumber(String phone, String otp) async {
    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.verifyPhoneNumber,
        data: <String, String>{'phone': phone, 'code': otp},
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<String?> _getGoogleAccessToken() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      return googleAuth.accessToken;
    } catch (_) {
      return null;
    }
  }

  Future<ApiResponse> linkGoogleAccount() async {
    final String? accessToken = await _getGoogleAccessToken();

    if (accessToken == null) {
      return ApiResponse.withError('Google login failed');
    }

    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.linkGoogleAccount,
        data: <String, String>{'access_token': accessToken},
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<Map<String, String>?> _appleSignInHelper() async {
    try {
      final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      return <String, String>{
        'accessToken': credential.identityToken!,
        'id': credential.userIdentifier!,
      };
    } catch (_) {
      return null;
    }
  }

  Future<ApiResponse> linkAppleAccount() async {
    final Map<String, String>? appleAuth = await _appleSignInHelper();

    if (appleAuth == null) {
      return ApiResponse.withError('Apple login failed');
    }

    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.linkAppleAccount,
        data: <String, String?>{'access_token': appleAuth['accessToken']},
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> disLinkSocialAccount(String socialId) async {
    try {
      final Response<dynamic> response = await dioClient.delete(AppStrings.disLinkSocialAccount + socialId);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> changePassword(String lastPassword, String newPassword) async {
    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.changePassword,
        data: <String, String>{
          'old_password': lastPassword,
          'password': newPassword,
        },
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> changeEmail(String newEmail, String password) async {
    try {
      final Response<dynamic> response = await dioClient.post(
        AppStrings.changeEmail,
        data: <String, String>{
          'email': newEmail,
          'password': password,
        },
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> saveFcmToken(String token) async {
    try {
      // ملاحظة: عندك كان حاطط changeEmail بالغلط.
      // إذا عندك endpoint خاص للتوكن استخدمه (مثلاً AppStrings.saveFcmToken)
      final Response<dynamic> response = await dioClient.post(
        AppStrings.saveFcmToken,
        data: <String, String>{'fcm_id': token},
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> getProfileDetails(String params) async {
    try {
      final Response<dynamic> response = await dioClient.get('${AppStrings.getProfileDetailsUrl}/$params');
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<UserModel?> currentUser() async {
    final String? savedDecoded = sharedPreferences.getString(AppKeys.currentUser);
    if (savedDecoded != null) {
      return UserModel.decode(savedDecoded);
    }
    return null;
  }

  Future<void> saveCurrentUser(UserModel user) async {
    await sharedPreferences.setString(AppKeys.currentUser, user.encode());
  }

  Future<List<PlanModel>> getPlans() async {
    final String? savedDecoded = sharedPreferences.getString(AppKeys.plans);
    if (savedDecoded != null) {
      final List<dynamic> body = json.decode(savedDecoded)['body'] as List<dynamic>;
      final List<PlanModel> plans = body.map((dynamic item) => PlanModel.decode(item as String)).toList();
      return plans;
    }
    return <PlanModel>[];
  }

  Future<void> savePlans(List<PlanModel> plans) async {
    final String jsonStr = jsonEncode(plans.map((PlanModel plan) => plan.toJson()).toList());
    await sharedPreferences.setString(AppKeys.plans, jsonStr);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool(AppKeys.loggedInKey) ?? false;
  }

  /// ✅ هذا المطلوب: قراءة اشتراك المستخدم (لوحة التحكم أو شراء) + طباعة
  Future<ApiResponse> getMySubscriptionInfo() async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.mySubscriptionUrl);

      // Logs واضحة
      print('🟦 /subscription/info STATUS: ${response.statusCode}');
      print('🟦 /subscription/info DATA: ${response.data}');

      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      final String msg = ApiErrorHandler.getMessage(e) ?? 'Unknown error';
      print('❌ /subscription/info ERROR: $msg');
      return ApiResponse.withError(msg);
    }
  }
}
