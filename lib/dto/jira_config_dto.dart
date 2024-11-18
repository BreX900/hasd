import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:mekart/mekart.dart';

part '../generated/dto/jira_config_dto.g.dart';

@JsonSerializable(createFactory: true, createToJson: true)
class JiraConfigDto {
  static final bin = Bin<JiraConfigDto?>(
    name: 'jira_config.json',
    encoder: const JsonEncoder.withIndent('  '),
    deserializer: (data) => JiraConfigDto.fromJson(data as Map<String, dynamic>),
    fallbackData: null,
  );

  final String baseUrl;
  final String userEmail;
  final String apiToken;

  const JiraConfigDto({
    required this.baseUrl,
    required this.userEmail,
    required this.apiToken,
  });

  factory JiraConfigDto.fromJson(Map<String, dynamic> map) => _$JiraConfigDtoFromJson(map);
  Map<String, dynamic> toJson() => _$JiraConfigDtoToJson(this);
}
