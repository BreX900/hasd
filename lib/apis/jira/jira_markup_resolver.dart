import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/jira/jira_dto.dart';
import 'package:hasd/apis/jira/jira_markup_dto.dart';

class JiraMarkdownBuilder {
  final IList<JiraAttachmentDto> attachments;
  final JiraMarkupDto data;

  const JiraMarkdownBuilder({
    required this.attachments,
    required this.data,
  });

  String resolve(JiraMarkupDto data) {
    return switch (data) {
      JiraMarkupTextDto() => data.text,
      JiraMarkupParagraphDto() => data.content.map(resolve).join(),
      JiraMarkupDocDto() => data.content.map(resolve).join(),
      JiraMarkupHardBreakDto() => '\n',
      JiraMarkupMediaSingleDto() => data.content.map(resolve).join(),
      JiraMarkupMediaDto() => _resolveMedia(data),
      JiraMarkupMediaInlineDto() => throw UnimplementedError(),
      JiraMarkupMentionDto() => data.text,
      JiraMarkupOrderedListDto() =>
        data.content.mapIndexed((index, e) => '  ${index + 1}. ${resolve(e)}').join('\n'),
      JiraMarkupBulletListDto() => data.content.map((e) => '- ${resolve(e)}').join('\n'),
      JiraMarkupListItemDto() => data.content.map(resolve).join(),
      JiraMarkupInlineCardDto() => data.url,
      JiraMarkupCodeBlockDto() => data.content.map(resolve).join(),
      JiraMarkupHeadingDto() => data.content.map(resolve).join(),
    };
  }

  String _resolveMedia(JiraMarkupMediaDto data) {
    final attachment = attachments.singleWhere((e) => e.filename == data.alt);
    return '![${data.alt}](${attachment.content})';
  }

  @override
  String toString() => resolve(data);
}
