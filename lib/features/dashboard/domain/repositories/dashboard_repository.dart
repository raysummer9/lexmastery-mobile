import 'package:lexmastery_mobile/features/dashboard/domain/entities/dashboard_snapshot.dart';

abstract interface class DashboardRepository {
  Future<DashboardSnapshot> getDashboard();
}
