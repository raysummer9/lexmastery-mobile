import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/course_details/domain/entities/course_detail.dart';
import 'package:lexmastery_mobile/features/course_details/presentation/controllers/course_details_controller.dart';
import 'package:lexmastery_mobile/features/course_details/presentation/state/course_details_state.dart';
import 'package:lexmastery_mobile/features/lesson_player/routes/lesson_player_routes.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class CourseDetailsScreen extends ConsumerStatefulWidget {
  const CourseDetailsScreen({
    required this.courseId,
    super.key,
  });

  final String courseId;

  @override
  ConsumerState<CourseDetailsScreen> createState() =>
      _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends ConsumerState<CourseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref
          .read(courseDetailsControllerProvider.notifier)
          .loadCourseDetail(widget.courseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(courseDetailsControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          CourseDetailsStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          CourseDetailsStatus.failure =>
            Center(child: Text(state.message ?? 'Unable to load details.')),
          _ => _DetailBody(detail: state.courseDetail!),
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail});

  final CourseDetail detail;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Text(detail.title, style: context.typography.headlineMedium),
        SizedBox(height: context.spacing.xs),
        Text(detail.description, style: context.typography.bodyMedium),
        SizedBox(height: context.spacing.md),
        Text(
          'Progress: ${detail.progressPercent}% • Modules: ${detail.modules.length}',
          style: context.typography.bodyMedium,
        ),
        SizedBox(height: context.spacing.lg),
        FilledButton(
          onPressed: () {
            final firstLesson = detail.modules.first.lessons.first;
            context
                .go('${LessonPlayerRoutes.lessonBasePath}/${firstLesson.id}');
          },
          child: Text(detail.isEnrolled ? 'Continue Learning' : 'Enroll'),
        ),
        SizedBox(height: context.spacing.md),
        ...detail.modules.map(
          (CourseDetailModule module) => ExpansionTile(
            title: Text(module.title),
            children: module.lessons
                .map(
                  (CourseDetailLesson lesson) => ListTile(
                    title: Text(lesson.title),
                    subtitle: Text('${lesson.durationMinutes} min'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go(
                      '${LessonPlayerRoutes.lessonBasePath}/${lesson.id}',
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
