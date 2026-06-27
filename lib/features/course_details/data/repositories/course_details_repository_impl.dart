import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/features/course_details/data/contracts/course_details_api_contract.dart';
import 'package:lexmastery_mobile/features/course_details/domain/entities/course_detail.dart';
import 'package:lexmastery_mobile/features/course_details/domain/repositories/course_details_repository.dart';

class CourseDetailsRepositoryImpl implements CourseDetailsRepository {
  CourseDetailsRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final CourseDetailApiContract _contract = CourseDetailApiContract();

  @override
  Future<CourseDetail> getCourseDetail(String courseId) async {
    try {
      final response = await _apiClient.get(
        _contract.path,
        queryParameters: _contract.toRequest(courseId),
      );
      final payload =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      return _fromPayload(payload.payload);
    } catch (_) {
      return _fallback(courseId);
    }
  }

  CourseDetail _fromPayload(Map<String, dynamic> payload) {
    final modules = (payload['modules'] as List<dynamic>)
        .map(
          (dynamic module) => CourseDetailModule(
            id: module['id'] as String,
            title: module['title'] as String,
            lessons: (module['lessons'] as List<dynamic>)
                .map(
                  (dynamic lesson) => CourseDetailLesson(
                    id: lesson['id'] as String,
                    title: lesson['title'] as String,
                    durationMinutes: lesson['durationMinutes'] as int,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
    return CourseDetail(
      id: payload['id'] as String,
      title: payload['title'] as String,
      description: payload['description'] as String,
      isEnrolled: payload['isEnrolled'] as bool,
      progressPercent: payload['progressPercent'] as int,
      modules: modules,
    );
  }

  CourseDetail _fallback(String courseId) {
    return CourseDetail(
      id: courseId,
      title: 'Contract Law Foundation',
      description:
          'Structured preparation for core contract principles with exam-focused drills.',
      isEnrolled: true,
      progressPercent: 35,
      modules: const <CourseDetailModule>[
        CourseDetailModule(
          id: 'module-offer-acceptance',
          title: 'Offer and Acceptance',
          lessons: <CourseDetailLesson>[
            CourseDetailLesson(
              id: 'lesson-offer-acceptance',
              title: 'Core Principles',
              durationMinutes: 18,
            ),
            CourseDetailLesson(
              id: 'lesson-invitation-treat',
              title: 'Invitation to Treat',
              durationMinutes: 12,
            ),
          ],
        ),
      ],
    );
  }
}
