import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/redmine/redmine_api.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/apis/youtrack/youtrack_dto.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/services/service.dart';
import 'package:mekart/mekart.dart';

abstract final class HasdProviders {
  static Service get _service => Service.instance;

  static final settingsBin = Bin<AppSettings>(
    name: 'redmine_settings',
    deserializer: (data) => AppSettings.fromJson(data as Map<String, dynamic>),
    fallbackData: const AppSettings(),
  );

  static final settings = StreamProvider((ref) => settingsBin.stream.map((e) => e));

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
    await RedmineApi.instance.updateIssue(issue.id, data);

    ref.invalidate(HasdProviders.issues);
    ref.invalidate(HasdProviders.issue(issue.id));
  }

  static Future<void> addComment(
    WidgetRef ref, {
    required IssueModel issue,
    required String comment,
  }) async {
    final data = IssueUpdateDto(notes: comment);
    await RedmineApi.instance.updateIssue(issue.id, data);

    ref.invalidate(HasdProviders.issues);
    ref.invalidate(HasdProviders.issue(issue.id));
  }

  static Future<void> addIssueTime(
    WidgetRef ref, {
    required IssueModel issue,
    required Reference activity,
    required DateTime date,
    required Duration duration,
  }) async {
    date = DateTime.utc(date.year, date.month, date.day);
    final appSettings = await ref.read(HasdProviders.settings.future);

    await RedmineApi.instance.createTimeEntry(
      issueId: issue.id,
      activityId: activity.id,
      date: date,
      duration: duration,
    );
    await YoutrackApi.instance?.createIssueWorkItem(
      appSettings.youtrackIssueId,
      IssueWorkItemDto(
        date: date,
        duration: DurationValueDto(minutes: duration.inMinutes),
        text: issue.hrefUrl,
      ),
    );

    ref.invalidate(HasdProviders.times);

    await HasdProviders.settingsBin.update((data) {
      return data.change((b) => b..defaultTimeActivity = activity.id);
    });
  }

  static Future<void> updateIssueSetting(
    IssueModel issue,
    IssueSettings Function(IssueSettings settings) updates,
  ) async {
    await HasdProviders.settingsBin.update((data) {
      final settings = updates(data.issues['${issue.id}'] ?? const IssueSettings());
      return data.change((b) => b..issues = data.issues.add('${issue.id}', settings));
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
