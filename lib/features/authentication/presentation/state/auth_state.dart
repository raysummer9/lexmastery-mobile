import 'package:lexmastery_mobile/features/authentication/domain/entities/auth_session.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
  sessionExpired,
  failure,
}

class AuthState {
  const AuthState({
    required this.status,
    this.session,
    this.message,
  });

  const AuthState.initial()
      : status = AuthStatus.unauthenticated,
        session = null,
        message = null;

  final AuthStatus status;
  final AuthSession? session;
  final String? message;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      message: message,
    );
  }
}
