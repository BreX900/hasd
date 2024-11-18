import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hasd/apis/redmine/redmine_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part '../../generated/apis/redmine/redmine_dto.g.dart';

@DataClass()
@RedmineSerializable(createFactory: true)
class IssueDto with _$IssueDto implements IssueChildDto {
  @override
  final int id;
  final Reference project;
  @override
  final Reference tracker;
  final Reference status;
  final Reference priority;
  final Reference author;
  final Reference assignedTo;
  final Reference? fixedVersion;
  @JsonKey(name: 'parent', readValue: _readParent)
  final int? parentId;

  @override
  final String subject;
  final String description;
  final String startDate;
  final String? dueDate;
  final int doneRatio;
  final bool isPrivate;
  final bool isFavorited;
  final Duration? estimatedHours;

  final DateTime createdOn;
  final DateTime updatedOn;
  final DateTime? closedOn;

  @JsonKey(defaultValue: IList.empty)
  final IList<AttachmentDto> attachments;
  @JsonKey(defaultValue: IList.empty)
  final IList<JournalDto> journals;
  @override
  @JsonKey(defaultValue: IList.empty)
  final IList<IssueChildDto> children;

  const IssueDto({
    required this.id,
    required this.project,
    required this.tracker,
    required this.status,
    required this.priority,
    required this.author,
    required this.assignedTo,
    required this.fixedVersion,
    required this.parentId,
    required this.subject,
    required this.description,
    required this.startDate,
    required this.dueDate,
    required this.doneRatio,
    required this.isPrivate,
    required this.isFavorited,
    required this.estimatedHours,
    required this.createdOn,
    required this.updatedOn,
    required this.closedOn,
    required this.attachments,
    required this.journals,
    required this.children,
  });

  factory IssueDto.fromJson(Map<String, dynamic> map) => _$IssueDtoFromJson(map);

  static Object? _readParent(Map map, String key) => (map[key] as Map?)?['id'];
}

@DataClass()
@RedmineSerializable(createFactory: true)
class IssueStatusDto with _$IssueStatusDto {
  final int id;
  final String name;
  final bool isClosed;

  const IssueStatusDto({
    required this.id,
    required this.name,
    required this.isClosed,
  });

  factory IssueStatusDto.fromJson(Map<String, dynamic> map) => _$IssueStatusDtoFromJson(map);
}

@DataClass()
@RedmineSerializable(createFactory: true)
class Reference with _$Reference {
  final int id;
  final String name;

  const Reference(this.id, this.name);

  factory Reference.fromJson(Map<String, dynamic> map) => _$ReferenceFromJson(map);
}

@DataClass()
@RedmineSerializable(createFactory: true)
class AttachmentDto with _$AttachmentDto {
  final int id;
  final String filename;
  final int filesize;
  final String contentType;
  final String? description;
  final String contentUrl;
  final String hrefUrl;
  final Reference author;
  final DateTime createdOn;

  const AttachmentDto({
    required this.id,
    required this.filename,
    required this.filesize,
    required this.contentType,
    required this.description,
    required this.contentUrl,
    required this.hrefUrl,
    required this.author,
    required this.createdOn,
  });

  factory AttachmentDto.fromJson(Map<String, dynamic> map) => _$AttachmentDtoFromJson(map);
}

@DataClass()
@RedmineSerializable(createFactory: true)
class JournalDto with _$JournalDto {
  final int id;
  final Reference user;
  final String notes;
  final DateTime createdOn;
  final bool privateNotes;
  final IList<JournalDetailDto> details;

  const JournalDto({
    required this.id,
    required this.user,
    required this.notes,
    required this.createdOn,
    required this.privateNotes,
    required this.details,
  });

  factory JournalDto.fromJson(Map<String, dynamic> map) => _$JournalDtoFromJson(map);
}

@DataClass()
@RedmineSerializable(createFactory: true)
class JournalDetailDto with _$JournalDetailDto {
  static const String estimatedHours = 'estimated_hours';
  static const String statusId = 'status_id';
  static const String subtask = 'subtask';
  static const String fixedVersionId = 'fixed_version_id';
  static const String dueDate = 'due_date';

  final String property;
  final String name;
  final String? oldValue;
  final String? newValue;

  const JournalDetailDto({
    required this.property,
    required this.name,
    this.oldValue,
    required this.newValue,
  });

  factory JournalDetailDto.fromJson(Map<String, dynamic> map) => _$JournalDetailDtoFromJson(map);
}

@DataClass()
@RedmineSerializable(createFactory: true)
class IssueChildDto with _$IssueChildDto {
  final int id;
  final Reference tracker;
  final String subject;
  @JsonKey(defaultValue: IList.empty)
  final IList<IssueChildDto> children;

  const IssueChildDto({
    required this.id,
    required this.tracker,
    required this.subject,
    required this.children,
  });

  factory IssueChildDto.fromJson(Map<String, dynamic> map) => _$IssueChildDtoFromJson(map);
}

@JsonEnum(fieldRename: FieldRename.snake, alwaysCreate: true)
enum IssuesExtensions {
  attachments,
  relations,
  totalEstimatedTime,
  spentTime;

  String get code => _$IssuesExtensionsEnumMap[this]!;
}

@JsonEnum(fieldRename: FieldRename.snake, alwaysCreate: true)
enum IssueExtensions {
  attachments,
  relations,
  children,
  changesets,
  journals,
  watchers;

  String get code => _$IssueExtensionsEnumMap[this]!;
}

@DataClass()
@RedmineSerializable(createToJson: true, includeIfNull: false)
class IssueUpdateDto with _$IssueUpdateDto {
  // final String? easy_external_id;
  final String? subject;
  final String? description;
  final String? estimatedHours;
  final int? doneRatio;
  // final int?project_id*;
  // final int?tracker_id*;
  final int? statusId;
  final int? priorityId;
  final int? activityId;
  final int? categoryId;
  final int? fixedVersionId;
  final int? parentId;
  // final int?author_id*;
  final int? assignedToId;
  final bool? isPrivate;
  final bool? isFavorited;
  final String? easyEmailTo;
  final String? easyEmailCc;
  final DateTime? startDate;
  final DateTime? dueDate;
// final custom_fields	[...];
  // final tag_list	[...];

  // TODO: try this field to add a comment to issue
  final String? notes;

  const IssueUpdateDto({
    this.subject,
    this.description,
    this.estimatedHours,
    this.doneRatio,
    this.statusId,
    this.priorityId,
    this.activityId,
    this.categoryId,
    this.fixedVersionId,
    this.parentId,
    this.assignedToId,
    this.isPrivate,
    this.isFavorited,
    this.easyEmailTo,
    this.easyEmailCc,
    this.startDate,
    this.dueDate,
    this.notes,
  });

  Map<String, dynamic> toJson() => _$IssueUpdateDtoToJson(this);
}

@DataClass()
@RedmineSerializable(createFactory: true)
class TimEntryDto with _$TimEntryDto {
  final int id;
  final Reference project;
  // "issue": {"id": 0},
  final Reference user;
  final Reference activity;
  final Duration hours;
  final String comments;
  final Date spentOn;
  final String? easyRangeFrom;
  final String? easyRangeTo;
  final int? easyExternalId;
  final int entityId;
  final String entityType; // "Issue",
  final DateTime createdOn;
  final DateTime updatedOn;

  const TimEntryDto({
    required this.id,
    required this.project,
    required this.user,
    required this.activity,
    required this.hours,
    this.comments = '',
    required this.spentOn,
    this.easyRangeFrom,
    required this.easyRangeTo,
    this.easyExternalId,
    required this.entityId,
    required this.entityType,
    required this.createdOn,
    required this.updatedOn,
  });

  factory TimEntryDto.fromJson(Map<String, dynamic> map) => _$TimEntryDtoFromJson(map);
}

@DataClass()
@RedmineSerializable(createFactory: true)
class ProjectDto with _$ProjectDto {
  final int id;
  final String name;
  final String homepage;
  final String description;
  final Reference? parent;
  final Reference author;
  final int status;
  final bool isPublic;
  final DateTime createdOn;
  final DateTime updatedOn;
  final String startDate;
  final String? dueDate;
  // tag_list
  // trackers
  // issue_categories
  final IList<Reference> timeEntryActivities;
  // enabled_modules

  const ProjectDto({
    required this.id,
    required this.name,
    required this.homepage,
    required this.description,
    required this.parent,
    required this.author,
    required this.status,
    required this.isPublic,
    required this.createdOn,
    required this.updatedOn,
    required this.startDate,
    required this.dueDate,
    required this.timeEntryActivities,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> map) => _$ProjectDtoFromJson(map);
}

@DataClass()
@RedmineSerializable(createFactory: true)
class MembershipDto with _$MembershipDto {
  final int id;
  final Reference project;
  final Reference? user;
  // "roles": [
  // {
  // "id": 0,
  // "name": "Example",
  // "inherited": true
  // },

  const MembershipDto({
    required this.id,
    required this.project,
    required this.user,
  });

  factory MembershipDto.fromJson(Map<String, dynamic> map) => _$MembershipDtoFromJson(map);
}

// Extra

@DataClass(changeable: true)
@JsonSerializable(createFactory: true, createToJson: true)
class AppSettings with _$AppSettings {
  final String apiKey;
  final IList<int> issueStatutes;
  final int? doneIssueStatus;
  final int? defaultTimeActivity;
  final IMap<String, IssueSettings> issues;

  const AppSettings({
    this.apiKey = '',
    this.issueStatutes = const IListConst([]),
    this.doneIssueStatus,
    this.defaultTimeActivity,
    this.issues = const IMapConst({}),
  });

  factory AppSettings.fromJson(Map<String, dynamic> map) => _$AppSettingsFromJson(map);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

@DataClass(changeable: true)
@JsonSerializable(createFactory: true, createToJson: true)
class IssueSettings with _$IssueSettings {
  @JsonKey(name: 'comment')
  final String info;
  final int? docsIn;
  final int? blockedBy;

  const IssueSettings({
    this.info = '',
    this.docsIn,
    this.blockedBy,
  });

  factory IssueSettings.fromJson(Map<String, dynamic> map) => _$IssueSettingsFromJson(map);
  Map<String, dynamic> toJson() => _$IssueSettingsToJson(this);
}
