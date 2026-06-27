import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/bootstrap/bootstrap.dart';
import 'package:lexmastery_mobile/app/bootstrap/lexmastery_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  runApp(const ProviderScope(child: LexMasteryApp()));
}
