import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_dto.dart';
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
  heading,
  blockquote;

  factory JiraMarkupType.fromJson(String source) => $enumDecode(_$JiraMarkupTypeEnumMap, source);
  String toJson() => _$JiraMarkupTypeEnumMap[this]!;
}

sealed class JiraMarkupDto {
  @JsonKey(includeToJson: true, name: 'type')
  JiraMarkupType get type$ => _serializables.entries.firstWhere((e) => e.value.accept(this)).key;

  const JiraMarkupDto();

  static const _serializables = {
    JiraMarkupType.text: _<JiraMarkupTextDto>(JiraMarkupTextDto.fromJson),
    JiraMarkupType.paragraph: _<JiraMarkupParagraphDto>(JiraMarkupParagraphDto.fromJson),
    JiraMarkupType.hardBreak: _<JiraMarkupHardBreakDto>(JiraMarkupHardBreakDto.fromJson),
    JiraMarkupType.doc: _<JiraMarkupDocDto>(JiraMarkupDocDto.fromJson),
    JiraMarkupType.mediaSingle: _<JiraMarkupMediaSingleDto>(JiraMarkupMediaSingleDto.fromJson),
    JiraMarkupType.media: _<JiraMarkupMediaDto>(JiraMarkupMediaDto.fromJson),
    JiraMarkupType.mediaInline: _<JiraMarkupMediaInlineDto>(JiraMarkupMediaInlineDto.fromJson),
    JiraMarkupType.mention: _<JiraMarkupMentionDto>(JiraMarkupMentionDto.fromJson),
    JiraMarkupType.orderedList: _<JiraMarkupOrderedListDto>(JiraMarkupOrderedListDto.fromJson),
    JiraMarkupType.bulletList: _<JiraMarkupBulletListDto>(JiraMarkupBulletListDto.fromJson),
    JiraMarkupType.listItem: _<JiraMarkupListItemDto>(JiraMarkupListItemDto.fromJson),
    JiraMarkupType.inlineCard: _<JiraMarkupInlineCardDto>(JiraMarkupInlineCardDto.fromJson),
    JiraMarkupType.codeBlock: _<JiraMarkupCodeBlockDto>(JiraMarkupCodeBlockDto.fromJson),
    JiraMarkupType.heading: _<JiraMarkupHeadingDto>(JiraMarkupHeadingDto.fromJson),
    JiraMarkupType.blockquote: _<JiraMarkupHardBreakDto>(JiraMarkupHardBreakDto.fromJson),
  };

  factory JiraMarkupDto.fromJson(Map<String, dynamic> map) {
    final data = {...map};
    final rawType = data.remove('type');
    final type = JiraMarkupType.fromJson(rawType);
    final serializable = _serializables[type]!;
    return serializable.fromJson(data);
  }

  Map<String, dynamic> toJson();
}

class _<T> {
  final T Function(Map<String, dynamic>) fromJson;

  bool accept(Object object) => object is T;

  const _(this.fromJson);
}

@_Serializable()
class JiraMarkupTextDto extends JiraMarkupDto {
  final String text;
  @JsonKey(defaultValue: IList<IMap<String, dynamic>>.empty)
  final IList<Map<String, dynamic>> marks;

  const JiraMarkupTextDto({required this.text, required this.marks});

  factory JiraMarkupTextDto.fromJson(Map<String, dynamic> map) => _$JiraMarkupTextDtoFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupTextDtoToJson(this)..remove('marks');
}

@_Serializable()
class JiraMarkupParagraphDto extends JiraMarkupDto {
  final IList<JiraMarkupDto> content;

  const JiraMarkupParagraphDto({required this.content});

  factory JiraMarkupParagraphDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupParagraphDtoFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupParagraphDtoToJson(this);
}

@_Serializable()
class JiraMarkupDocDto extends JiraMarkupDto {
  final int version;
  final IList<JiraMarkupDto> content;

  const JiraMarkupDocDto({
    this.version = 1,
    required this.content,
  });

  factory JiraMarkupDocDto.fromJson(Map<String, dynamic> map) => _$JiraMarkupDocDtoFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupDocDtoToJson(this);
}

@_Serializable()
class JiraMarkupHardBreakDto extends JiraMarkupDto {
  const JiraMarkupHardBreakDto();

  factory JiraMarkupHardBreakDto.fromJson(Map<String, dynamic> map) {
    assert(map.isEmpty, jsonEncode(map));
    return const JiraMarkupHardBreakDto();
  }
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupHardBreakDtoToJson(this);
}

@_Serializable()
class JiraMarkupMediaSingleDto extends JiraMarkupDto {
  final JiraMarkupMediaSingleAttrsDto attrs;
  final IList<JiraMarkupDto> content;

  const JiraMarkupMediaSingleDto({required this.attrs, required this.content});

  factory JiraMarkupMediaSingleDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMediaSingleDtoFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupMediaSingleDtoToJson(this);
}

@_Serializable()
class JiraMarkupMediaSingleAttrsDto {
  final int? width;
  final String layout;

  const JiraMarkupMediaSingleAttrsDto({required this.width, required this.layout});

  factory JiraMarkupMediaSingleAttrsDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMediaSingleAttrsDtoFromJson(map);
  Map<String, dynamic> toJson() => _$JiraMarkupMediaSingleAttrsDtoToJson(this);
}

@_Serializable()
class JiraMarkupMediaDto extends JiraMarkupDto {
  final JiraMarkupMediaAttrsDto attrs;

  const JiraMarkupMediaDto({required this.attrs});

  factory JiraMarkupMediaDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMediaDtoFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupMediaDtoToJson(this);
}

@_Serializable()
class JiraMarkupMediaAttrsDto {
  final String type;
  final String id;
  final String alt;
  final String collection;
  final int height;
  final int width;

  const JiraMarkupMediaAttrsDto({
    required this.type,
    required this.id,
    required this.alt,
    required this.collection,
    required this.height,
    required this.width,
  });

  factory JiraMarkupMediaAttrsDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMediaAttrsDtoFromJson(map);
  Map<String, dynamic> toJson() => _$JiraMarkupMediaAttrsDtoToJson(this);
}

@_Serializable()
class JiraMarkupMediaInlineDto extends JiraMarkupDto {
  final JiraMarkupMediaInlineAttrsDto attrs;

  const JiraMarkupMediaInlineDto({required this.attrs});

  factory JiraMarkupMediaInlineDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMediaInlineDtoFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupMediaInlineDtoToJson(this);
}

@_Serializable()
class JiraMarkupMediaInlineAttrsDto {
  final String id;
  final String collection;
  final String type;

  const JiraMarkupMediaInlineAttrsDto({
    required this.id,
    required this.collection,
    required this.type,
  });

  factory JiraMarkupMediaInlineAttrsDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupMediaInlineAttrsDtoFromJson(map);
  Map<String, dynamic> toJson() => _$JiraMarkupMediaInlineAttrsDtoToJson(this);
}

@_Serializable()
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
  Map<String, dynamic> toJson() => _$JiraMarkupMentionDtoToJson(this);
}

@_Serializable()
class JiraMarkupOrderedListDto extends JiraMarkupDto {
  final int order;
  final IList<JiraMarkupDto> content;

  const JiraMarkupOrderedListDto({required this.order, required this.content});

  factory JiraMarkupOrderedListDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupOrderedListDtoFromJson(map.up('attrs'));
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupOrderedListDtoToJson(this);
}

@_Serializable()
class JiraMarkupBulletListDto extends JiraMarkupDto {
  final IList<JiraMarkupDto> content;

  const JiraMarkupBulletListDto({required this.content});

  factory JiraMarkupBulletListDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupBulletListDtoFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupBulletListDtoToJson(this);
}

@_Serializable()
class JiraMarkupListItemDto extends JiraMarkupDto {
  final IList<JiraMarkupDto> content;

  const JiraMarkupListItemDto({required this.content});

  factory JiraMarkupListItemDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupListItemDtoFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupListItemDtoToJson(this);
}

@_Serializable()
class JiraMarkupInlineCardDto extends JiraMarkupDto {
  final String url;

  const JiraMarkupInlineCardDto({required this.url});

  factory JiraMarkupInlineCardDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupInlineCardDtoFromJson(map.up('attrs'));
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupInlineCardDtoToJson(this);
}

@_Serializable()
class JiraMarkupCodeBlockDto extends JiraMarkupDto {
  final String? language;
  final IList<JiraMarkupDto> content;

  const JiraMarkupCodeBlockDto({required this.language, required this.content});

  factory JiraMarkupCodeBlockDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupCodeBlockDtoFromJson(map.up('attrs'));
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupCodeBlockDtoToJson(this);
}

@_Serializable()
class JiraMarkupHeadingDto extends JiraMarkupDto {
  final int level;
  final IList<JiraMarkupDto> content;

  const JiraMarkupHeadingDto({required this.level, required this.content});

  factory JiraMarkupHeadingDto.fromJson(Map<String, dynamic> map) =>
      _$JiraMarkupHeadingDtoFromJson(map.up('attrs'));
  @override
  Map<String, dynamic> toJson() => _$JiraMarkupHeadingDtoToJson(this);
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

class _Serializable extends JiraSerializable {
  const _Serializable()
      : super(
          createFactory: true,
          createToJson: true,
          disallowUnrecognizedKeys: true,
        );
}

Object? _readAttribute(Map<dynamic, dynamic> map, String key) =>
    (map['attrs'] as Map<String, dynamic>)[key];
