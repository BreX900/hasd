import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:mekart/mekart.dart';

part '../generated/dto/redmine_config_dto.g.dart';

@JsonSerializable(createFactory: true, createToJson: true)
class RedmineConfigDto {
  static final bin = Bin<RedmineConfigDto?>(
    name: 'redmine_config.json',
    encoder: const JsonEncoder.withIndent('  '),
    deserializer: (data) => RedmineConfigDto.fromJson(data as Map<String, dynamic>),
    fallbackData: null,
  );

  final String baseUrl;
  final String apiKey;

  const RedmineConfigDto({
    required this.baseUrl,
    required this.apiKey,
  });

  factory RedmineConfigDto.fromJson(Map<String, dynamic> map) => _$RedmineConfigDtoFromJson(map);
  Map<String, dynamic> toJson() => _$RedmineConfigDtoToJson(this);
}
