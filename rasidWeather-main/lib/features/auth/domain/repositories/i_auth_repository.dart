import '../../../../core/repositories/base_repository.dart';
import '../../../../data/model/base/api_response.dart';
import '../../../../data/model/user_model.dart';

abstract class IAuthRepository extends BaseRepository<UserModel> {
  Future<void> removeAccount(String id);
  
  Future<ApiResponse> createAccount(Map<String, dynamic> params);
  Future<ApiResponse> loginWithEmail(Map<String, String> params);
  Future<ApiResponse> loginWithGoogle();
  Future<ApiResponse> signInWithApple();
  Future<void> removeGoogleAccessToken();
  Future<ApiResponse> logout();
  
  Future<bool> checkAuthStatus();
  
  Future<void> setUserLogin();
  Future<bool> getUserLogin();
  Future<void> setUserLogout();
  Future<void> saveUserToken(String token);
  Future<void> updateFcmToken();
  Future<String?> getToken();
  
  Future<ApiResponse> sendResetEmail(String email);
  Future<ApiResponse> checkConfirmCode(String email, String code);
  Future<ApiResponse> resetPassword(String email, String code, String password);
}


///20a28b81-6eb7-4b73-a189-ad8ae9dfb208