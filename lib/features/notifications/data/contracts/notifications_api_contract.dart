import 'package:lexmastery_mobile/core/network/api_contract.dart';

class UpdateNotificationPreferencesRequest {
  const UpdateNotificationPreferencesRequest({
    required this.studyReminders,
    required this.examAlerts,
    required this.aiSuggestions,
  });

  final String studyReminders;
  final String examAlerts;
  final String aiSuggestions;
}

class UpdateNotificationPreferencesResponse {
  const UpdateNotificationPreferencesResponse({
    required this.studyReminders,
    required this.examAlerts,
    required this.aiSuggestions,
    required this.updatedAtIso,
  });

  final String studyReminders;
  final String examAlerts;
  final String aiSuggestions;
  final String updatedAtIso;
}

class UpdateNotificationPreferencesApiContract
    implements
        ApiContract<UpdateNotificationPreferencesRequest,
            UpdateNotificationPreferencesResponse> {
  @override
  String get method => 'PUT';

  @override
  String get path => '/notifications/update';

  @override
  UpdateNotificationPreferencesResponse parseResponse(
    Map<String, dynamic> json,
  ) {
    return UpdateNotificationPreferencesResponse(
      studyReminders: json['studyReminders'] as String,
      examAlerts: json['examAlerts'] as String,
      aiSuggestions: json['aiSuggestions'] as String,
      updatedAtIso: json['updatedAt'] as String,
    );
  }

  @override
  Map<String, dynamic> toRequest(UpdateNotificationPreferencesRequest request) {
    return <String, dynamic>{
      'studyReminders': request.studyReminders,
      'examAlerts': request.examAlerts,
      'aiSuggestions': request.aiSuggestions,
    };
  }
}
