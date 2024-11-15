import 'package:hasd/apis/jira/jira_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../generated/apis/youtrack/youtrack_dto.g.dart';

@YoutrackSerializable(createFactory: true)
class IssueDto {
  final ProjectDto project;

  const IssueDto({required this.project});

  factory IssueDto.fromJson(Map<String, dynamic> map) => _$IssueDtoFromJson(map);
}

@YoutrackSerializable(createFactory: true)
class ProjectDto {
  final String id;
  final String name;

  const ProjectDto({
    required this.id,
    required this.name,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> map) => _$ProjectDtoFromJson(map);
}

@YoutrackSerializable(createFactory: true)
class IssueWorkItemDto {
  final DurationValueDto duration;
  final DateTime date;
  final String? text;
  final IssueDto issue;

  const IssueWorkItemDto({
    required this.duration,
    required this.date,
    this.text,
    required this.issue,
  });

  factory IssueWorkItemDto.fromJson(Map<String, dynamic> map) => _$IssueWorkItemDtoFromJson(map);
}

@YoutrackSerializable(createToJson: true)
class IssueWorkItemCreateDto {
  final DurationValueDto duration;
  final DateTime date;
  final String? text;

  const IssueWorkItemCreateDto({
    required this.duration,
    required this.date,
    this.text,
  });

  Map<String, dynamic> toJson() => _$IssueWorkItemCreateDtoToJson(this);
}

@YoutrackSerializable(createFactory: true, createToJson: true)
class DurationValueDto {
  final int minutes;

  const DurationValueDto({
    required this.minutes,
  });

  factory DurationValueDto.fromJson(Map<String, dynamic> map) => _$DurationValueDtoFromJson(map);
  Map<String, dynamic> toJson() => _$DurationValueDtoToJson(this);
}

const youtrackConverters = <TypedJsonConverter>[MinutesConverter(), DateTimeConverter()];

class YoutrackSerializable extends JsonSerializable {
  const YoutrackSerializable({
    super.createFactory = false,
    super.createToJson = false,
    super.includeIfNull,
  }) : super(
          fieldRename: FieldRename.snake,
          converters: youtrackConverters,
        );
}

class MinutesConverter extends TypedJsonConverter<Duration, int> {
  const MinutesConverter();

  @override
  Duration fromJson(int json) => Duration(minutes: json);

  @override
  int toJson(Duration object) => object.inMinutes;
}

class DateTimeConverter extends TypedJsonConverter<DateTime, int> {
  const DateTimeConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
