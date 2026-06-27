import 'package:lexmastery_mobile/core/network/api_contract.dart';

class RagQueryRequest {
  const RagQueryRequest({required this.query});
  final String query;
}

class RagQueryResponse {
  const RagQueryResponse({required this.items});
  final List<Map<String, dynamic>> items;
}

class RagApiContract implements ApiContract<RagQueryRequest, RagQueryResponse> {
  @override
  String get method => 'POST';

  @override
  String get path => '/rag/query';

  @override
  RagQueryResponse parseResponse(Map<String, dynamic> json) {
    return RagQueryResponse(
      items: (json['items'] as List<dynamic>)
          .map((dynamic e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toRequest(RagQueryRequest request) {
    return <String, dynamic>{'query': request.query};
  }
}
