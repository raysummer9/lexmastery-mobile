import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/secure_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/authentication/data/contracts/auth_api_contract.dart';
import 'package:lexmastery_mobile/features/authentication/domain/entities/auth_session.dart';
import 'package:lexmastery_mobile/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required SecureStorageService secureStorageService,
  })  : _apiClient = apiClient,
        _secureStorageService = secureStorageService;

  final ApiClient _apiClient;
  final SecureStorageService _secureStorageService;
  final SignInApiContract _signInApiContract = SignInApiContract();

  @override
  Future<AuthSession?> restoreSession() async {
    final refreshToken =
        await _secureStorageService.read(StorageKeys.refreshToken);
    final rawSession =
        LocalStorageService.readValue<String>(StorageKeys.authSession);
    if (refreshToken == null || rawSession == null) {
      return null;
    }
    final parsed = AuthSession.fromJson(
      jsonDecode(rawSession) as Map<dynamic, dynamic>,
    );
    _apiClient.updateAccessToken(parsed.accessToken);
    return parsed;
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final request = SignInRequest(email: email, password: password);

    // Phase 1 keeps this endpoint contract-ready while returning a deterministic
    // local development session when backend is not available yet.
    AuthSession session;
    try {
      final response = await _apiClient.post(
        _signInApiContract.path,
        data: _signInApiContract.toRequest(request),
      );
      final signInResponse = _signInApiContract.parseResponse(
        response.data as Map<String, dynamic>,
      );
      session = AuthSession(
        userId: signInResponse.userId,
        accessToken: signInResponse.accessToken,
        refreshToken: signInResponse.refreshToken,
        expiresAt: DateTime.parse(signInResponse.expiresAtIso),
      );
    } catch (_) {
      session = AuthSession(
        userId: 'phase1-user',
        accessToken: 'phase1_access_token',
        refreshToken: 'phase1_refresh_token',
        expiresAt: DateTime.now().add(const Duration(hours: 8)),
      );
    }

    _apiClient.updateAccessToken(session.accessToken);
    await _secureStorageService.write(
      key: StorageKeys.refreshToken,
      value: session.refreshToken,
    );
    await _secureStorageService.write(
      key: StorageKeys.userId,
      value: session.userId,
    );
    await LocalStorageService.writeValue(
      StorageKeys.authSession,
      jsonEncode(session.toJson()),
    );
    return session;
  }

  @override
  Future<void> signOut() async {
    _apiClient.updateAccessToken(null);
    await _secureStorageService.delete(StorageKeys.refreshToken);
    await _secureStorageService.delete(StorageKeys.userId);
    await LocalStorageService.deleteValue(StorageKeys.authSession);
  }
}
