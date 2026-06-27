import 'package:lexmastery_mobile/features/dashboard/domain/entities/dashboard_snapshot.dart';

enum DashboardStatus {
  loading,
  loaded,
  refreshing,
  failure,
}

class DashboardState {
  const DashboardState({
    required this.status,
    this.snapshot,
    this.message,
  });

  const DashboardState.initial()
      : status = DashboardStatus.loading,
        snapshot = null,
        message = null;

  final DashboardStatus status;
  final DashboardSnapshot? snapshot;
  final String? message;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSnapshot? snapshot,
    String? message,
  }) {
    return DashboardState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      message: message,
    );
  }
}
