import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/course_details/routes/course_details_routes.dart';
import 'package:lexmastery_mobile/features/courses/domain/entities/course_summary.dart';
import 'package:lexmastery_mobile/features/courses/presentation/controllers/courses_controller.dart';
import 'package:lexmastery_mobile/features/courses/presentation/state/courses_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(coursesControllerProvider.notifier).loadCourses(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coursesControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          CoursesStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          CoursesStatus.failure =>
            Center(child: Text(state.message ?? 'Unable to load courses.')),
          _ => ListView.separated(
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return _CourseCard(
                  course: course,
                  onOpen: () => context.go(
                    '${CourseDetailsRoutes.courseDetailsBasePath}/${course.id}',
                  ),
                  onEnroll: () => ref
                      .read(coursesControllerProvider.notifier)
                      .enroll(course.id),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: context.spacing.md),
              itemCount: state.courses.length,
            ),
        },
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.course,
    required this.onOpen,
    required this.onEnroll,
  });

  final CourseSummary course;
  final VoidCallback onOpen;
  final VoidCallback onEnroll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfacePrimary,
        borderRadius: context.radius.card,
        border: Border.all(color: context.colors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(course.title, style: context.typography.titleLarge),
          SizedBox(height: context.spacing.xs),
          Text(
            '${course.difficulty} • ${course.progressPercent}% complete',
            style: context.typography.bodyMedium,
          ),
          SizedBox(height: context.spacing.sm),
          Text(
            'Modules: ${course.modules.length}',
            style: context.typography.bodyMedium,
          ),
          SizedBox(height: context.spacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: onOpen,
                  child: const Text('Open'),
                ),
              ),
              SizedBox(width: context.spacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: onEnroll,
                  child: const Text('Enroll'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
