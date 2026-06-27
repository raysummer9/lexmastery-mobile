import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/course_details/routes/course_details_routes.dart';
import 'package:lexmastery_mobile/features/courses/routes/courses_routes.dart';
import 'package:lexmastery_mobile/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:lexmastery_mobile/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:lexmastery_mobile/features/lesson_player/routes/lesson_player_routes.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(dashboardControllerProvider.notifier).loadDashboard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          DashboardStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          DashboardStatus.failure =>
            Center(child: Text(state.message ?? 'Unable to load dashboard.')),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _DashboardCard(
                  title: 'Continue Learning',
                  value: state.snapshot?.continueLearningCourseId ?? '-',
                ),
                SizedBox(height: context.spacing.md),
                _DashboardCard(
                  title: 'Daily Goal',
                  value: '${state.snapshot?.dailyGoalMinutes ?? 0} minutes',
                ),
                SizedBox(height: context.spacing.md),
                _DashboardCard(
                  title: 'AI Suggestion',
                  value: state.snapshot?.aiSuggestion ?? '-',
                ),
                SizedBox(height: context.spacing.lg),
                FilledButton(
                  onPressed: () => context.go(CoursesRoutes.coursesPath),
                  child: const Text('Open Courses'),
                ),
                SizedBox(height: context.spacing.sm),
                OutlinedButton(
                  onPressed: () => context.go(
                    '${CourseDetailsRoutes.courseDetailsBasePath}/course-contract-law',
                  ),
                  child: const Text('Open Course Details'),
                ),
                SizedBox(height: context.spacing.sm),
                OutlinedButton(
                  onPressed: () => context.go(
                    '${LessonPlayerRoutes.lessonBasePath}/lesson-offer-acceptance',
                  ),
                  child: const Text('Resume Lesson'),
                ),
              ],
            ),
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: context.typography.labelMedium),
          SizedBox(height: context.spacing.xs),
          Text(value, style: context.typography.bodyLarge),
        ],
      ),
    );
  }
}
