import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/features/course_details/data/repositories/course_details_repository_impl.dart';
import 'package:lexmastery_mobile/features/course_details/domain/repositories/course_details_repository.dart';
import 'package:lexmastery_mobile/features/course_details/presentation/state/course_details_state.dart';

final courseDetailsRepositoryProvider = Provider<CourseDetailsRepository>(
  (ref) => CourseDetailsRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final courseDetailsControllerProvider =
    NotifierProvider<CourseDetailsController, CourseDetailsState>(
  CourseDetailsController.new,
);

class CourseDetailsController extends Notifier<CourseDetailsState> {
  late final CourseDetailsRepository _repository;

  @override
  CourseDetailsState build() {
    _repository = ref.read(courseDetailsRepositoryProvider);
    return const CourseDetailsState.initial();
  }

  Future<void> loadCourseDetail(String courseId) async {
    state = state.copyWith(status: CourseDetailsStatus.loading);
    try {
      final detail = await _repository.getCourseDetail(courseId);
      state = state.copyWith(
        status: CourseDetailsStatus.loaded,
        courseDetail: detail,
      );
      await ref.read(analyticsControllerProvider.notifier).track(
            AnalyticsEvent(
              type: AnalyticsEventType.featureUsed,
              name: 'course_details_view',
              occurredAt: DateTime.now(),
              payload: <String, dynamic>{'courseId': courseId},
            ),
          );
    } catch (_) {
      state = state.copyWith(
        status: CourseDetailsStatus.failure,
        message: 'Unable to load course details.',
      );
    }
  }
}
