part of 'auth_cubit.dart';

/// Base class for all authentication states
@immutable
abstract class AuthState extends Equatable {
  /// Creates a new authentication state
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial state when the app starts or authentication status is unknown
class AuthInitial extends AuthState {}

///*********************************************
/// Loading States
///*********************************************

/// Base loading state for authentication operations
class AuthLoading extends AuthState {
  /// Creates a loading state with an optional message
  const AuthLoading([this.message]);
  
  /// Message to display during loading
  final String? message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Specialized loading states for specific auth operations
class AuthEmailLoading extends AuthLoading {
  /// Loading state for email authentication
  const AuthEmailLoading([super.message]);
}

class GoogleLoading extends AuthLoading {
  /// Loading state for Google authentication
  const GoogleLoading([super.message]);
}

class AppleLoading extends AuthLoading {
  /// Loading state for Apple authentication
  const AppleLoading([super.message]);
}

class RestPasswordLoading extends AuthLoading {
  /// Loading state for password reset
  const RestPasswordLoading([super.message]);
}

///*********************************************
/// Success States
///*********************************************

/// Base success state for authentication operations
class AuthSuccess extends AuthState {
  /// Creates a success state with optional message and data
  const AuthSuccess({this.message, this.data});
  
  /// Success message to display
  final String? message;
  
  /// Login data returned from the API
  final LoginModel? data;

  @override
  List<Object?> get props => <Object?>[message, data];
}

/// Specialized success states for specific auth operations
class AuthEmailSuccess extends AuthSuccess {
  /// Success state for email authentication
  const AuthEmailSuccess({super.message, super.data});
}

class AuthEmailError extends AuthError {
  /// Error state for email authentication
  const AuthEmailError(super.error);
} 

class GoogleSuccess extends AuthSuccess {
  /// Success state for Google authentication
  const GoogleSuccess({super.message, super.data});
}

class AppleSuccess extends AuthSuccess {
  /// Success state for Apple authentication
  const AppleSuccess({super.message, super.data});
}

class RegisterSuccess extends AuthSuccess {
  /// Success state for user registration
  const RegisterSuccess({super.message, super.data});
}

class LogoutSuccess extends AuthSuccess {
  /// Success state for user logout
  const LogoutSuccess({super.message});
}

class RemoveAccountSuccess extends AuthSuccess {
  /// Success state for account removal
  const RemoveAccountSuccess({super.message});
}

class RestPasswordSuccess extends AuthSuccess {
  /// Success state for password reset
  const RestPasswordSuccess({super.message, super.data});
}

///*********************************************
/// Error States
///*********************************************

/// Base error state for authentication operations
class AuthError extends AuthState {
  /// Creates an error state with an error message
  const AuthError(this.error);
  
  /// Error message to display
  final String error;

  @override
  List<Object?> get props => <Object?>[error];
}

/// Specialized error states for specific auth errors
class TokenExpiredError extends AuthError {
  /// Error state for expired token
  const TokenExpiredError() : super('auth.errors.session_expired');
}

class NetworkError extends AuthError {
  /// Error state for network connectivity issues
  const NetworkError() : super('common.no_internet');
}

class GoogleAuthError extends AuthError {
  /// Error state for Google authentication
  const GoogleAuthError(super.error);
}

class AppleAuthError extends AuthError {
  /// Error state for Apple authentication
  const AppleAuthError(super.error);
}

class RestPasswordError extends AuthError {
  /// Error state for password reset
  const RestPasswordError(super.error);
}

///*********************************************
/// Authentication Status States
///*********************************************

/// State indicating the user is authenticated
class AuthenticatedState extends AuthState {}

/// State indicating the user is not authenticated
class UnauthenticatedState extends AuthState {}
