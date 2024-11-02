// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, avoid_annotating_with_dynamic

part of '../../../apis/jira/jira_markup_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JiraMarkupTextDto _$JiraMarkupTextDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupTextDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['text', 'marks'],
        );
        final val = JiraMarkupTextDto(
          text: $checkedConvert('text', (v) => v as String),
          marks: $checkedConvert(
              'marks',
              (v) => v == null
                  ? const IList.empty()
                  : IList<Map<String, dynamic>>.fromJson(
                      v, (value) => value as Map<String, dynamic>)),
        );
        return val;
      },
    );

JiraMarkupParagraphDto _$JiraMarkupParagraphDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupParagraphDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['content'],
        );
        final val = JiraMarkupParagraphDto(
          content: $checkedConvert(
              'content',
              (v) => IList<JiraMarkupDto>.fromJson(
                  v,
                  (value) =>
                      JiraMarkupDto.fromJson(value as Map<String, dynamic>))),
        );
        return val;
      },
    );

JiraMarkupDocDto _$JiraMarkupDocDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupDocDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['version', 'content'],
        );
        final val = JiraMarkupDocDto(
          version: $checkedConvert('version', (v) => (v as num).toInt()),
          content: $checkedConvert(
              'content',
              (v) => IList<JiraMarkupDto>.fromJson(
                  v,
                  (value) =>
                      JiraMarkupDto.fromJson(value as Map<String, dynamic>))),
        );
        return val;
      },
    );

JiraMarkupMediaSingleDto _$JiraMarkupMediaSingleDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupMediaSingleDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['width', 'layout', 'content'],
        );
        final val = JiraMarkupMediaSingleDto(
          width: $checkedConvert('width', (v) => (v as num?)?.toInt()),
          layout: $checkedConvert('layout', (v) => v as String),
          content: $checkedConvert(
              'content',
              (v) => IList<JiraMarkupDto>.fromJson(
                  v,
                  (value) =>
                      JiraMarkupDto.fromJson(value as Map<String, dynamic>))),
        );
        return val;
      },
    );

JiraMarkupMediaDto _$JiraMarkupMediaDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupMediaDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'type',
            'id',
            'alt',
            'collection',
            'height',
            'width'
          ],
        );
        final val = JiraMarkupMediaDto(
          type: $checkedConvert('type', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          alt: $checkedConvert('alt', (v) => v as String),
          collection: $checkedConvert('collection', (v) => v as String),
          height: $checkedConvert('height', (v) => (v as num).toInt()),
          width: $checkedConvert('width', (v) => (v as num).toInt()),
        );
        return val;
      },
    );

JiraMarkupMediaInlineDto _$JiraMarkupMediaInlineDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupMediaInlineDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'collection', 'type'],
        );
        final val = JiraMarkupMediaInlineDto(
          id: $checkedConvert('id', (v) => v as String),
          collection: $checkedConvert('collection', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
        );
        return val;
      },
    );

JiraMarkupMentionDto _$JiraMarkupMentionDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupMentionDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'text', 'accessLevel', 'localId'],
        );
        final val = JiraMarkupMentionDto(
          id: $checkedConvert('id', (v) => v as String),
          text: $checkedConvert('text', (v) => v as String),
          accessLevel: $checkedConvert('accessLevel', (v) => v as String),
          localId: $checkedConvert('localId', (v) => v as String),
        );
        return val;
      },
    );

JiraMarkupOrderedListDto _$JiraMarkupOrderedListDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupOrderedListDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['order', 'content'],
        );
        final val = JiraMarkupOrderedListDto(
          order: $checkedConvert('order', (v) => (v as num).toInt()),
          content: $checkedConvert(
              'content',
              (v) => IList<JiraMarkupDto>.fromJson(
                  v,
                  (value) =>
                      JiraMarkupDto.fromJson(value as Map<String, dynamic>))),
        );
        return val;
      },
    );

JiraMarkupBulletListDto _$JiraMarkupBulletListDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupBulletListDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['content'],
        );
        final val = JiraMarkupBulletListDto(
          content: $checkedConvert(
              'content',
              (v) => IList<JiraMarkupDto>.fromJson(
                  v,
                  (value) =>
                      JiraMarkupDto.fromJson(value as Map<String, dynamic>))),
        );
        return val;
      },
    );

JiraMarkupListItemDto _$JiraMarkupListItemDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupListItemDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['content'],
        );
        final val = JiraMarkupListItemDto(
          content: $checkedConvert(
              'content',
              (v) => IList<JiraMarkupDto>.fromJson(
                  v,
                  (value) =>
                      JiraMarkupDto.fromJson(value as Map<String, dynamic>))),
        );
        return val;
      },
    );

JiraMarkupInlineCardDto _$JiraMarkupInlineCardDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupInlineCardDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['url'],
        );
        final val = JiraMarkupInlineCardDto(
          url: $checkedConvert('url', (v) => v as String),
        );
        return val;
      },
    );

JiraMarkupCodeBlockDto _$JiraMarkupCodeBlockDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupCodeBlockDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['content'],
        );
        final val = JiraMarkupCodeBlockDto(
          content: $checkedConvert(
              'content',
              (v) => IList<JiraMarkupDto>.fromJson(
                  v,
                  (value) =>
                      JiraMarkupDto.fromJson(value as Map<String, dynamic>))),
        );
        return val;
      },
    );

JiraMarkupHeadingDto _$JiraMarkupHeadingDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraMarkupHeadingDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['level', 'content'],
        );
        final val = JiraMarkupHeadingDto(
          level: $checkedConvert('level', (v) => (v as num).toInt()),
          content: $checkedConvert(
              'content',
              (v) => IList<JiraMarkupDto>.fromJson(
                  v,
                  (value) =>
                      JiraMarkupDto.fromJson(value as Map<String, dynamic>))),
        );
        return val;
      },
    );

const _$JiraMarkupTypeEnumMap = {
  JiraMarkupType.text: 'text',
  JiraMarkupType.paragraph: 'paragraph',
  JiraMarkupType.hardBreak: 'hardBreak',
  JiraMarkupType.doc: 'doc',
  JiraMarkupType.mediaSingle: 'mediaSingle',
  JiraMarkupType.media: 'media',
  JiraMarkupType.mediaInline: 'mediaInline',
  JiraMarkupType.mention: 'mention',
  JiraMarkupType.orderedList: 'orderedList',
  JiraMarkupType.bulletList: 'bulletList',
  JiraMarkupType.listItem: 'listItem',
  JiraMarkupType.inlineCard: 'inlineCard',
  JiraMarkupType.codeBlock: 'codeBlock',
  JiraMarkupType.heading: 'heading',
};
