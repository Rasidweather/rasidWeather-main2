import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/strings.dart';
import '../../../../data/model/base/api_response.dart';
import '../../../../subscriptions/revenuecat_identity.dart';
import '../../data/models/login_model.dart';
import '../../domain/repositories/i_auth_repository.dart';

part 'auth_state.dart';

/// Enum representing different login methods
enum LoginType {
  /// Email and password login
  email,

  /// Google OAuth login
  google,

  /// Apple Sign In
  apple,
}

/// Manages authentication state and operations
class AuthCubit extends Cubit<AuthState> {
  /// Creates a new AuthCubit instance
  AuthCubit(this.authRepo) : super(AuthInitial());

  /// Repository for authentication operations
  final IAuthRepository authRepo;

  /// Checks if the user is authenticated
  /// Returns true if authenticated, false otherwise
  Future<bool> checkAuthenticationStatus() async {
    try {
      final bool isAuthenticated = await authRepo.checkAuthStatus();
      emit(isAuthenticated ? AuthenticatedState() : UnauthenticatedState());
      return isAuthenticated;
    } catch (e) {
      if (kDebugMode) {
        print('Auth status check error: $e');
      }
      emit(UnauthenticatedState());
      return false;
    }
  }

  /// Handles user registration
  ///
  /// Parameters:
  /// - [name]: User's full name
  /// - [email]: User's email address
  /// - [password]: User's password
  Future<void> signUp(String name, String email, String password) async {
    emit(AuthLoading('auth.signup.loading'.tr()));

    final Map<String, String> params = <String, String>{
      'name': name,
      'email': email,
      'password': password,
    };

    try {
      final ApiResponse apiResponse = await authRepo.createAccount(params);
      _handleApiResponse(
        apiResponse,
        onSuccess: () =>
            emit(RegisterSuccess(message: 'auth.signup.success'.tr())),
        onError: (String error) => emit(AuthError(error)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Sign up error: $e');
      }
      emit(AuthError('common.unknown_error'.tr()));
    }
  }

  /// Handles email-based authentication
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password
  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthEmailLoading('auth.login.loading'.tr()));

    try {
      if (kDebugMode) {
        print(
          'AUTH_DEBUG login payload: username=$email '
          'hasPassword=${password.isNotEmpty}',
        );
      }
      final Map<String, String> params = <String, String>{
        'username': email,
        'password': password,
      };

      final ApiResponse loginResponse = await authRepo.loginWithEmail(params);

      if (kDebugMode) {
        final dynamic data = loginResponse.response?.data;
        final String keys = data is Map
            ? (data.keys.map((dynamic k) => k.toString()).toList()..sort())
                  .join(',')
            : 'non-map';
        print(
          'AUTH_DEBUG login status=${loginResponse.response?.statusCode} '
          'keys=$keys',
        );
      }
      await _processLoginResponse(loginResponse, loginType: LoginType.email);
    } catch (e) {
      if (kDebugMode) {
        print('Email sign in error: $e');
      }
      emit(AuthError('common.unknown_error'.tr()));
    }
  }

  /// Handles Google-based authentication
  Future<void> signInWithGoogle() async {
    emit(GoogleLoading('auth.login.google_loading'.tr()));

    try {
      final ApiResponse loginResponse = await authRepo.loginWithGoogle();
      print(
        'GOOGLE loginResponse.response?.statusCode = ${loginResponse.response?.statusCode}',
      );
      print(
        'GOOGLE loginResponse.response?.data = ${loginResponse.response?.data}',
      );
      print('GOOGLE loginResponse.error = ${loginResponse.error}');
      await _processLoginResponse(loginResponse, loginType: LoginType.google);
    } catch (e) {
      if (kDebugMode) {
        print('Google sign in error: $e');
      }
      emit(GoogleAuthError('auth.login.google_error'.tr()));
    }
  }

  /// Handles Apple-based authentication
  Future<void> signInWithApple() async {
    emit(AppleLoading('auth.login.apple_loading'.tr()));

    try {
      final ApiResponse loginResponse = await authRepo.signInWithApple();
      await _processLoginResponse(loginResponse, loginType: LoginType.apple);
    } catch (e) {
      if (kDebugMode) {
        print('Apple sign in error: $e');
      }
      emit(AppleAuthError('auth.login.apple_error'.tr()));
    }
  }

  /// Handles user sign out
  ///
  /// This method will:
  /// 1. Attempt to call the server logout API
  /// 2. Clear all local user data regardless of API response
  /// 3. Update the authentication state to unauthenticated
  Future<void> signOut() async {
    emit(AuthLoading('auth.logout.loading'.tr()));

    try {
      // First try to logout from the server
      await authRepo.logout();

      // Always clear local data and update state, regardless of API response
      await logOutFromRevenueCat();
      await authRepo.setUserLogout();
      emit(LogoutSuccess(message: 'auth.logout.success'.tr()));
      emit(UnauthenticatedState());
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }

      // Even if the API call fails, still clear local data and update state
      try {
        await logOutFromRevenueCat();
        await authRepo.setUserLogout();
        emit(LogoutSuccess(message: 'auth.logout.success'.tr()));
        emit(UnauthenticatedState());
      } catch (clearError) {
        // Only emit error if we can't even clear local data
        if (kDebugMode) {
          print('Error clearing local data: $clearError');
        }
        emit(AuthError('auth.logout.error'.tr()));
      }
    }
  }

  /// Updates the FCM token for push notifications
  Future<void> updateFcmToken() async {
    try {
      await authRepo.updateFcmToken();
    } catch (e) {
      if (kDebugMode) {
        print('FCM token update error: $e');
      }
    }
  }

  /// Sends a password reset code to the user's email
  ///
  /// Parameters:
  /// - [email]: User's email address
  Future<void> sendResetPasswordCode(String email) async {
    emit(AuthLoading('auth.forgot_password.sending_code'.tr()));

    try {
      final ApiResponse response = await authRepo.sendResetEmail(email);
      _handleApiResponse(
        response,
        onSuccess: () =>
            emit(AuthSuccess(message: 'auth.forgot_password.code_sent'.tr())),
        onError: (String error) => emit(AuthError(error)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Send reset code error: $e');
      }
      emit(AuthError(e.toString()));
    }
  }

  /// Verifies the password reset code
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [code]: The verification code sent to the user
  Future<void> checkConfirmCode(String email, String code) async {
    emit(AuthLoading('auth.forgot_password.verifying_code'.tr()));

    try {
      final ApiResponse response = await authRepo.checkConfirmCode(email, code);
      _handleApiResponse(
        response,
        onSuccess: () => emit(
          AuthSuccess(message: 'auth.forgot_password.code_verified'.tr()),
        ),
        onError: (String error) => emit(AuthError(error)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Confirm code error: $e');
      }
      emit(AuthError(e.toString()));
    }
  }

  /// Resets the user's password
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [code]: The verification code
  /// - [password]: The new password
  Future<void> resetPassword(String email, String code, String password) async {
    emit(AuthLoading('auth.reset_password.loading'.tr()));

    try {
      final ApiResponse response = await authRepo.resetPassword(
        email,
        code,
        password,
      );
      _handleApiResponse(
        response,
        onSuccess: () => emit(
          RestPasswordSuccess(message: 'auth.reset_password.success'.tr()),
        ),
        onError: (String error) => emit(RestPasswordError(error)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Reset password error: $e');
      }
      emit(RestPasswordError('auth.reset_password.error'.tr()));
    }
  }

  /// Permanently removes the user's account
  Future<void> removeAccount() async {
    emit(AuthLoading('auth.account.deleting'.tr()));

    try {
      // First clear Google token
      await authRepo.removeGoogleAccessToken();

      // Then logout from server
      final ApiResponse response = await authRepo.logout();

      // Handle response
      _handleApiResponse(
        response,
        onSuccess: () => emit(
          RemoveAccountSuccess(message: 'auth.account.delete_success'.tr()),
        ),
        onError: (String error) => emit(AuthError(error)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Remove account error: $e');
      }
      emit(AuthError(e.toString()));
    }
  }

  /// Helper method to process login responses
  Future<void> _processLoginResponse(
    ApiResponse loginResponse, {
    required LoginType loginType,
  }) async {
    final int? status = loginResponse.response?.statusCode;
    if (status != null && status != 200 && status != 201) {
      final String errorMessage =
          loginResponse.error?.toString() ?? 'common.unknown_error'.tr();
      switch (loginType) {
        case LoginType.email:
          emit(AuthEmailError(errorMessage));
        case LoginType.google:
          emit(GoogleAuthError(errorMessage));
        case LoginType.apple:
          emit(AppleAuthError(errorMessage));
      }
      return;
    }

    if (loginResponse.response?.data != null) {
      try {
        final dynamic rawData = loginResponse.response!.data;
        final Map<String, dynamic>? dataMap = rawData is Map<String, dynamic>
            ? rawData
            : null;
        final Map<String, dynamic>? bodyMap =
            dataMap?['body'] is Map<String, dynamic>
            ? dataMap!['body'] as Map<String, dynamic>
            : dataMap?['data'] is Map<String, dynamic>
            ? dataMap!['data'] as Map<String, dynamic>
            : dataMap;
        if (bodyMap == null) {
          throw Exception('Unexpected login response format');
        }

        final LoginModel loginModel = LoginModel.fromJson(bodyMap);
        final String? token = loginModel.token;
        if (token == null || token.isEmpty || token == 'null') {
          throw Exception('Missing auth token');
        }

        // ✅ خزّن حالة الاشتراك في AppStrings + SharedPreferences
        await AppStrings.setVip(
          isVip: loginModel.isVip,
          isVipChat: loginModel.isVipChat,
        );

        // حفظ جلسة المستخدم
        await _saveUserSession(token);
        await logInToRevenueCat(loginModel.id);

        if (kDebugMode) {
          print(
            'AUTH_DEBUG tokenLength=${token.length} '
            'storage=SharedPreferences',
          );
        }

        // Emit حسب نوع الدخول
        switch (loginType) {
          case LoginType.email:
            emit(
              AuthEmailSuccess(
                data: loginModel,
                message: 'auth.login.success'.tr(),
              ),
            );
          case LoginType.google:
            emit(
              GoogleSuccess(
                data: loginModel,
                message: 'auth.login.success'.tr(),
              ),
            );
          case LoginType.apple:
            emit(
              AppleSuccess(
                data: loginModel,
                message: 'auth.login.success'.tr(),
              ),
            );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error processing login response: $e');
        }
        switch (loginType) {
          case LoginType.email:
            emit(AuthEmailError(e.toString()));
          case LoginType.google:
            emit(GoogleAuthError(e.toString()));
          case LoginType.apple:
            emit(AppleAuthError(e.toString()));
        }
      }
    } else {
      switch (loginType) {
        case LoginType.email:
          emit(
            AuthEmailError(
              loginResponse.error?.toString() ?? 'common.unknown_error'.tr(),
            ),
          );
        case LoginType.google:
          emit(
            GoogleAuthError(
              loginResponse.error?.toString() ?? 'common.unknown_error'.tr(),
            ),
          );
        case LoginType.apple:
          emit(
            AppleAuthError(
              loginResponse.error?.toString() ?? 'common.unknown_error'.tr(),
            ),
          );
      }
    }
  }

  /// Helper method to save user session data
  Future<void> _saveUserSession(String token) async {
    try {
      await authRepo.saveUserToken(token);
      await authRepo.setUserLogin();
      await authRepo.updateFcmToken();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user session: $e');
      }
      // We don't emit an error here as this is called from _processLoginResponse
      // which will handle the overall success/failure
    }
  }

  /// Helper method to handle API responses
  void _handleApiResponse(
    ApiResponse response, {
    // ignore: inference_failure_on_function_return_type
    required Function() onSuccess,
    // ignore: inference_failure_on_function_return_type
    required Function(String error) onError,
  }) {
    if (response.response != null && response.response!.statusCode == 200) {
      onSuccess();
    } else {
      final String errorMessage = response.error ?? 'common.unknown_error'.tr();
      onError(errorMessage);
    }
  }
}
