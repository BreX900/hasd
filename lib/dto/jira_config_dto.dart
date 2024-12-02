import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part '../generated/dto/jira_config_dto.g.dart';

extension JiraConfigBin on BinSession {
  BinStore<JiraConfigDto?> get jiraConfig => BinStore(
        session: this,
        name: 'jira_config.json',
        codec: const JsonCodecWithIndent('  '),
        deserializer: (data) => JiraConfigDto.fromJson(data as Map<String, dynamic>),
        fallbackData: null,
      );
}

@DataClass(changeable: true)
@JsonSerializable(createFactory: true, createToJson: true)
class JiraConfigDto with _$JiraConfigDto {
  final String baseUrl;
  final String userEmail;
  final String apiToken;
  final IMap<String, String> youtrackIssueByProject;

  const JiraConfigDto({
    required this.baseUrl,
    required this.userEmail,
    required this.apiToken,
    this.youtrackIssueByProject = const IMap.empty(),
  });

  factory JiraConfigDto.fromJson(Map<String, dynamic> map) => _$JiraConfigDtoFromJson(map);
  Map<String, dynamic> toJson() => _$JiraConfigDtoToJson(this);
}
