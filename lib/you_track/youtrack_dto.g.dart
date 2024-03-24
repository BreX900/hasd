// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, avoid_annotating_with_dynamic

part of 'youtrack_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$IssueWorkItemDtoToJson(IssueWorkItemDto instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'date': const DateTimeConverter().toJson(instance.date),
      'text': instance.text,
    };

Map<String, dynamic> _$DurationValueDtoToJson(DurationValueDto instance) =>
    <String, dynamic>{
      'minutes': instance.minutes,
    };
