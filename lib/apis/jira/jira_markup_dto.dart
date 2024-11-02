import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_dto.dart';
import 'package:hasd/common/env.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../generated/apis/jira/jira_markup_dto.g.dart';

@JsonEnum(alwaysCreate: true)
enum JiraMarkupType {
  text,
  paragraph,
  hardBreak,
  doc,
  mediaSingle,
  media,
  mediaInline,
  mention,
  orderedList,
  bulletList,
  listItem,
  inlineCard,
  codeBlock,
  heading;

  factory JiraMarkupType.fromJson(String source) => $enumDecode(_$JiraMarkupTypeEnumMap, source);
}

sealed class JiraMarkupDto {
  const JiraMarkupDto();

  factory JiraMarkupDto.fromJson(Map<String, dynamic> map) {
    final data = {...map};
    final rawType = data.remove('type');
    final type = JiraMarkupType.fromJson(rawType);
    return switch (type) {
      JiraMarkupType.text => JiraMarkupTextDto.fromJson(data),
      JiraMarkupType.paragraph => JiraMarkupParagraphDto.fromJson(data),
      JiraMarkupType.hardBreak => JiraMarkupHardBreakDto.fromJson(data),
      JiraMarkupType.doc => JiraMarkupDocDto.fromJson(data),
      JiraMarkupType.mediaSingle => JiraMarkupMediaSingleDto.fromJson(data),
      JiraMarkupType.media => JiraMarkupMediaDto.fromJson(data),
      JiraMarkupType.mediaInline => JiraMarkupMediaInlineDto.fromJson(data),
      JiraMarkupType.mention => JiraMarkupMentionDto.fromJson(data),
      JiraMarkupType.orderedList => JiraMarkupOrderedListDto.fromJson(data),
      JiraMarkupType.bulletList => JiraMarkupBulletListDto.fromJson(data),
      JiraMarkupType.listItem => JiraMarkupListItemDto.fromJson(data),
      JiraMarkupType.inlineCard => JiraMarkupInlineCardDto.fromJson(data),
      JiraMarkupType.codeBlock => JiraMarkupCodeBlockDto.fromJson(data),
      JiraMarkupType.heading => JiraMarkupHeadingDto.fromJson(data),
    };
  }
}

const _disallowUnrecognizedKeys = true;

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupTextDto extends JiraMarkupDto {
  final String text;
  @JsonKey(defaultValue: IList<IMap<String, dynamic>>.empty)
  final IList<Map<String, dynamic>> marks;

  const JiraMarkupTextDto({required this.text, required this.marks});

  factory JiraMarkupTextDto.fromJson(Map<String, dynamic> map) => _$JiraMarkupTextDtoFromJson(map);

  @override
  String toString() => text;
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupParagraphDto extends JiraMarkupDto {
  final IList<JiraMarkupDto> content;

  const JiraMarkupParagraphDto({required this.content});

  factory JiraMarkupParagraphDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupParagraphDtoFromJson(map);

  @override
  String toString() => content.join();
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupDocDto extends JiraMarkupDto {
  final int version;
  final IList<JiraMarkupDto> content;

  const JiraMarkupDocDto({required this.version, required this.content});

  factory JiraMarkupDocDto.fromJson(Map<String, dynamic> map) => _$JiraMarkupDocDtoFromJson(map);

  @override
  String toString() => content.join();
}

class JiraMarkupHardBreakDto extends JiraMarkupDto {
  const JiraMarkupHardBreakDto();

  factory JiraMarkupHardBreakDto.fromJson(Map<String, dynamic> map) {
    assert(map.isEmpty, jsonEncode(map));
    return const JiraMarkupHardBreakDto();
  }

  @override
  String toString() => '\n';
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupMediaSingleDto extends JiraMarkupDto {
  final int? width;
  final String layout;
  final IList<JiraMarkupDto> content;

  const JiraMarkupMediaSingleDto({
    required this.width,
    required this.layout,
    required this.content,
  });

  factory JiraMarkupMediaSingleDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMediaSingleDtoFromJson(map.up('attrs'));

  @override
  String toString() => content.join();
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupMediaDto extends JiraMarkupDto {
  final String type;
  final String id;
  final String alt;
  final String collection;
  final int height;
  final int width;

  const JiraMarkupMediaDto({
    required this.type,
    required this.id,
    required this.alt,
    required this.collection,
    required this.height,
    required this.width,
  });

  factory JiraMarkupMediaDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMediaDtoFromJson(map.up('attrs'));

  @override
  String toString() => '[$alt](${Env.jiraApiUrl}/rest/api/3/attachment/thumbnail/$id)';
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupMediaInlineDto extends JiraMarkupDto {
  final String id;
  final String collection;
  final String type;

  const JiraMarkupMediaInlineDto({
    required this.id,
    required this.collection,
    required this.type,
  });

  factory JiraMarkupMediaInlineDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMediaInlineDtoFromJson(map.up('attrs'));

  @override
  String toString() => 'file://$id';
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupMentionDto extends JiraMarkupDto {
  final String id;
  final String text;
  final String accessLevel;
  final String localId;

  const JiraMarkupMentionDto({
    required this.id,
    required this.text,
    required this.accessLevel,
    required this.localId,
  });

  factory JiraMarkupMentionDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMentionDtoFromJson(map.up('attrs'));

  @override
  String toString() => text;
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupOrderedListDto extends JiraMarkupDto {
  final int order;
  final IList<JiraMarkupDto> content;

  const JiraMarkupOrderedListDto({required this.order, required this.content});

  factory JiraMarkupOrderedListDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupOrderedListDtoFromJson(map.up('attrs'));

  @override
  String toString() => content.mapIndexed((index, e) => '  ${index + 1}. $e').join('\n');
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupBulletListDto extends JiraMarkupDto {
  final IList<JiraMarkupDto> content;

  const JiraMarkupBulletListDto({required this.content});

  factory JiraMarkupBulletListDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupBulletListDtoFromJson(map);

  @override
  String toString() => content.map((e) => '- $e').join('\n');
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupListItemDto extends JiraMarkupDto {
  final IList<JiraMarkupDto> content;

  const JiraMarkupListItemDto({required this.content});

  factory JiraMarkupListItemDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupListItemDtoFromJson(map);

  @override
  String toString() => content.join();
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupInlineCardDto extends JiraMarkupDto {
  final String url;

  const JiraMarkupInlineCardDto({required this.url});

  factory JiraMarkupInlineCardDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupInlineCardDtoFromJson(map.up('attrs'));

  @override
  String toString() => url;
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupCodeBlockDto extends JiraMarkupDto {
  final IList<JiraMarkupDto> content;

  const JiraMarkupCodeBlockDto({required this.content});

  factory JiraMarkupCodeBlockDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupCodeBlockDtoFromJson(map.up('attrs'));

  @override
  String toString() => content.join();
}

@JiraSerializable(createFactory: true, disallowUnrecognizedKeys: _disallowUnrecognizedKeys)
class JiraMarkupHeadingDto extends JiraMarkupDto {
  final int level;
  final IList<JiraMarkupDto> content;

  const JiraMarkupHeadingDto({required this.level, required this.content});

  factory JiraMarkupHeadingDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupHeadingDtoFromJson(map.up('attrs'));

  @override
  String toString() => content.join();
}

extension on Map<String, dynamic> {
  Map<String, dynamic> up(String key) {
    final map = {...this};
    final value = map.remove(key) as Map<String, dynamic>;
    final duplicatedKeys = map.keys.where(value.containsKey);
    assert(duplicatedKeys.isEmpty,
        'Duplicated keys: ${duplicatedKeys.join(', ')}: ${jsonEncode(this)}');
    return map..addAll(value);
  }
}

// Object? _readAttribute(Map<dynamic, dynamic> map, String key) =>
//     (map['attrs'] as Map<String, dynamic>)[key];
