import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:mekart/mekart.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@immutable
class IdOrUid {
  final Object value;

  const IdOrUid.id(int this.value);
  const IdOrUid.uid(String this.value);

  @override
  String toString() => '$value';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdOrUid && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class ProjectModel {
  final int id;
  final IList<Reference>? workLogActivities;

  const ProjectModel({
    required this.id,
    required this.workLogActivities,
  });
}

class WorkLogModel {
  final int issueId;
  final String author;
  final Date spentOn;
  final Duration timeSpent;
  final String activity;
  final String comments;

  const WorkLogModel({
    required this.issueId,
    required this.author,
    required this.spentOn,
    required this.timeSpent,
    required this.activity,
    required this.comments,
  });
}

class IssueModel extends IssueChildModel {
  final Reference project;
  final int? parentId;
  final String hrefUrl;

  final Reference status;
  final Reference author;
  final Reference? assignedTo;
  final DateTime? closedOn;
  final String? dueDate;

  final Object description;

  final IList<AttachmentModel> attachments;
  final IList<JournalDto> journals;

  const IssueModel({
    required super.id,
    required this.project,
    required this.parentId,
    required this.hrefUrl,
    required this.status,
    required this.author,
    required this.assignedTo,
    required this.closedOn,
    required this.dueDate,
    required super.subject,
    required this.description,
    required this.attachments,
    required this.journals,
    required super.children,
  });
}

class IssueChildModel {
  final int id;
  final String subject;
  final IList<IssueChildModel> children;

  const IssueChildModel({
    required this.id,
    required this.subject,
    required this.children,
  });
}

class AttachmentModel {
  final String filename;
  final String mimeType;
  final String? thumbnailUrl;
  final String contentUrl;

  const AttachmentModel({
    required this.filename,
    required this.mimeType,
    required this.thumbnailUrl,
    required this.contentUrl,
  });
}
