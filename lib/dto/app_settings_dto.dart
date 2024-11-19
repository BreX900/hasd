import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part '../generated/dto/app_settings_dto.g.dart';

@DataClass(changeable: true)
@JsonSerializable(createFactory: true, createToJson: true)
class AppSettings with _$AppSettings {
  final String apiKey;
  final IList<int> issueStatutes;
  final int? doneIssueStatus;
  final int? defaultTimeActivity;
  final IMap<String, IssueSettings> issues;

  const AppSettings({
    this.apiKey = '',
    this.issueStatutes = const IListConst([]),
    this.doneIssueStatus,
    this.defaultTimeActivity,
    this.issues = const IMapConst({}),
  });

  factory AppSettings.fromJson(Map<String, dynamic> map) => _$AppSettingsFromJson(map);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

@DataClass(changeable: true)
@JsonSerializable(createFactory: true, createToJson: true)
class IssueSettings with _$IssueSettings {
  @JsonKey(name: 'comment')
  final String info;
  final int? docsIn;
  final int? blockedBy;

  const IssueSettings({
    this.info = '',
    this.docsIn,
    this.blockedBy,
  });

  factory IssueSettings.fromJson(Map<String, dynamic> map) => _$IssueSettingsFromJson(map);
  Map<String, dynamic> toJson() => _$IssueSettingsToJson(this);
}
