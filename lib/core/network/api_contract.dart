abstract interface class ApiContract<TRequest, TResponse> {
  String get path;
  String get method;
  TResponse parseResponse(Map<String, dynamic> json);
  Map<String, dynamic> toRequest(TRequest request);
}
