import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/presentation/screens/prompt_engineering_screen.dart';

class PromptEngineeringRoutes {
  const PromptEngineeringRoutes._();

  static const String promptPath = '/prompt-engineering';
  static const String promptName = 'promptEngineering';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: promptPath,
      name: promptName,
      builder: (context, state) => const PromptEngineeringScreen(),
    ),
  ];
}
