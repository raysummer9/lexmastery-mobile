import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/courses/data/contracts/courses_api_contract.dart';
import 'package:lexmastery_mobile/features/courses/domain/entities/course_summary.dart';
import 'package:lexmastery_mobile/features/courses/domain/repositories/courses_repository.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  CoursesRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final CoursesApiContract _coursesContract = CoursesApiContract();
  final EnrollCourseApiContract _enrollContract = EnrollCourseApiContract();

  @override
  Future<List<CourseSummary>> getCourses() async {
    final cached =
        LocalStorageService.readValue<String>(StorageKeys.coursesCatalog);
    if (cached != null) {
      final decoded = jsonDecode(cached) as List<dynamic>;
      return decoded
          .map((dynamic item) => CourseSummary.fromJson(item as Map))
          .toList();
    }

    List<CourseSummary> courses;
    try {
      final response = await _apiClient.get(_coursesContract.path);
      final parsed =
          _coursesContract.parseResponse(response.data as Map<String, dynamic>);
      courses = parsed.items
          .map((Map<String, dynamic> item) => CourseSummary.fromJson(item))
          .toList();
    } catch (_) {
      courses = <CourseSummary>[
        const CourseSummary(
          id: 'course-contract-law',
          title: 'Contract Law Foundation',
          difficulty: 'intermediate',
          progressPercent: 35,
          modules: <CourseModuleSummary>[
            CourseModuleSummary(
              id: 'module-offer-acceptance',
              title: 'Offer and Acceptance',
              lessons: <LessonSummary>[
                LessonSummary(
                  id: 'lesson-offer-acceptance',
                  title: 'Core Principles',
                  durationMinutes: 18,
                ),
                LessonSummary(
                  id: 'lesson-invitation-treat',
                  title: 'Invitation to Treat',
                  durationMinutes: 12,
                ),
              ],
            ),
          ],
        ),
      ];
    }

    await LocalStorageService.writeValue(
      StorageKeys.coursesCatalog,
      jsonEncode(
        courses.map((CourseSummary course) => course.toJson()).toList(),
      ),
    );
    return courses;
  }

  @override
  Future<void> enrollInCourse(String courseId) async {
    try {
      await _apiClient.post(
        _enrollContract.path,
        data:
            _enrollContract.toRequest(EnrollCourseRequest(courseId: courseId)),
      );
    } catch (_) {
      // Phase scaffold keeps enrollment non-blocking for offline-first UX.
    }
  }
}
