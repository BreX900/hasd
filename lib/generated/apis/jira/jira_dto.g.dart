// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, avoid_annotating_with_dynamic

part of '../../../apis/jira/jira_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$JiraPage<T> {
  JiraPage<T> get _self => this as JiraPage<T>;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiraPage<T> &&
          runtimeType == other.runtimeType &&
          _self.expand == other.expand &&
          _self.startAt == other.startAt &&
          _self.maxResults == other.maxResults &&
          _self.total == other.total &&
          _self.records == other.records;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.expand.hashCode);
    hashCode = $hashCombine(hashCode, _self.startAt.hashCode);
    hashCode = $hashCombine(hashCode, _self.maxResults.hashCode);
    hashCode = $hashCombine(hashCode, _self.total.hashCode);
    hashCode = $hashCombine(hashCode, _self.records.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('JiraPage', [T])
        ..add('expand', _self.expand)
        ..add('startAt', _self.startAt)
        ..add('maxResults', _self.maxResults)
        ..add('total', _self.total)
        ..add('records', _self.records))
      .toString();
}

mixin _$JiraPageV2<T> {
  JiraPageV2<T> get _self => this as JiraPageV2<T>;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiraPageV2<T> &&
          runtimeType == other.runtimeType &&
          _self.nextPageToken == other.nextPageToken &&
          _self.records == other.records;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.nextPageToken.hashCode);
    hashCode = $hashCombine(hashCode, _self.records.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('JiraPageV2', [T])
        ..add('nextPageToken', _self.nextPageToken)
        ..add('records', _self.records))
      .toString();
}

mixin _$JiraProjectDto {
  JiraProjectDto get _self => this as JiraProjectDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiraProjectDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.key == other.key &&
          _self.name == other.name;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.key.hashCode);
    hashCode = $hashCombine(hashCode, _self.name.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('JiraProjectDto')
        ..add('id', _self.id)
        ..add('key', _self.key)
        ..add('name', _self.name))
      .toString();
}

mixin _$JiraIssueDto {
  JiraIssueDto get _self => this as JiraIssueDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiraIssueDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.key == other.key &&
          $mapEquality.equals(_self.fields, other.fields) &&
          _self.project == other.project &&
          _self.status == other.status &&
          _self.assignee == other.assignee &&
          _self.creator == other.creator &&
          _self.summary == other.summary;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.key.hashCode);
    hashCode = $hashCombine(hashCode, $mapEquality.hash(_self.fields));
    hashCode = $hashCombine(hashCode, _self.project.hashCode);
    hashCode = $hashCombine(hashCode, _self.status.hashCode);
    hashCode = $hashCombine(hashCode, _self.assignee.hashCode);
    hashCode = $hashCombine(hashCode, _self.creator.hashCode);
    hashCode = $hashCombine(hashCode, _self.summary.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('JiraIssueDto')
        ..add('id', _self.id)
        ..add('key', _self.key)
        ..add('fields', _self.fields)
        ..add('project', _self.project)
        ..add('status', _self.status)
        ..add('assignee', _self.assignee)
        ..add('creator', _self.creator)
        ..add('summary', _self.summary))
      .toString();
}

mixin _$JiraWorkLogDto {
  JiraWorkLogDto get _self => this as JiraWorkLogDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiraWorkLogDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.issueId == other.issueId &&
          _self.author == other.author &&
          _self.updateAuthor == other.updateAuthor &&
          _self.created == other.created &&
          _self.updated == other.updated &&
          _self.started == other.started &&
          _self.timeSpent == other.timeSpent &&
          $mapEquality.equals(_self.comment, other.comment);
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.issueId.hashCode);
    hashCode = $hashCombine(hashCode, _self.author.hashCode);
    hashCode = $hashCombine(hashCode, _self.updateAuthor.hashCode);
    hashCode = $hashCombine(hashCode, _self.created.hashCode);
    hashCode = $hashCombine(hashCode, _self.updated.hashCode);
    hashCode = $hashCombine(hashCode, _self.started.hashCode);
    hashCode = $hashCombine(hashCode, _self.timeSpent.hashCode);
    hashCode = $hashCombine(hashCode, $mapEquality.hash(_self.comment));
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('JiraWorkLogDto')
        ..add('id', _self.id)
        ..add('issueId', _self.issueId)
        ..add('author', _self.author)
        ..add('updateAuthor', _self.updateAuthor)
        ..add('created', _self.created)
        ..add('updated', _self.updated)
        ..add('started', _self.started)
        ..add('timeSpent', _self.timeSpent)
        ..add('comment', _self.comment))
      .toString();
}

mixin _$UserDto {
  UserDto get _self => this as UserDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDto &&
          runtimeType == other.runtimeType &&
          _self.accountId == other.accountId &&
          _self.emailAddress == other.emailAddress &&
          _self.displayName == other.displayName &&
          $mapEquality.equals(_self.avatarUrls, other.avatarUrls) &&
          _self.active == other.active &&
          _self.timeZone == other.timeZone &&
          _self.accountType == other.accountType;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.accountId.hashCode);
    hashCode = $hashCombine(hashCode, _self.emailAddress.hashCode);
    hashCode = $hashCombine(hashCode, _self.displayName.hashCode);
    hashCode = $hashCombine(hashCode, $mapEquality.hash(_self.avatarUrls));
    hashCode = $hashCombine(hashCode, _self.active.hashCode);
    hashCode = $hashCombine(hashCode, _self.timeZone.hashCode);
    hashCode = $hashCombine(hashCode, _self.accountType.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('UserDto')
        ..add('accountId', _self.accountId)
        ..add('emailAddress', _self.emailAddress)
        ..add('displayName', _self.displayName)
        ..add('avatarUrls', _self.avatarUrls)
        ..add('active', _self.active)
        ..add('timeZone', _self.timeZone)
        ..add('accountType', _self.accountType))
      .toString();
}

mixin _$JiraIssueStatusDto {
  JiraIssueStatusDto get _self => this as JiraIssueStatusDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiraIssueStatusDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.name == other.name &&
          $mapEquality.equals(_self.scope, other.scope);
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.name.hashCode);
    hashCode = $hashCombine(hashCode, $mapEquality.hash(_self.scope));
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('JiraIssueStatusDto')
        ..add('id', _self.id)
        ..add('name', _self.name)
        ..add('scope', _self.scope))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JiraProjectDto _$JiraProjectDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraProjectDto',
      json,
      ($checkedConvert) {
        final val = JiraProjectDto(
          id: $checkedConvert('id', (v) => int.parse(v as String)),
          key: $checkedConvert('key', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

JiraIssueDto _$JiraIssueDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraIssueDto',
      json,
      ($checkedConvert) {
        final val = JiraIssueDto(
          id: $checkedConvert('id', (v) => int.parse(v as String)),
          key: $checkedConvert('key', (v) => v as String),
          fields: $checkedConvert('fields', (v) => v as Map<String, dynamic>),
          project: $checkedConvert(
            'project',
            (v) => JiraProjectDto.fromJson(v as Map<String, dynamic>),
            readValue: JiraIssueDto._readFromFields,
          ),
          status: $checkedConvert(
            'status',
            (v) => JiraIssueStatusDto.fromJson(v as Map<String, dynamic>),
            readValue: JiraIssueDto._readFromFields,
          ),
          assignee: $checkedConvert(
            'assignee',
            (v) =>
                v == null ? null : UserDto.fromJson(v as Map<String, dynamic>),
            readValue: JiraIssueDto._readFromFields,
          ),
          creator: $checkedConvert(
            'creator',
            (v) => UserDto.fromJson(v as Map<String, dynamic>),
            readValue: JiraIssueDto._readFromFields,
          ),
          summary: $checkedConvert(
            'summary',
            (v) => v as String,
            readValue: JiraIssueDto._readFromFields,
          ),
        );
        return val;
      },
    );

JiraWorkLogDto _$JiraWorkLogDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraWorkLogDto',
      json,
      ($checkedConvert) {
        final val = JiraWorkLogDto(
          id: $checkedConvert('id', (v) => int.parse(v as String)),
          issueId: $checkedConvert('issueId', (v) => int.parse(v as String)),
          author: $checkedConvert(
              'author', (v) => UserDto.fromJson(v as Map<String, dynamic>)),
          updateAuthor: $checkedConvert('updateAuthor',
              (v) => UserDto.fromJson(v as Map<String, dynamic>)),
          created:
              $checkedConvert('created', (v) => DateTime.parse(v as String)),
          updated:
              $checkedConvert('updated', (v) => DateTime.parse(v as String)),
          started:
              $checkedConvert('started', (v) => DateTime.parse(v as String)),
          timeSpent: $checkedConvert('timeSpentSeconds',
              (v) => JiraWorkLogDto._durationFromSeconds((v as num).toInt())),
          comment:
              $checkedConvert('comment', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
      fieldKeyMap: const {'timeSpent': 'timeSpentSeconds'},
    );

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserDto',
      json,
      ($checkedConvert) {
        final val = UserDto(
          accountId: $checkedConvert('accountId', (v) => v as String),
          emailAddress: $checkedConvert('emailAddress', (v) => v as String?),
          displayName: $checkedConvert('displayName', (v) => v as String),
          avatarUrls:
              $checkedConvert('avatarUrls', (v) => v as Map<String, dynamic>),
          active: $checkedConvert('active', (v) => v as bool),
          timeZone: $checkedConvert('timeZone', (v) => v as String),
          accountType: $checkedConvert('accountType', (v) => v as String),
        );
        return val;
      },
    );

JiraIssueStatusDto _$JiraIssueStatusDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'JiraIssueStatusDto',
      json,
      ($checkedConvert) {
        final val = JiraIssueStatusDto(
          id: $checkedConvert('id', (v) => int.parse(v as String)),
          name: $checkedConvert('name', (v) => v as String),
          scope:
              $checkedConvert('scope', (v) => v as Map<String, dynamic>? ?? {}),
        );
        return val;
      },
    );
