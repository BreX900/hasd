import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part '../../generated/apis/jira/jira_dto.g.dart';

@DataClass()
class JiraPage<T> with _$JiraPage<T> {
  final String? expand;
  final int startAt;
  final int maxResults;
  final int total;
  final IList<T> records;

  const JiraPage({
    required this.expand,
    required this.startAt,
    required this.maxResults,
    required this.total,
    required this.records,
  });

  factory JiraPage.fromJson(
    Map<String, dynamic> map,
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    return $checkedCreate(
      'JiraPage<$T>',
      map,
      ($checkedConvert) {
        return JiraPage<T>(
          expand: $checkedConvert('expand', (v) => v as String?),
          startAt: $checkedConvert('startAt', (v) => (v! as num).toInt()),
          maxResults: $checkedConvert('maxResults', (v) => (v! as num).toInt()),
          total: $checkedConvert('total', (v) => (v! as num).toInt()),
          records: $checkedConvert(key, (v) {
            return IList<T>.fromJson(v, (value) => fromJson(value! as Map<String, dynamic>));
          }),
        );
      },
    );
  }
}

@DataClass()
class JiraPageV2<T> with _$JiraPageV2<T> {
  final String? nextPageToken;
  final IList<T> records;

  const JiraPageV2({
    required this.nextPageToken,
    required this.records,
  });

  factory JiraPageV2.fromJson(
    Map<String, dynamic> map,
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    return $checkedCreate(
      'JiraPage<$T>',
      map,
      ($checkedConvert) {
        return JiraPageV2<T>(
          nextPageToken: $checkedConvert('nextPageToken', (v) => v as String?),
          records: $checkedConvert(key, (v) {
            return IList<T>.fromJson(v, (value) => fromJson(value! as Map<String, dynamic>));
          }),
        );
      },
    );
  }
}

@DataClass()
@JsonSerializable(createFactory: true)
class JiraProjectDto with _$JiraProjectDto {
  @JsonKey(fromJson: int.parse)
  final int id;
  final String key;
  final String name;

  const JiraProjectDto({
    required this.id,
    required this.key,
    required this.name,
  });

  factory JiraProjectDto.fromJson(Map<String, dynamic> map) => _$JiraProjectDtoFromJson(map);
}

@DataClass()
@JsonSerializable(createFactory: true)
class JiraIssueDto with _$JiraIssueDto {
  @JsonKey(fromJson: int.parse)
  final int id;
  final String key;
  final Map<String, dynamic> fields;

  @JsonKey(readValue: _readFromFields)
  final JiraProjectDto project;
  @JsonKey(readValue: _readFromFields)
  final JiraIssueStatusDto status;
  @JsonKey(readValue: _readFromFields)
  final UserDto? assignee;
  @JsonKey(readValue: _readFromFields)
  final UserDto creator;
  @JsonKey(readValue: _readFromFields)
  final String summary;

  const JiraIssueDto({
    required this.id,
    required this.key,
    required this.fields,
    required this.project,
    required this.status,
    required this.assignee,
    required this.creator,
    required this.summary,
  });

  static Object? _readFromFields(Map data, String key) =>
      (data['fields'] as Map<String, dynamic>)[key];

  factory JiraIssueDto.fromJson(Map<String, dynamic> map) => _$JiraIssueDtoFromJson(map);
}

@DataClass()
@JsonSerializable(createFactory: true)
class JiraWorkLogDto with _$JiraWorkLogDto {
  @JsonKey(fromJson: int.parse)
  final int id;
  @JsonKey(fromJson: int.parse)
  final int issueId;
  final UserDto author;
  final UserDto updateAuthor;
  final DateTime created;
  final DateTime updated;
  final DateTime started;
  @JsonKey(name: 'timeSpentSeconds', fromJson: _durationFromSeconds)
  final Duration timeSpent;
  final Map<String, dynamic>? comment;

  const JiraWorkLogDto({
    required this.id,
    required this.issueId,
    required this.author,
    required this.updateAuthor,
    required this.created,
    required this.updated,
    required this.started,
    required this.timeSpent,
    required this.comment,
  });

  static Duration _durationFromSeconds(int seconds) => Duration(seconds: seconds);

  factory JiraWorkLogDto.fromJson(Map<String, dynamic> map) => _$JiraWorkLogDtoFromJson(map);
}

@DataClass()
@JsonSerializable(createFactory: true)
class UserDto with _$UserDto {
  final String accountId;
  final String? emailAddress;
  final String displayName;
  final Map<String, dynamic> avatarUrls;
  final bool active;
  final String timeZone;
  final String accountType;

  const UserDto({
    required this.accountId,
    required this.emailAddress,
    required this.displayName,
    required this.avatarUrls,
    required this.active,
    required this.timeZone,
    required this.accountType,
  });

  factory UserDto.fromJson(Map<String, dynamic> map) => _$UserDtoFromJson(map);
}

@DataClass()
@JsonSerializable(createFactory: true)
class JiraIssueStatusDto with _$JiraIssueStatusDto {
  @JsonKey(fromJson: int.parse)
  final int id;
  final String name;
  // final String description;
  @JsonKey(defaultValue: <String, dynamic>{})
  final Map<String, dynamic> scope;

  const JiraIssueStatusDto({
    required this.id,
    required this.name,
    // required this.description,
    required this.scope,
  });

  factory JiraIssueStatusDto.fromJson(Map<String, dynamic> map) =>
      _$JiraIssueStatusDtoFromJson(map);
}
