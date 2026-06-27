import 'package:lexmastery_mobile/core/network/api_contract.dart';

class UpdateSettingsRequest {
  const UpdateSettingsRequest({
    required this.themeMode,
    required this.aiVerbosity,
    required this.analyticsEnabled,
  });

  final String themeMode;
  final String aiVerbosity;
  final bool analyticsEnabled;
}

class UpdateSettingsResponse {
  const UpdateSettingsResponse({
    required this.themeMode,
    required this.aiVerbosity,
    required this.analyticsEnabled,
    required this.updatedAtIso,
  });

  final String themeMode;
  final String aiVerbosity;
  final bool analyticsEnabled;
  final String updatedAtIso;
}

class UpdateSettingsApiContract
    implements ApiContract<UpdateSettingsRequest, UpdateSettingsResponse> {
  @override
  String get method => 'PUT';

  @override
  String get path => '/settings/update';

  @override
  UpdateSettingsResponse parseResponse(Map<String, dynamic> json) {
    return UpdateSettingsResponse(
      themeMode: json['themeMode'] as String,
      aiVerbosity: json['aiVerbosity'] as String,
      analyticsEnabled: json['analyticsEnabled'] as bool,
      updatedAtIso: json['updatedAt'] as String,
    );
  }

  @override
  Map<String, dynamic> toRequest(UpdateSettingsRequest request) {
    return <String, dynamic>{
      'themeMode': request.themeMode,
      'aiVerbosity': request.aiVerbosity,
      'analyticsEnabled': request.analyticsEnabled,
    };
  }
}
