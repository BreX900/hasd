import 'package:json_annotation/json_annotation.dart';

part 'youtrack_dto.g.dart';

@YoutrackSerializable(createToJson: true)
class IssueWorkItemDto {
  final DurationValueDto duration;
  final DateTime date;
  final String? text;

  const IssueWorkItemDto({
    required this.duration,
    required this.date,
    this.text,
  });

  Map<String, dynamic> toJson() => _$IssueWorkItemDtoToJson(this);
}

@YoutrackSerializable(createToJson: true)
class DurationValueDto {
  final int minutes;

  const DurationValueDto({
    required this.minutes,
  });

  Map<String, dynamic> toJson() => _$DurationValueDtoToJson(this);
}

class YoutrackSerializable extends JsonSerializable {
  const YoutrackSerializable({
    super.createFactory = false,
    super.createToJson = false,
    super.includeIfNull,
  }) : super(
          fieldRename: FieldRename.snake,
          converters: const [MinutesConverter(), DateTimeConverter()],
        );
}

class MinutesConverter extends JsonConverter<Duration, int> {
  const MinutesConverter();

  @override
  Duration fromJson(int json) => Duration(minutes: json);

  @override
  int toJson(Duration object) => object.inMinutes;
}

class DateTimeConverter extends JsonConverter<DateTime, int> {
  const DateTimeConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
