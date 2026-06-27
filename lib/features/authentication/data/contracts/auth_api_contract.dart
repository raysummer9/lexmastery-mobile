import 'package:lexmastery_mobile/core/network/api_contract.dart';

class SignInRequest {
  const SignInRequest({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class SignInResponse {
  const SignInResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAtIso,
  });

  final String userId;
  final String accessToken;
  final String refreshToken;
  final String expiresAtIso;
}

class SignInApiContract implements ApiContract<SignInRequest, SignInResponse> {
  @override
  String get method => 'POST';

  @override
  String get path => '/auth/login';

  @override
  SignInResponse parseResponse(Map<String, dynamic> json) {
    return SignInResponse(
      userId: json['userId'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAtIso: json['expiresAt'] as String,
    );
  }

  @override
  Map<String, dynamic> toRequest(SignInRequest request) {
    return <String, dynamic>{
      'email': request.email,
      'password': request.password,
    };
  }
}
