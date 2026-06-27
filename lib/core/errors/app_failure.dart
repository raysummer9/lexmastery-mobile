enum AppFailureType {
  network,
  authentication,
  validation,
  storage,
  sync,
  unknown,
}

class AppFailure implements Exception {
  const AppFailure({
    required this.type,
    required this.message,
  });

  final AppFailureType type;
  final String message;

  @override
  String toString() => 'AppFailure(type: $type, message: $message)';
}
