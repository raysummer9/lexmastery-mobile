import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/storage/secure_storage_service.dart';
import 'package:lexmastery_mobile/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:lexmastery_mobile/features/authentication/domain/repositories/auth_repository.dart';
import 'package:lexmastery_mobile/features/authentication/presentation/state/auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    secureStorageService: SecureStorageService.instance,
  ),
);

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.read(authRepositoryProvider);
    return const AuthState.initial();
  }

  Future<void> restoreSession() async {
    final session = await _repository.restoreSession();
    if (session == null) {
      state = const AuthState.initial();
      return;
    }
    if (session.isExpired) {
      state = state.copyWith(
        status: AuthStatus.sessionExpired,
        session: session,
        message: 'Session expired. Please sign in again.',
      );
      return;
    }
    state = state.copyWith(
      status: AuthStatus.authenticated,
      session: session,
      message: null,
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.authenticating, message: null);
    try {
      final session =
          await _repository.signIn(email: email, password: password);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        session: session,
      );
      await ref.read(analyticsControllerProvider.notifier).track(
            AnalyticsEvent(
              type: AnalyticsEventType.featureUsed,
              name: 'auth_login_success',
              occurredAt: DateTime.now(),
              payload: <String, dynamic>{'userId': session.userId},
            ),
          );
    } catch (_) {
      state = state.copyWith(
        status: AuthStatus.failure,
        message: 'Unable to sign in. Please try again.',
      );
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState.initial();
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'auth_logout',
            occurredAt: DateTime.now(),
          ),
        );
  }
}
