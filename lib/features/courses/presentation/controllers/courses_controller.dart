import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/sync/sync_controller.dart';
import 'package:lexmastery_mobile/core/sync/sync_job.dart';
import 'package:lexmastery_mobile/features/courses/data/repositories/courses_repository_impl.dart';
import 'package:lexmastery_mobile/features/courses/domain/repositories/courses_repository.dart';
import 'package:lexmastery_mobile/features/courses/presentation/state/courses_state.dart';

final coursesRepositoryProvider = Provider<CoursesRepository>(
  (ref) => CoursesRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final coursesControllerProvider =
    NotifierProvider<CoursesController, CoursesState>(
  CoursesController.new,
);

class CoursesController extends Notifier<CoursesState> {
  late final CoursesRepository _repository;

  @override
  CoursesState build() {
    _repository = ref.read(coursesRepositoryProvider);
    return const CoursesState.initial();
  }

  Future<void> loadCourses() async {
    state = state.copyWith(status: CoursesStatus.loading);
    try {
      final courses = await _repository.getCourses();
      state = state.copyWith(status: CoursesStatus.loaded, courses: courses);
      await ref.read(analyticsControllerProvider.notifier).track(
            AnalyticsEvent(
              type: AnalyticsEventType.featureUsed,
              name: 'courses_view',
              occurredAt: DateTime.now(),
            ),
          );
    } catch (_) {
      state = state.copyWith(
        status: CoursesStatus.failure,
        message: 'Unable to load courses.',
      );
    }
  }

  Future<void> enroll(String courseId) async {
    state = state.copyWith(status: CoursesStatus.enrolling);
    await _repository.enrollInCourse(courseId);
    await ref.read(syncControllerProvider.notifier).enqueue(
          SyncJob(
            id: 'course-enrollment-${DateTime.now().microsecondsSinceEpoch}',
            entityType: 'course_enrollment',
            payload: <String, dynamic>{'courseId': courseId},
            retryCount: 0,
            createdAt: DateTime.now(),
          ),
        );
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'course_enroll',
            occurredAt: DateTime.now(),
            payload: <String, dynamic>{'courseId': courseId},
          ),
        );
    final courses = await _repository.getCourses();
    state = state.copyWith(status: CoursesStatus.loaded, courses: courses);
  }
}
