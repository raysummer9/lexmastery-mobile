import 'package:lexmastery_mobile/features/authentication/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession?> restoreSession();
  Future<AuthSession> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
}
