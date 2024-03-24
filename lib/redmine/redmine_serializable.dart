import 'package:json_annotation/json_annotation.dart';
import 'package:mek/mek.dart';

class RedmineSerializable extends JsonSerializable {
  const RedmineSerializable({
    super.createFactory = false,
    super.createToJson = false,
    super.includeIfNull,
  }) : super(fieldRename: FieldRename.snake, converters: const [HoursConverter(), DateConverter()]);
}

class HoursConverter extends JsonConverter<Duration, double> {
  const HoursConverter();

  static Duration parse(String json) => const HoursConverter().fromJson(double.parse(json));

  @override
  Duration fromJson(double json) =>
      Duration(hours: json.floor(), minutes: (60 * (json % 1)).toInt());

  @override
  double toJson(Duration object) => object.inMinutes / 60;
}

class DateConverter extends JsonConverter<Date, String> {
  const DateConverter();

  @override
  Date fromJson(String json) => Date.parse(json);

  @override
  String toJson(Date object) => '$object';
}
