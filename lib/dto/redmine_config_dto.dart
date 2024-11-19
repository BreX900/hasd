import 'package:json_annotation/json_annotation.dart';
import 'package:mekart/mekart.dart';

part '../generated/dto/redmine_config_dto.g.dart';

extension JiraConfigBin on BinSession {
  BinStore<RedmineConfigDto?> get redmineConfig => BinStore(
        session: this,
        name: 'redmine_config.json',
        codec: const JsonCodecWithIndent('  '),
        deserializer: (data) => RedmineConfigDto.fromJson(data as Map<String, dynamic>),
        fallbackData: null,
      );
}

@JsonSerializable(createFactory: true, createToJson: true)
class RedmineConfigDto {
  final String baseUrl;
  final String apiKey;

  const RedmineConfigDto({
    required this.baseUrl,
    required this.apiKey,
  });

  factory RedmineConfigDto.fromJson(Map<String, dynamic> map) => _$RedmineConfigDtoFromJson(map);
  Map<String, dynamic> toJson() => _$RedmineConfigDtoToJson(this);
}
