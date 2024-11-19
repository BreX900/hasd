import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/redmine/redmine_api.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/apis/youtrack/youtrack_dto.dart';
import 'package:hasd/dto/app_settings_dto.dart';
import 'package:hasd/dto/youtrack_config_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/services/redmine_service.dart';
import 'package:hasd/services/service.dart';
import 'package:hasd/shared/instances.dart';
import 'package:mekart/mekart.dart';

abstract final class Providers {
  static Service get _service => Service.instance;
  static RedmineApi get _redmineApi => (_service as RedmineService).api;

  static final youtrackConfig = StreamProvider((ref) => Instances.bin.youtrackConfig.stream);
  static final settings = StreamProvider((ref) => Instances.bin.settings.stream);

  static final project = FutureProvider.family((ref, int projectId) async {
    return await _service.fetchProject(projectId);
  });

  static final projectMembers =
      FutureProvider.family<IList<Reference>, int>((ref, int projectId) async {
    return await _service.fetchProjectMembers(projectId);
  });

  static final issues = FutureProvider((ref) async {
    return await _service.fetchIssues();
  });

  static final issue = FutureProvider.family((ref, int issueId) async {
    return await _service.fetchIssue(issueId);
  });

  static final issueStatutes = FutureProvider((ref) async {
    return await _service.fetchAllIssueStatues();
  });

  static final times =
      FutureProvider.family((ref, ({Date? spentFrom, Date? spentTo, int? issueId}) _) async {
    final (:spentFrom, :spentTo, :issueId) = _;
    return await _service.fetchWorkLogs(
      spentFrom: spentFrom,
      spentTo: spentTo,
      issueId: issueId,
    );
  });

  static Future<void> updateIssue(
    WidgetRef ref,
    IssueModel issue, {
    Reference? status,
    Reference? assignedTo,
  }) async {
    final appSettings = await ref.read(settings.future);
    final data = IssueUpdateDto(
      statusId: status?.id,
      doneRatio: status != null ? (appSettings.doneIssueStatus == status.id ? 100 : null) : null,
      assignedToId: assignedTo?.id,
    );
    await _redmineApi.updateIssue(issue.id, data);

    ref.invalidate(Providers.issues);
    ref.invalidate(Providers.issue(issue.id));
  }

  static Future<void> addComment(
    WidgetRef ref, {
    required IssueModel issue,
    required String comment,
  }) async {
    final data = IssueUpdateDto(notes: comment);
    await _redmineApi.updateIssue(issue.id, data);

    ref.invalidate(Providers.issues);
    ref.invalidate(Providers.issue(issue.id));
  }

  static Future<void> addIssueTime(
    WidgetRef ref, {
    required IssueModel issue,
    required Reference? activity,
    required DateTime date,
    required WorkDuration duration,
  }) async {
    date = DateTime.utc(date.year, date.month, date.day);
    final youtrackConfig = await Instances.bin.youtrackConfig.requireRead();

    await _service.createWorkLog(
      issueId: issue.id,
      activityId: activity?.id,
      started: date,
      timeSpent: duration,
    );
    await YoutrackApi.instance!.createIssueWorkItem(
      youtrackConfig.ticketId,
      IssueWorkItemCreateDto(
        date: date,
        duration: DurationValueDto(minutes: duration.inMinutes),
        text: issue.hrefUrl,
      ),
    );

    ref.invalidate(Providers.times);

    await Instances.bin.runTransaction((tx) async {
      final settings = await tx.settings.read();
      await tx.settings.write(settings.change((b) => b..defaultTimeActivity = activity?.id));
    });
  }

  static Future<void> updateIssueSetting(
    IssueModel issue,
    IssueSettings Function(IssueSettings settings) updates,
  ) async {
    await Instances.bin.runTransaction((tx) async {
      final settings = await tx.settings.read();
      final issueSettings = updates(settings.issues['${issue.id}'] ?? const IssueSettings());
      await tx.settings.write(
          settings.change((b) => b..issues = settings.issues.add('${issue.id}', issueSettings)));
    });
  }

  static Future<IList<T>> fetchAll<T>(
      Future<Iterable<T>> Function(int limit, int offset) fetcher) async {
    const limit = 100;
    var offset = 0;
    final values = <T>[];
    while (true) {
      final page = await fetcher(limit, offset);
      values.addAll(page);
      if (page.length < limit) return values.toIList();
      offset += limit;
    }
  }
}
