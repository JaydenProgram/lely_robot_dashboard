part of 'auth_cubit.dart';

class AuthState {
  final bool isLoading;
  final bool hasError;
  final bool hasData;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.hasError,
    required this.hasData,
    this.error,
  });

  AuthState copyWith(
    bool isLoading,
    bool hasError,
    bool hasData,
    String? error,
  ) {
    return AuthState(
      isLoading: isLoading,
      hasError: hasError,
      hasData: hasData,
      error: error,
    );
  }
}
