class PromptTemplate {
  const PromptTemplate({
    required this.id,
    required this.name,
    required this.template,
    required this.mode,
  });

  final String id;
  final String name;
  final String template;
  final String mode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'template': template,
      'mode': mode,
    };
  }

  factory PromptTemplate.fromJson(Map<dynamic, dynamic> json) {
    return PromptTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      template: json['template'] as String,
      mode: json['mode'] as String,
    );
  }
}
