import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/ai_chat/routes/ai_chat_routes.dart';
import 'package:lexmastery_mobile/features/ai_memory/routes/ai_memory_routes.dart';
import 'package:lexmastery_mobile/features/ai_tutor/routes/ai_tutor_routes.dart';
import 'package:lexmastery_mobile/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:lexmastery_mobile/features/authentication/routes/authentication_routes.dart';
import 'package:lexmastery_mobile/features/courses/routes/courses_routes.dart';
import 'package:lexmastery_mobile/features/dashboard/routes/dashboard_routes.dart';
import 'package:lexmastery_mobile/features/flashcards/routes/flashcards_routes.dart';
import 'package:lexmastery_mobile/features/mock_exam/routes/mock_exam_routes.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/routes/prompt_engineering_routes.dart';
import 'package:lexmastery_mobile/features/quiz_engine/routes/quiz_engine_routes.dart';
import 'package:lexmastery_mobile/features/rag_engine/routes/rag_engine_routes.dart';
import 'package:lexmastery_mobile/features/notifications/routes/notifications_routes.dart';
import 'package:lexmastery_mobile/features/profile/routes/profile_routes.dart';
import 'package:lexmastery_mobile/features/settings/routes/settings_routes.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LexMastery AI'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Container(
            padding: EdgeInsets.all(context.spacing.lg),
            decoration: BoxDecoration(
              color: context.colors.surfacePrimary,
              borderRadius: context.radius.card,
              border: Border.all(color: context.colors.borderDefault),
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  'Phase 3 AI modules are now scaffolded.',
                  style: context.typography.bodyLarge,
                ),
                SizedBox(height: context.spacing.lg),
                FilledButton(
                  onPressed: () => context.go(DashboardRoutes.dashboardPath),
                  child: const Text('Open Dashboard'),
                ),
                SizedBox(height: context.spacing.sm),
                FilledButton(
                  onPressed: () => context.go(CoursesRoutes.coursesPath),
                  child: const Text('Open Courses'),
                ),
                SizedBox(height: context.spacing.sm),
                FilledButton(
                  onPressed: () => context.go(QuizEngineRoutes.quizPath),
                  child: const Text('Open Quiz Engine'),
                ),
                SizedBox(height: context.spacing.sm),
                FilledButton(
                  onPressed: () => context.go(MockExamRoutes.mockExamPath),
                  child: const Text('Open Mock Exam'),
                ),
                SizedBox(height: context.spacing.sm),
                FilledButton(
                  onPressed: () => context.go(FlashcardsRoutes.flashcardsPath),
                  child: const Text('Open Flashcards'),
                ),
                SizedBox(height: context.spacing.sm),
                FilledButton(
                  onPressed: () => context.go(AiTutorRoutes.tutorPath),
                  child: const Text('Open AI Tutor'),
                ),
                SizedBox(height: context.spacing.sm),
                FilledButton(
                  onPressed: () => context.go(AiChatRoutes.chatPath),
                  child: const Text('Open AI Chat'),
                ),
                SizedBox(height: context.spacing.sm),
                OutlinedButton(
                  onPressed: () =>
                      context.go(PromptEngineeringRoutes.promptPath),
                  child: const Text('Open Prompt Engineering'),
                ),
                SizedBox(height: context.spacing.sm),
                OutlinedButton(
                  onPressed: () => context.go(RagEngineRoutes.ragPath),
                  child: const Text('Open RAG Engine'),
                ),
                SizedBox(height: context.spacing.sm),
                OutlinedButton(
                  onPressed: () => context.go(AiMemoryRoutes.memoryPath),
                  child: const Text('Open AI Memory'),
                ),
                SizedBox(height: context.spacing.sm),
                FilledButton(
                  onPressed: () => context.go(ProfileRoutes.profilePath),
                  child: const Text('Open Profile'),
                ),
                SizedBox(height: context.spacing.sm),
                FilledButton(
                  onPressed: () => context.go(SettingsRoutes.settingsPath),
                  child: const Text('Open Settings'),
                ),
                SizedBox(height: context.spacing.sm),
                FilledButton(
                  onPressed: () =>
                      context.go(NotificationsRoutes.notificationsPath),
                  child: const Text('Open Notifications'),
                ),
                SizedBox(height: context.spacing.sm),
                OutlinedButton(
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go(AuthenticationRoutes.loginPath);
                    }
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
