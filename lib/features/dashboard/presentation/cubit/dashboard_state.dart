part of 'dashboard_cubit.dart';

class DashboardState {
  final bool isLoading;
  final bool hasError;
  final bool hasData;
  final String? error;

  DashboardState({
    required this.isLoading,
    required this.hasError,
    required this.hasData,
    this.error,
  });

  DashboardState copyWith(isLoading, hasError, hasData, error) {
    return DashboardState(
      isLoading: isLoading,
      hasError: hasError,
      hasData: hasData,
      error: error,
    );
  }
}
