import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/secure_storage_service.dart';

Future<void> bootstrap() async {
  await LocalStorageService.initialize();
  await AppProviders.preload();
  await SecureStorageService.instance.bootstrap();
}
