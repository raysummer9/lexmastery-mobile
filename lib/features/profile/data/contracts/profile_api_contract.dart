import 'package:lexmastery_mobile/core/network/api_contract.dart';

class UpdateProfileRequest {
  const UpdateProfileRequest({
    required this.userId,
    required this.name,
    required this.email,
    required this.jurisdiction,
    required this.examTarget,
  });

  final String userId;
  final String name;
  final String email;
  final String jurisdiction;
  final String examTarget;
}

class UpdateProfileResponse {
  const UpdateProfileResponse({
    required this.userId,
    required this.name,
    required this.email,
    required this.jurisdiction,
    required this.examTarget,
    required this.updatedAtIso,
  });

  final String userId;
  final String name;
  final String email;
  final String jurisdiction;
  final String examTarget;
  final String updatedAtIso;
}

class UpdateProfileApiContract
    implements ApiContract<UpdateProfileRequest, UpdateProfileResponse> {
  @override
  String get method => 'PUT';

  @override
  String get path => '/profile/update';

  @override
  UpdateProfileResponse parseResponse(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      jurisdiction: json['jurisdiction'] as String,
      examTarget: json['examTarget'] as String,
      updatedAtIso: json['updatedAt'] as String,
    );
  }

  @override
  Map<String, dynamic> toRequest(UpdateProfileRequest request) {
    return <String, dynamic>{
      'userId': request.userId,
      'name': request.name,
      'email': request.email,
      'jurisdiction': request.jurisdiction,
      'examTarget': request.examTarget,
    };
  }
}
