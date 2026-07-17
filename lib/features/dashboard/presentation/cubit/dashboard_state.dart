part of 'dashboard_cubit.dart';

class DashboardState {
  final bool isLoading;
  final bool hasError;
  final bool hasData;
  final List<Map<String, String>>? data;
  final String? error;

  DashboardState({
    required this.isLoading,
    required this.hasError,
    required this.hasData,
    this.data = const [],
    this.error,
  });

  DashboardState copyWith(
    bool isLoading,
    bool hasError,
    bool hasData,
    List<Map<String, String>>? data,
    String? error,
  ) {
    return DashboardState(
      isLoading: isLoading,
      hasError: hasError,
      hasData: hasData,
      data: data,
      error: error,
    );
  }
}
