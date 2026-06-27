import 'package:lexmastery_mobile/core/network/api_contract.dart';

class UpdateMemoryRequest {
  const UpdateMemoryRequest({required this.payload});
  final Map<String, dynamic> payload;
}

class UpdateMemoryResponse {
  const UpdateMemoryResponse({required this.payload});
  final Map<String, dynamic> payload;
}

class AiMemoryApiContract
    implements ApiContract<UpdateMemoryRequest, UpdateMemoryResponse> {
  @override
  String get method => 'POST';

  @override
  String get path => '/memory/update';

  @override
  UpdateMemoryResponse parseResponse(Map<String, dynamic> json) {
    return UpdateMemoryResponse(payload: json);
  }

  @override
  Map<String, dynamic> toRequest(UpdateMemoryRequest request) =>
      request.payload;
}
