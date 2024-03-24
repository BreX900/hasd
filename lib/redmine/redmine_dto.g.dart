// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, avoid_annotating_with_dynamic

part of 'redmine_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$IssueDto {
  IssueDto get _self => this as IssueDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.project == other.project &&
          _self.tracker == other.tracker &&
          _self.status == other.status &&
          _self.priority == other.priority &&
          _self.author == other.author &&
          _self.assignedTo == other.assignedTo &&
          _self.fixedVersion == other.fixedVersion &&
          _self.parentId == other.parentId &&
          _self.subject == other.subject &&
          _self.description == other.description &&
          _self.startDate == other.startDate &&
          _self.dueDate == other.dueDate &&
          _self.doneRatio == other.doneRatio &&
          _self.isPrivate == other.isPrivate &&
          _self.isFavorited == other.isFavorited &&
          _self.estimatedHours == other.estimatedHours &&
          _self.createdOn == other.createdOn &&
          _self.updatedOn == other.updatedOn &&
          _self.closedOn == other.closedOn &&
          _self.attachments == other.attachments &&
          _self.journals == other.journals &&
          _self.children == other.children;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.project.hashCode);
    hashCode = $hashCombine(hashCode, _self.tracker.hashCode);
    hashCode = $hashCombine(hashCode, _self.status.hashCode);
    hashCode = $hashCombine(hashCode, _self.priority.hashCode);
    hashCode = $hashCombine(hashCode, _self.author.hashCode);
    hashCode = $hashCombine(hashCode, _self.assignedTo.hashCode);
    hashCode = $hashCombine(hashCode, _self.fixedVersion.hashCode);
    hashCode = $hashCombine(hashCode, _self.parentId.hashCode);
    hashCode = $hashCombine(hashCode, _self.subject.hashCode);
    hashCode = $hashCombine(hashCode, _self.description.hashCode);
    hashCode = $hashCombine(hashCode, _self.startDate.hashCode);
    hashCode = $hashCombine(hashCode, _self.dueDate.hashCode);
    hashCode = $hashCombine(hashCode, _self.doneRatio.hashCode);
    hashCode = $hashCombine(hashCode, _self.isPrivate.hashCode);
    hashCode = $hashCombine(hashCode, _self.isFavorited.hashCode);
    hashCode = $hashCombine(hashCode, _self.estimatedHours.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdOn.hashCode);
    hashCode = $hashCombine(hashCode, _self.updatedOn.hashCode);
    hashCode = $hashCombine(hashCode, _self.closedOn.hashCode);
    hashCode = $hashCombine(hashCode, _self.attachments.hashCode);
    hashCode = $hashCombine(hashCode, _self.journals.hashCode);
    hashCode = $hashCombine(hashCode, _self.children.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('IssueDto')
        ..add('id', _self.id)
        ..add('project', _self.project)
        ..add('tracker', _self.tracker)
        ..add('status', _self.status)
        ..add('priority', _self.priority)
        ..add('author', _self.author)
        ..add('assignedTo', _self.assignedTo)
        ..add('fixedVersion', _self.fixedVersion)
        ..add('parentId', _self.parentId)
        ..add('subject', _self.subject)
        ..add('description', _self.description)
        ..add('startDate', _self.startDate)
        ..add('dueDate', _self.dueDate)
        ..add('doneRatio', _self.doneRatio)
        ..add('isPrivate', _self.isPrivate)
        ..add('isFavorited', _self.isFavorited)
        ..add('estimatedHours', _self.estimatedHours)
        ..add('createdOn', _self.createdOn)
        ..add('updatedOn', _self.updatedOn)
        ..add('closedOn', _self.closedOn)
        ..add('attachments', _self.attachments)
        ..add('journals', _self.journals)
        ..add('children', _self.children))
      .toString();
}

mixin _$IssueStatusDto {
  IssueStatusDto get _self => this as IssueStatusDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueStatusDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.name == other.name &&
          _self.isClosed == other.isClosed;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.name.hashCode);
    hashCode = $hashCombine(hashCode, _self.isClosed.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('IssueStatusDto')
        ..add('id', _self.id)
        ..add('name', _self.name)
        ..add('isClosed', _self.isClosed))
      .toString();
}

mixin _$Reference {
  Reference get _self => this as Reference;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reference &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.name == other.name;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.name.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('Reference')
        ..add('id', _self.id)
        ..add('name', _self.name))
      .toString();
}

mixin _$AttachmentDto {
  AttachmentDto get _self => this as AttachmentDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.filename == other.filename &&
          _self.filesize == other.filesize &&
          _self.contentType == other.contentType &&
          _self.description == other.description &&
          _self.contentUrl == other.contentUrl &&
          _self.hrefUrl == other.hrefUrl &&
          _self.author == other.author &&
          _self.createdOn == other.createdOn;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.filename.hashCode);
    hashCode = $hashCombine(hashCode, _self.filesize.hashCode);
    hashCode = $hashCombine(hashCode, _self.contentType.hashCode);
    hashCode = $hashCombine(hashCode, _self.description.hashCode);
    hashCode = $hashCombine(hashCode, _self.contentUrl.hashCode);
    hashCode = $hashCombine(hashCode, _self.hrefUrl.hashCode);
    hashCode = $hashCombine(hashCode, _self.author.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdOn.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('AttachmentDto')
        ..add('id', _self.id)
        ..add('filename', _self.filename)
        ..add('filesize', _self.filesize)
        ..add('contentType', _self.contentType)
        ..add('description', _self.description)
        ..add('contentUrl', _self.contentUrl)
        ..add('hrefUrl', _self.hrefUrl)
        ..add('author', _self.author)
        ..add('createdOn', _self.createdOn))
      .toString();
}

mixin _$JournalDto {
  JournalDto get _self => this as JournalDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.user == other.user &&
          _self.notes == other.notes &&
          _self.createdOn == other.createdOn &&
          _self.privateNotes == other.privateNotes &&
          _self.details == other.details;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.user.hashCode);
    hashCode = $hashCombine(hashCode, _self.notes.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdOn.hashCode);
    hashCode = $hashCombine(hashCode, _self.privateNotes.hashCode);
    hashCode = $hashCombine(hashCode, _self.details.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('JournalDto')
        ..add('id', _self.id)
        ..add('user', _self.user)
        ..add('notes', _self.notes)
        ..add('createdOn', _self.createdOn)
        ..add('privateNotes', _self.privateNotes)
        ..add('details', _self.details))
      .toString();
}

mixin _$JournalDetailDto {
  JournalDetailDto get _self => this as JournalDetailDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalDetailDto &&
          runtimeType == other.runtimeType &&
          _self.property == other.property &&
          _self.name == other.name &&
          _self.oldValue == other.oldValue &&
          _self.newValue == other.newValue;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.property.hashCode);
    hashCode = $hashCombine(hashCode, _self.name.hashCode);
    hashCode = $hashCombine(hashCode, _self.oldValue.hashCode);
    hashCode = $hashCombine(hashCode, _self.newValue.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('JournalDetailDto')
        ..add('property', _self.property)
        ..add('name', _self.name)
        ..add('oldValue', _self.oldValue)
        ..add('newValue', _self.newValue))
      .toString();
}

mixin _$IssueChildDto {
  IssueChildDto get _self => this as IssueChildDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueChildDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.tracker == other.tracker &&
          _self.subject == other.subject &&
          _self.children == other.children;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.tracker.hashCode);
    hashCode = $hashCombine(hashCode, _self.subject.hashCode);
    hashCode = $hashCombine(hashCode, _self.children.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('IssueChildDto')
        ..add('id', _self.id)
        ..add('tracker', _self.tracker)
        ..add('subject', _self.subject)
        ..add('children', _self.children))
      .toString();
}

mixin _$IssueUpdateDto {
  IssueUpdateDto get _self => this as IssueUpdateDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueUpdateDto &&
          runtimeType == other.runtimeType &&
          _self.subject == other.subject &&
          _self.description == other.description &&
          _self.estimatedHours == other.estimatedHours &&
          _self.doneRatio == other.doneRatio &&
          _self.statusId == other.statusId &&
          _self.priorityId == other.priorityId &&
          _self.activityId == other.activityId &&
          _self.categoryId == other.categoryId &&
          _self.fixedVersionId == other.fixedVersionId &&
          _self.parentId == other.parentId &&
          _self.assignedToId == other.assignedToId &&
          _self.isPrivate == other.isPrivate &&
          _self.isFavorited == other.isFavorited &&
          _self.easyEmailTo == other.easyEmailTo &&
          _self.easyEmailCc == other.easyEmailCc &&
          _self.startDate == other.startDate &&
          _self.dueDate == other.dueDate &&
          _self.notes == other.notes;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.subject.hashCode);
    hashCode = $hashCombine(hashCode, _self.description.hashCode);
    hashCode = $hashCombine(hashCode, _self.estimatedHours.hashCode);
    hashCode = $hashCombine(hashCode, _self.doneRatio.hashCode);
    hashCode = $hashCombine(hashCode, _self.statusId.hashCode);
    hashCode = $hashCombine(hashCode, _self.priorityId.hashCode);
    hashCode = $hashCombine(hashCode, _self.activityId.hashCode);
    hashCode = $hashCombine(hashCode, _self.categoryId.hashCode);
    hashCode = $hashCombine(hashCode, _self.fixedVersionId.hashCode);
    hashCode = $hashCombine(hashCode, _self.parentId.hashCode);
    hashCode = $hashCombine(hashCode, _self.assignedToId.hashCode);
    hashCode = $hashCombine(hashCode, _self.isPrivate.hashCode);
    hashCode = $hashCombine(hashCode, _self.isFavorited.hashCode);
    hashCode = $hashCombine(hashCode, _self.easyEmailTo.hashCode);
    hashCode = $hashCombine(hashCode, _self.easyEmailCc.hashCode);
    hashCode = $hashCombine(hashCode, _self.startDate.hashCode);
    hashCode = $hashCombine(hashCode, _self.dueDate.hashCode);
    hashCode = $hashCombine(hashCode, _self.notes.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('IssueUpdateDto')
        ..add('subject', _self.subject)
        ..add('description', _self.description)
        ..add('estimatedHours', _self.estimatedHours)
        ..add('doneRatio', _self.doneRatio)
        ..add('statusId', _self.statusId)
        ..add('priorityId', _self.priorityId)
        ..add('activityId', _self.activityId)
        ..add('categoryId', _self.categoryId)
        ..add('fixedVersionId', _self.fixedVersionId)
        ..add('parentId', _self.parentId)
        ..add('assignedToId', _self.assignedToId)
        ..add('isPrivate', _self.isPrivate)
        ..add('isFavorited', _self.isFavorited)
        ..add('easyEmailTo', _self.easyEmailTo)
        ..add('easyEmailCc', _self.easyEmailCc)
        ..add('startDate', _self.startDate)
        ..add('dueDate', _self.dueDate)
        ..add('notes', _self.notes))
      .toString();
}

mixin _$TimEntryDto {
  TimEntryDto get _self => this as TimEntryDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimEntryDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.project == other.project &&
          _self.user == other.user &&
          _self.activity == other.activity &&
          _self.hours == other.hours &&
          _self.comments == other.comments &&
          _self.spentOn == other.spentOn &&
          _self.easyRangeFrom == other.easyRangeFrom &&
          _self.easyRangeTo == other.easyRangeTo &&
          _self.easyExternalId == other.easyExternalId &&
          _self.entityId == other.entityId &&
          _self.entityType == other.entityType &&
          _self.createdOn == other.createdOn &&
          _self.updatedOn == other.updatedOn;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.project.hashCode);
    hashCode = $hashCombine(hashCode, _self.user.hashCode);
    hashCode = $hashCombine(hashCode, _self.activity.hashCode);
    hashCode = $hashCombine(hashCode, _self.hours.hashCode);
    hashCode = $hashCombine(hashCode, _self.comments.hashCode);
    hashCode = $hashCombine(hashCode, _self.spentOn.hashCode);
    hashCode = $hashCombine(hashCode, _self.easyRangeFrom.hashCode);
    hashCode = $hashCombine(hashCode, _self.easyRangeTo.hashCode);
    hashCode = $hashCombine(hashCode, _self.easyExternalId.hashCode);
    hashCode = $hashCombine(hashCode, _self.entityId.hashCode);
    hashCode = $hashCombine(hashCode, _self.entityType.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdOn.hashCode);
    hashCode = $hashCombine(hashCode, _self.updatedOn.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('TimEntryDto')
        ..add('id', _self.id)
        ..add('project', _self.project)
        ..add('user', _self.user)
        ..add('activity', _self.activity)
        ..add('hours', _self.hours)
        ..add('comments', _self.comments)
        ..add('spentOn', _self.spentOn)
        ..add('easyRangeFrom', _self.easyRangeFrom)
        ..add('easyRangeTo', _self.easyRangeTo)
        ..add('easyExternalId', _self.easyExternalId)
        ..add('entityId', _self.entityId)
        ..add('entityType', _self.entityType)
        ..add('createdOn', _self.createdOn)
        ..add('updatedOn', _self.updatedOn))
      .toString();
}

mixin _$ProjectDto {
  ProjectDto get _self => this as ProjectDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.name == other.name &&
          _self.homepage == other.homepage &&
          _self.description == other.description &&
          _self.parent == other.parent &&
          _self.author == other.author &&
          _self.status == other.status &&
          _self.isPublic == other.isPublic &&
          _self.createdOn == other.createdOn &&
          _self.updatedOn == other.updatedOn &&
          _self.startDate == other.startDate &&
          _self.dueDate == other.dueDate &&
          _self.timeEntryActivities == other.timeEntryActivities;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.name.hashCode);
    hashCode = $hashCombine(hashCode, _self.homepage.hashCode);
    hashCode = $hashCombine(hashCode, _self.description.hashCode);
    hashCode = $hashCombine(hashCode, _self.parent.hashCode);
    hashCode = $hashCombine(hashCode, _self.author.hashCode);
    hashCode = $hashCombine(hashCode, _self.status.hashCode);
    hashCode = $hashCombine(hashCode, _self.isPublic.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdOn.hashCode);
    hashCode = $hashCombine(hashCode, _self.updatedOn.hashCode);
    hashCode = $hashCombine(hashCode, _self.startDate.hashCode);
    hashCode = $hashCombine(hashCode, _self.dueDate.hashCode);
    hashCode = $hashCombine(hashCode, _self.timeEntryActivities.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('ProjectDto')
        ..add('id', _self.id)
        ..add('name', _self.name)
        ..add('homepage', _self.homepage)
        ..add('description', _self.description)
        ..add('parent', _self.parent)
        ..add('author', _self.author)
        ..add('status', _self.status)
        ..add('isPublic', _self.isPublic)
        ..add('createdOn', _self.createdOn)
        ..add('updatedOn', _self.updatedOn)
        ..add('startDate', _self.startDate)
        ..add('dueDate', _self.dueDate)
        ..add('timeEntryActivities', _self.timeEntryActivities))
      .toString();
}

mixin _$MembershipDto {
  MembershipDto get _self => this as MembershipDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MembershipDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.project == other.project &&
          _self.user == other.user;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.project.hashCode);
    hashCode = $hashCombine(hashCode, _self.user.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('MembershipDto')
        ..add('id', _self.id)
        ..add('project', _self.project)
        ..add('user', _self.user))
      .toString();
}

mixin _$AppSettings {
  AppSettings get _self => this as AppSettings;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          _self.apiKey == other.apiKey &&
          _self.issueStatutes == other.issueStatutes &&
          _self.doneIssueStatus == other.doneIssueStatus &&
          _self.defaultTimeActivity == other.defaultTimeActivity &&
          _self.issues == other.issues &&
          _self.youtrackApiKey == other.youtrackApiKey &&
          _self.youtrackIssueId == other.youtrackIssueId;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.apiKey.hashCode);
    hashCode = $hashCombine(hashCode, _self.issueStatutes.hashCode);
    hashCode = $hashCombine(hashCode, _self.doneIssueStatus.hashCode);
    hashCode = $hashCombine(hashCode, _self.defaultTimeActivity.hashCode);
    hashCode = $hashCombine(hashCode, _self.issues.hashCode);
    hashCode = $hashCombine(hashCode, _self.youtrackApiKey.hashCode);
    hashCode = $hashCombine(hashCode, _self.youtrackIssueId.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('AppSettings')
        ..add('apiKey', _self.apiKey)
        ..add('issueStatutes', _self.issueStatutes)
        ..add('doneIssueStatus', _self.doneIssueStatus)
        ..add('defaultTimeActivity', _self.defaultTimeActivity)
        ..add('issues', _self.issues)
        ..add('youtrackApiKey', _self.youtrackApiKey)
        ..add('youtrackIssueId', _self.youtrackIssueId))
      .toString();
  AppSettings change(void Function(_AppSettingsChanges c) updates) =>
      (_AppSettingsChanges._(_self)..update(updates)).build();
  _AppSettingsChanges toChanges() => _AppSettingsChanges._(_self);
}

class _AppSettingsChanges {
  _AppSettingsChanges._(AppSettings dc)
      : apiKey = dc.apiKey,
        issueStatutes = dc.issueStatutes,
        doneIssueStatus = dc.doneIssueStatus,
        defaultTimeActivity = dc.defaultTimeActivity,
        issues = dc.issues,
        youtrackApiKey = dc.youtrackApiKey,
        youtrackIssueId = dc.youtrackIssueId;

  String apiKey;

  IList<int> issueStatutes;

  int? doneIssueStatus;

  int? defaultTimeActivity;

  IMap<String, IssueSettings> issues;

  String youtrackApiKey;

  String youtrackIssueId;

  void update(void Function(_AppSettingsChanges c) updates) => updates(this);

  AppSettings build() => AppSettings(
        apiKey: apiKey,
        issueStatutes: issueStatutes,
        doneIssueStatus: doneIssueStatus,
        defaultTimeActivity: defaultTimeActivity,
        issues: issues,
        youtrackApiKey: youtrackApiKey,
        youtrackIssueId: youtrackIssueId,
      );
}

mixin _$IssueSettings {
  IssueSettings get _self => this as IssueSettings;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueSettings &&
          runtimeType == other.runtimeType &&
          _self.info == other.info &&
          _self.docsIn == other.docsIn &&
          _self.blockedBy == other.blockedBy;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.info.hashCode);
    hashCode = $hashCombine(hashCode, _self.docsIn.hashCode);
    hashCode = $hashCombine(hashCode, _self.blockedBy.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('IssueSettings')
        ..add('info', _self.info)
        ..add('docsIn', _self.docsIn)
        ..add('blockedBy', _self.blockedBy))
      .toString();
  IssueSettings change(void Function(_IssueSettingsChanges c) updates) =>
      (_IssueSettingsChanges._(_self)..update(updates)).build();
  _IssueSettingsChanges toChanges() => _IssueSettingsChanges._(_self);
}

class _IssueSettingsChanges {
  _IssueSettingsChanges._(IssueSettings dc)
      : info = dc.info,
        docsIn = dc.docsIn,
        blockedBy = dc.blockedBy;

  String info;

  int? docsIn;

  int? blockedBy;

  void update(void Function(_IssueSettingsChanges c) updates) => updates(this);

  IssueSettings build() => IssueSettings(
        info: info,
        docsIn: docsIn,
        blockedBy: blockedBy,
      );
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueDto _$IssueDtoFromJson(Map<String, dynamic> json) => IssueDto(
      id: json['id'] as int,
      project: Reference.fromJson(json['project'] as Map<String, dynamic>),
      tracker: Reference.fromJson(json['tracker'] as Map<String, dynamic>),
      status: Reference.fromJson(json['status'] as Map<String, dynamic>),
      priority: Reference.fromJson(json['priority'] as Map<String, dynamic>),
      author: Reference.fromJson(json['author'] as Map<String, dynamic>),
      assignedTo:
          Reference.fromJson(json['assigned_to'] as Map<String, dynamic>),
      fixedVersion: json['fixed_version'] == null
          ? null
          : Reference.fromJson(json['fixed_version'] as Map<String, dynamic>),
      parentId: IssueDto._readParent(json, 'parent') as int?,
      subject: json['subject'] as String,
      description: json['description'] as String,
      startDate: json['start_date'] as String,
      dueDate: json['due_date'] as String?,
      doneRatio: json['done_ratio'] as int,
      isPrivate: json['is_private'] as bool,
      isFavorited: json['is_favorited'] as bool,
      estimatedHours: _$JsonConverterFromJson<double, Duration>(
          json['estimated_hours'], const HoursConverter().fromJson),
      createdOn: DateTime.parse(json['created_on'] as String),
      updatedOn: DateTime.parse(json['updated_on'] as String),
      closedOn: json['closed_on'] == null
          ? null
          : DateTime.parse(json['closed_on'] as String),
      attachments: json['attachments'] == null
          ? const IList.empty()
          : IList<AttachmentDto>.fromJson(json['attachments'],
              (value) => AttachmentDto.fromJson(value as Map<String, dynamic>)),
      journals: json['journals'] == null
          ? const IList.empty()
          : IList<JournalDto>.fromJson(json['journals'],
              (value) => JournalDto.fromJson(value as Map<String, dynamic>)),
      children: json['children'] == null
          ? const IList.empty()
          : IList<IssueChildDto>.fromJson(json['children'],
              (value) => IssueChildDto.fromJson(value as Map<String, dynamic>)),
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

IssueStatusDto _$IssueStatusDtoFromJson(Map<String, dynamic> json) =>
    IssueStatusDto(
      id: json['id'] as int,
      name: json['name'] as String,
      isClosed: json['is_closed'] as bool,
    );

Reference _$ReferenceFromJson(Map<String, dynamic> json) => Reference(
      id: json['id'] as int,
      name: json['name'] as String,
    );

AttachmentDto _$AttachmentDtoFromJson(Map<String, dynamic> json) =>
    AttachmentDto(
      id: json['id'] as int,
      filename: json['filename'] as String,
      filesize: json['filesize'] as int,
      contentType: json['content_type'] as String,
      description: json['description'] as String?,
      contentUrl: json['content_url'] as String,
      hrefUrl: json['href_url'] as String,
      author: Reference.fromJson(json['author'] as Map<String, dynamic>),
      createdOn: DateTime.parse(json['created_on'] as String),
    );

JournalDto _$JournalDtoFromJson(Map<String, dynamic> json) => JournalDto(
      id: json['id'] as int,
      user: Reference.fromJson(json['user'] as Map<String, dynamic>),
      notes: json['notes'] as String,
      createdOn: DateTime.parse(json['created_on'] as String),
      privateNotes: json['private_notes'] as bool,
      details: IList<JournalDetailDto>.fromJson(json['details'],
          (value) => JournalDetailDto.fromJson(value as Map<String, dynamic>)),
    );

JournalDetailDto _$JournalDetailDtoFromJson(Map<String, dynamic> json) =>
    JournalDetailDto(
      property: json['property'] as String,
      name: json['name'] as String,
      oldValue: json['old_value'] as String?,
      newValue: json['new_value'] as String?,
    );

IssueChildDto _$IssueChildDtoFromJson(Map<String, dynamic> json) =>
    IssueChildDto(
      id: json['id'] as int,
      tracker: Reference.fromJson(json['tracker'] as Map<String, dynamic>),
      subject: json['subject'] as String,
      children: json['children'] == null
          ? const IList.empty()
          : IList<IssueChildDto>.fromJson(json['children'],
              (value) => IssueChildDto.fromJson(value as Map<String, dynamic>)),
    );

Map<String, dynamic> _$IssueUpdateDtoToJson(IssueUpdateDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('subject', instance.subject);
  writeNotNull('description', instance.description);
  writeNotNull('estimated_hours', instance.estimatedHours);
  writeNotNull('done_ratio', instance.doneRatio);
  writeNotNull('status_id', instance.statusId);
  writeNotNull('priority_id', instance.priorityId);
  writeNotNull('activity_id', instance.activityId);
  writeNotNull('category_id', instance.categoryId);
  writeNotNull('fixed_version_id', instance.fixedVersionId);
  writeNotNull('parent_id', instance.parentId);
  writeNotNull('assigned_to_id', instance.assignedToId);
  writeNotNull('is_private', instance.isPrivate);
  writeNotNull('is_favorited', instance.isFavorited);
  writeNotNull('easy_email_to', instance.easyEmailTo);
  writeNotNull('easy_email_cc', instance.easyEmailCc);
  writeNotNull('start_date', instance.startDate?.toIso8601String());
  writeNotNull('due_date', instance.dueDate?.toIso8601String());
  writeNotNull('notes', instance.notes);
  return val;
}

TimEntryDto _$TimEntryDtoFromJson(Map<String, dynamic> json) => TimEntryDto(
      id: json['id'] as int,
      project: Reference.fromJson(json['project'] as Map<String, dynamic>),
      user: Reference.fromJson(json['user'] as Map<String, dynamic>),
      activity: Reference.fromJson(json['activity'] as Map<String, dynamic>),
      hours: const HoursConverter().fromJson(json['hours'] as double),
      comments: json['comments'] as String? ?? '',
      spentOn: const DateConverter().fromJson(json['spent_on'] as String),
      easyRangeFrom: json['easy_range_from'] as String?,
      easyRangeTo: json['easy_range_to'] as String?,
      easyExternalId: json['easy_external_id'] as int?,
      entityId: json['entity_id'] as int,
      entityType: json['entity_type'] as String,
      createdOn: DateTime.parse(json['created_on'] as String),
      updatedOn: DateTime.parse(json['updated_on'] as String),
    );

ProjectDto _$ProjectDtoFromJson(Map<String, dynamic> json) => ProjectDto(
      id: json['id'] as int,
      name: json['name'] as String,
      homepage: json['homepage'] as String,
      description: json['description'] as String,
      parent: json['parent'] == null
          ? null
          : Reference.fromJson(json['parent'] as Map<String, dynamic>),
      author: Reference.fromJson(json['author'] as Map<String, dynamic>),
      status: json['status'] as int,
      isPublic: json['is_public'] as bool,
      createdOn: DateTime.parse(json['created_on'] as String),
      updatedOn: DateTime.parse(json['updated_on'] as String),
      startDate: json['start_date'] as String,
      dueDate: json['due_date'] as String?,
      timeEntryActivities: IList<Reference>.fromJson(
          json['time_entry_activities'],
          (value) => Reference.fromJson(value as Map<String, dynamic>)),
    );

MembershipDto _$MembershipDtoFromJson(Map<String, dynamic> json) =>
    MembershipDto(
      id: json['id'] as int,
      project: Reference.fromJson(json['project'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : Reference.fromJson(json['user'] as Map<String, dynamic>),
    );

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      apiKey: json['apiKey'] as String? ?? '',
      issueStatutes: json['issueStatutes'] == null
          ? const IListConst([])
          : IList<int>.fromJson(json['issueStatutes'], (value) => value as int),
      doneIssueStatus: json['doneIssueStatus'] as int?,
      defaultTimeActivity: json['defaultTimeActivity'] as int?,
      issues: json['issues'] == null
          ? const IMapConst({})
          : IMap<String, IssueSettings>.fromJson(
              json['issues'] as Map<String, dynamic>,
              (value) => value as String,
              (value) => IssueSettings.fromJson(value as Map<String, dynamic>)),
      youtrackApiKey: json['youtrackApiKey'] as String? ?? '',
      youtrackIssueId: json['youtrackIssueId'] as String? ?? '',
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'issueStatutes': instance.issueStatutes.toJson(
        (value) => value,
      ),
      'doneIssueStatus': instance.doneIssueStatus,
      'defaultTimeActivity': instance.defaultTimeActivity,
      'issues': instance.issues.toJson(
        (value) => value,
        (value) => value,
      ),
      'youtrackApiKey': instance.youtrackApiKey,
      'youtrackIssueId': instance.youtrackIssueId,
    };

IssueSettings _$IssueSettingsFromJson(Map<String, dynamic> json) =>
    IssueSettings(
      info: json['comment'] as String? ?? '',
      docsIn: json['docsIn'] as int?,
      blockedBy: json['blockedBy'] as int?,
    );

Map<String, dynamic> _$IssueSettingsToJson(IssueSettings instance) =>
    <String, dynamic>{
      'comment': instance.info,
      'docsIn': instance.docsIn,
      'blockedBy': instance.blockedBy,
    };

const _$IssuesExtensionsEnumMap = {
  IssuesExtensions.attachments: 'attachments',
  IssuesExtensions.relations: 'relations',
  IssuesExtensions.totalEstimatedTime: 'total_estimated_time',
  IssuesExtensions.spentTime: 'spent_time',
};

const _$IssueExtensionsEnumMap = {
  IssueExtensions.attachments: 'attachments',
  IssueExtensions.relations: 'relations',
  IssueExtensions.children: 'children',
  IssueExtensions.changesets: 'changesets',
  IssueExtensions.journals: 'journals',
  IssueExtensions.watchers: 'watchers',
};
