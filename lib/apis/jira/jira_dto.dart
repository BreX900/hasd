import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_markup_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part '../../generated/apis/jira/jira_dto.g.dart';

const jiraConverters = <TypedJsonConverter>[DurationInSecondsConverter(), DateTimeConverter()];

class JiraSerializable extends JsonSerializable {
  const JiraSerializable({
    super.createFactory,
    super.createToJson,
    super.disallowUnrecognizedKeys,
  }) : super(converters: jiraConverters);
}

abstract class TypedJsonConverter<T extends Object, S> extends JsonConverter<T, S> {
  const TypedJsonConverter();

  bool accept(Object object) => object is T;
}

extension JsonConverters on List<TypedJsonConverter> {
  Map<String, Object?> encodeJson(Map<String, Object?> json) {
    return json.map((key, value) => MapEntry(key, _encodeJsonValue(value)));
  }

  Map<String, String> encodeQueryParameters(Map<String, Object?> queryParameters) {
    return Map.fromEntries(queryParameters.entries.mapTo((key, value) {
      final encodedValue = _encodeQueryParametersValue(value);
      if (encodedValue == null) return null;
      return MapEntry(key, encodedValue);
    }).nonNulls);
  }

  Object? _encodeJsonValue(Object? value) {
    if (value == null) return null;
    for (final converter in this) {
      if (converter.accept(value)) return converter.toJson(value);
    }
    if (value is IList) return value.toJson(_encodeJsonValue);
    if (value is ISet) return value.toJson(_encodeJsonValue);
    if (value is IMap) return value.toJson(_encodeJsonValue, _encodeJsonValue);
    return value;
  }

  String? _encodeQueryParametersValue(Object? value) {
    if (value == null) return null;
    for (final converter in this) {
      if (converter.accept(value)) return '${converter.toJson(value)}';
    }
    if (value is bool) return '$value';
    if (value is num) return '$value';
    try {
      // ignore: avoid_dynamic_calls
      return (value as dynamic).toJson();
    } catch (_) {
      return value as String?;
    }
  }
}

class DateTimeConverter extends TypedJsonConverter<DateTime, String> {
  const DateTimeConverter();
  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) {
    final y = (object.year >= -9999 && object.year <= 9999)
        ? _fourDigits(object.year)
        : _sixDigits(object.year);
    final m = _twoDigits(object.month);
    final d = _twoDigits(object.day);
    final h = _twoDigits(object.hour);
    final min = _twoDigits(object.minute);
    final sec = _twoDigits(object.second);
    final ms = _threeDigits(object.millisecond);

    final tzs = object.timeZoneOffset >= Duration.zero ? '+' : '-';
    final tzh = _twoDigits(object.timeZoneOffset.inHours.abs());
    final tzm = _twoDigits(object.timeZoneOffset.inMinutes.abs());

    return '$y-$m-${d}T$h:$min:$sec.$ms$tzs$tzh$tzm';
  }

  static String _fourDigits(int n) {
    final absN = n.abs();
    final sign = n < 0 ? '-' : '';
    if (absN >= 1000) return '$n';
    if (absN >= 100) return '${sign}0$absN';
    if (absN >= 10) return '${sign}00$absN';
    return '${sign}000$absN';
  }

  static String _sixDigits(int n) {
    assert(n < -9999 || n > 9999);
    final absN = n.abs();
    final sign = n < 0 ? '-' : '+';
    if (absN >= 100000) return '$sign$absN';
    return '${sign}0$absN';
  }

  static String _threeDigits(int n) {
    if (n >= 100) return '$n';
    if (n >= 10) return '0$n';
    return '00$n';
  }

  static String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}

class DurationInSecondsConverter extends TypedJsonConverter<Duration, int> {
  const DurationInSecondsConverter();
  @override
  Duration fromJson(int json) => Duration(seconds: json);

  @override
  int toJson(Duration object) => object.inSeconds;
}

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
@JiraSerializable(createFactory: true)
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
@JiraSerializable(createFactory: true)
class JiraProjectRoleDto with _$JiraProjectRoleDto {
  @JsonKey(fromJson: int.parse)
  final int id;
  final String name;

  const JiraProjectRoleDto({
    required this.id,
    required this.name,
  });

  factory JiraProjectRoleDto.fromJson(Map<String, dynamic> map) =>
      _$JiraProjectRoleDtoFromJson(map);
}

@DataClass()
@JiraSerializable(createFactory: true)
class JiraIssueDto with _$JiraIssueDto {
  @JsonKey(fromJson: int.parse)
  final int id;
  final String key;

  final JiraProjectDto project;
  final JiraIssueStatusDto status;
  final UserDto? assignee;
  final UserDto creator;
  final String summary;
  final JiraMarkupDto? description;
  final IList<JiraAttachmentDto> attachment;
  @JsonKey(name: 'timetracking')
  final JiraTimeTracking timeTracking;

  const JiraIssueDto({
    required this.id,
    required this.key,
    required this.project,
    required this.status,
    required this.assignee,
    required this.creator,
    required this.summary,
    required this.description,
    required this.attachment,
    required this.timeTracking,
  });

  // static Object? _readFromFields(Map data, String key) =>
  //     (data['fields'] as Map<String, dynamic>)[key];

  factory JiraIssueDto.fromJson(Map<String, dynamic> map) =>
      _$JiraIssueDtoFromJson({...map['fields'], ...map});
}

@JiraSerializable(createFactory: true)
class JiraAttachmentDto {
  @JsonKey(fromJson: int.parse)
  final int id;
  final String filename;
  final UserDto author;
  final DateTime created;
  final String mimeType;
  final String content; // url
  final String? thumbnail; // url

  const JiraAttachmentDto({
    required this.id,
    required this.filename,
    required this.author,
    required this.created,
    required this.mimeType,
    required this.content,
    required this.thumbnail,
  });

  factory JiraAttachmentDto.fromJson(Map<String, dynamic> map) => _$JiraAttachmentDtoFromJson(map);
}

@JiraSerializable(createFactory: true)
class JiraTimeTracking {
  @JsonKey(name: 'originalEstimateSeconds')
  final WorkDuration? originalEstimate;
  @JsonKey(name: 'remainingEstimateSeconds')
  final WorkDuration? remainingEstimate;

  const JiraTimeTracking({
    required this.originalEstimate,
    required this.remainingEstimate,
  });

  factory JiraTimeTracking.fromJson(Map<String, dynamic> map) => _$JiraTimeTrackingFromJson(map);
}

@DataClass()
@JiraSerializable(createFactory: true)
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
  @JsonKey(name: 'timeSpentSeconds')
  final WorkDuration timeSpent;
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

  factory JiraWorkLogDto.fromJson(Map<String, dynamic> map) => _$JiraWorkLogDtoFromJson(map);
}

@JiraSerializable(createToJson: true)
class JiraWorkLogCreateDto {
  final DateTime started;
  @JsonKey(name: 'timeSpentSeconds')
  final WorkDuration timeSpent;
  final JiraMarkupDocDto? comment;

  const JiraWorkLogCreateDto({
    required this.started,
    required this.timeSpent,
    required this.comment,
  });

  Map<String, dynamic> toJson() => _$JiraWorkLogCreateDtoToJson(this);
}

@DataClass()
@JiraSerializable(createFactory: true)
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
@JiraSerializable(createFactory: true)
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
