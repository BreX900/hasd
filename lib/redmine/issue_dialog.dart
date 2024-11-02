import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/apis/redmine/redmine_serializable.dart';
import 'package:hasd/common/utils.dart';
import 'package:hasd/common/utils_more.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/redmine/hasd_providers.dart';
import 'package:intl/intl.dart';
import 'package:mek/mek.dart';
import 'package:url_launcher/url_launcher.dart';

final _issueDialogProvider = FutureProvider.family((ref, int issueId) async {
  final appSettings = await ref.watch(HasdProviders.settings.future);

  final issueStatutes = await ref.watch(HasdProviders.issueStatutes.future);
  final issue = await ref.watch(HasdProviders.issue(issueId).future);
  final project = await ref.watch(HasdProviders.project(issue.project.id).future);
  final users = await ref.watch(HasdProviders.projectMembers(project.id).future);

  final times = await ref.watch(HasdProviders.times((
    spentTo: null,
    spentFrom: null,
    issueId: issueId,
  )).future);

  return (
    appSettings: appSettings,
    project: project,
    issueStatutes: issueStatutes.where((e) => appSettings.issueStatutes.contains(e.id)).toIList(),
    issue: issue,
    users: users,
    times: times
  );
});

class IssueDialog extends ConsumerStatefulWidget {
  final int issueId;

  const IssueDialog({
    super.key,
    required this.issueId,
  });

  @override
  ConsumerState<IssueDialog> createState() => _IssueDialogState();
}

class _IssueDialogState extends ConsumerState<IssueDialog> {
  final _infoFieldBloc = FieldBloc(initialValue: '');

  final _statusFieldBloc = FieldBloc<Reference?>(initialValue: null);
  final _assignedToFieldBloc = FieldBloc<Reference?>(initialValue: null);

  final _commentFieldBloc = FieldBloc(initialValue: '');

  final _timeActivityFieldBloc = FieldBloc<Reference?>(
    initialValue: null,
    validator: const RequiredValidation(),
  );
  final _timeDateFieldBloc = FieldBloc<DateTime>(
    initialValue: DateTime.now(),
  );
  final _timeDurationFieldBloc = FieldBloc<Duration?>(
    initialValue: null,
    validator: const RequiredValidation(),
  );
  late final _timeForm = ListFieldsBloc(fieldBlocs: [
    _timeActivityFieldBloc,
    _timeDateFieldBloc,
    _timeDurationFieldBloc,
  ]);

  final _blockedByFieldBloc = FieldBloc<int?>(initialValue: null);
  final _docsInFieldBloc = FieldBloc<int?>(initialValue: null);

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final (:appSettings, :issueStatutes, :issue, :project, users: _, times: _) =
        await ref.read(_issueDialogProvider(widget.issueId).futureOfData);
    final settings = appSettings.issues['${issue.id}'] ?? const IssueSettings();

    _statusFieldBloc.updateValue(issueStatutes.firstWhereOrNull((e) => e.id == issue.status.id));
    _infoFieldBloc.updateValue(settings.info);
    _assignedToFieldBloc.updateValue(issue.assignedTo);

    _timeActivityFieldBloc.updateValue(project.timeEntryActivities.firstWhereOrNull((e) {
      return e.id == appSettings.defaultTimeActivity;
    }));

    _blockedByFieldBloc.updateValue(settings.blockedBy);
    _docsInFieldBloc.updateValue(settings.docsIn);
  }

  Future<void> _saveInfo(IssueModel issue) async {
    await HasdProviders.updateIssueSetting(issue, (settings) {
      return settings.change((b) => b..info = _infoFieldBloc.state.value);
    });
    _infoFieldBloc.markAsUpdated();
  }

  Future<void> _saveStatus(IssueModel issue) async {
    await HasdProviders.updateIssue(ref, issue, status: _statusFieldBloc.state.value);
    _assignedToFieldBloc.markAsUpdated();
  }

  Future<void> _saveAssignedTo(IssueModel issue) async {
    await HasdProviders.updateIssue(ref, issue, assignedTo: _assignedToFieldBloc.state.value);
    _assignedToFieldBloc.markAsUpdated();
  }

  Future<void> _addComment(IssueModel issue) async {
    await HasdProviders.addComment(
      ref,
      issue: issue,
      comment: _commentFieldBloc.state.value,
    );
    _commentFieldBloc.clear();
  }

  Future<void> _addIssueTime(IssueModel issue) async {
    await HasdProviders.addIssueTime(
      ref,
      issue: issue,
      activity: _timeActivityFieldBloc.state.value!,
      date: _timeDateFieldBloc.state.value,
      duration: _timeDurationFieldBloc.state.value!,
    );
    _timeDurationFieldBloc.updateValue(null);
  }

  Future<void> _saveBlockedBy(IssueModel issue) async {
    await HasdProviders.updateIssueSetting(issue, (settings) {
      return settings.change((b) => b..blockedBy = _blockedByFieldBloc.state.value);
    });
    _blockedByFieldBloc.markAsUpdated();
  }

  Future<void> _saveDocsIn(IssueModel issue) async {
    await HasdProviders.updateIssueSetting(issue, (settings) {
      return settings.change((b) => b..docsIn = _docsInFieldBloc.state.value);
    });
    _docsInFieldBloc.markAsUpdated();
  }

  Widget _buildContent({
    required AppSettings appSettings,
    required ProjectModel project,
    required IList<Reference> issueStatutes,
    required IssueModel issue,
    required IList<Reference> users,
    required IList<WorkLogModel> times,
  }) {
    final attachments = issue.attachments;
    final journals = issue.journals;
    final comments = journals.where((e) => e.notes.isNotEmpty).toList();

    final spentTime = ref.watch(
        _timeDurationFieldBloc.select((state) => formatDuration(state.value ?? Duration.zero)));

    final isTimeFormValid = ref.watchCanSubmit(_timeForm);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final leftSection = ListView(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      children: [
        FieldText<String>(
          fieldBloc: _infoFieldBloc,
          converter: FieldConvert.text,
          decoration: InputDecoration(
            labelText: 'Personal Info',
            suffixIcon: SaveFieldButton(
              fieldBloc: _infoFieldBloc,
              onSubmit: () async => _saveInfo(issue),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(issue.description.trim()),
        ),
      ],
    );
    final rightSection = ListView(
      padding: const EdgeInsets.only(left: 8.0, right: 16.0),
      children: [
        FieldText<int>.from(
          value: issue.id,
          converter: FieldConvert.integer,
          decoration: InputDecoration(
            labelText: 'Id',
            suffixIcon: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () async => launchUrl(Uri.parse(issue.hrefUrl)),
                  child: const ListTile(leading: Icon(Icons.share), title: Text('Open Link')),
                ),
                PopupMenuItem(
                  onTap: () async => Utils.setClipboard(issue.hrefUrl),
                  child: const ListTile(leading: Icon(Icons.link), title: Text('Copy Link')),
                ),
                PopupMenuItem(
                  onTap: () async => Utils.setClipboard('${issue.id}'),
                  child: const ListTile(leading: Icon(Icons.copy), title: Text('Copy Id')),
                ),
              ],
              icon: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        FieldDropdown<Reference?>(
          fieldBloc: _statusFieldBloc,
          decoration: InputDecoration(
            labelText: 'Status',
            suffixIcon: SaveFieldButton(
              fieldBloc: _statusFieldBloc,
              onSubmit: () async => _saveStatus(issue),
            ),
          ),
          items: issueStatutes.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
        ),
        FieldText<Reference>.from(
          value: issue.author,
          converter: FieldConvert.from((value) => value?.name ?? '', (text) => null),
          decoration: const InputDecoration(labelText: 'Author'),
        ),
        FieldTypehead<Reference?>(
          fieldBloc: _assignedToFieldBloc,
          toText: (value) => value?.name ?? '',
          debounceDuration: Duration.zero,
          suggestionsCallback: (text) => users.where((element) {
            return element.name.toLowerCase().contains(text.toLowerCase());
          }).toList(),
          itemBuilder: (context, item) => ListTile(
            title: Text(item!.name),
          ),
          decoration: InputDecoration(
            labelText: 'Assigned to',
            suffixIcon: SaveFieldButton(
              fieldBloc: _assignedToFieldBloc,
              onSubmit: () async => _saveAssignedTo(issue),
            ),
          ),
        ),
        FieldText<String>.from(
          value: issue.dueDate ?? '',
          converter: FieldConvert.text,
          decoration: const InputDecoration(labelText: 'Due date'),
        ),
        if (attachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Wrap(
              spacing: 2.0,
              runSpacing: 2.0,
              children: attachments.map((e) {
                return InputChip(
                  tooltip: e.filename,
                  onPressed: () async => launchFileWebView(context, e),
                  label: Text(e.filename),
                );
              }).toList(),
            ),
          ),
      ],
    );

    final commentsTab = Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[comments.length - index - 1];

              return ListTile(
                title: Text('${formatDateTime(comment.createdOn)} ${comment.user.name}'),
                subtitle: Text(comment.notes),
              );
            },
          ),
        ),
        FieldText<String>(
          fieldBloc: _commentFieldBloc,
          converter: FieldConvert.text,
          padding: const EdgeInsets.all(16.0),
          decoration: InputDecoration(
            labelText: 'Comment',
            suffixIcon: IconButton(
              onPressed: () async => _addComment(issue),
              icon: const Icon(Icons.send),
            ),
          ),
        )
      ],
    );
    final spentTimesTab = Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: times.length,
            itemBuilder: (context, index) {
              final time = times[index];

              return ListTile(
                title: Text('${time.spentOn} ${time.author}: ${formatDuration(time.timeSpent)}'),
                subtitle: Text('${time.activity} ${time.comments}'),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: FieldDropdown(
                  fieldBloc: _timeActivityFieldBloc,
                  decoration: const InputDecoration(labelText: 'Activity'),
                  items: project.timeEntryActivities.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: FieldDateTime(
                  fieldBloc: _timeDateFieldBloc,
                  decoration: const InputDecoration(labelText: 'Date'),
                  format: DateFormat.yMd(Localizations.localeOf(context).languageCode),
                  picker: const DateTimePicker.date(),
                ),
              ),
              Expanded(
                child: FieldText<Duration?>(
                  fieldBloc: _timeDurationFieldBloc,
                  converter: const HoursFieldConverter(),
                  decoration: InputDecoration(
                    labelText: 'Spent time: $spentTime',
                    suffixIcon: IconButton(
                      onPressed: isTimeFormValid ? () async => _addIssueTime(issue) : null,
                      icon: const Icon(Icons.save),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    final changesTab = ListView.builder(
      reverse: true,
      itemCount: journals.length,
      itemBuilder: (context, index) {
        final journal = journals[journals.length - index - 1];

        final details = journal.details.map((detail) {
          return switch (detail.name) {
            JournalDetailDto.estimatedHours => Builder(builder: (context) {
                String format(String? value) {
                  if (value == null) return '---';
                  return formatDuration(HoursConverter.parse(value));
                }

                final oldValue = format(detail.oldValue);
                final newValue = format(detail.newValue);
                return Text('Estimated Hours: $oldValue -> $newValue');
              }),
            JournalDetailDto.statusId => Consumer(builder: (context, ref, _) {
                final statutes = ref.watch(HasdProviders.issueStatutes).valueOrNull;
                if (statutes == null) return const Text('...');

                String format(String? value) {
                  if (value == null) return '---';
                  return statutes.firstWhere((e) => e.id == int.parse(value)).name;
                }

                final oldValue = format(detail.oldValue);
                final newValue = format(detail.newValue);
                return Text('Status: $oldValue -> $newValue');
              }),
            final name => Text('$name: ${detail.oldValue ?? '---'} -> ${detail.newValue}'),
          };
        }).toList();
        return ListTile(
          title: Text('${formatDateTime(journal.createdOn)} ${journal.user.name}'),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (journal.notes.isNotEmpty) Text(journal.notes),
              Wrap(
                spacing: 16.0,
                children: details.map((e) => InputChip(label: e)).toList(),
              ),
            ],
          ),
        );
      },
    );
    final relationsTab = ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: FieldText<int?>(
                fieldBloc: _blockedByFieldBloc,
                converter: FieldConvert.integer,
                decoration: InputDecoration(
                  labelText: 'Blocked by',
                  suffixIcon: SaveFieldButton(
                    fieldBloc: _blockedByFieldBloc,
                    onSubmit: () async => _saveBlockedBy(issue),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FieldText<int?>(
                fieldBloc: _docsInFieldBloc,
                converter: FieldConvert.integer,
                decoration: InputDecoration(
                  labelText: 'Documentation',
                  suffixIcon: SaveFieldButton(
                    fieldBloc: _docsInFieldBloc,
                    onSubmit: () async => _saveDocsIn(issue),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Task Tree', style: textTheme.titleLarge, textAlign: TextAlign.start),
        ),
        IssueTile.buildTreeScene(issue),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: leftSection,
              ),
              Expanded(
                flex: 2,
                child: rightSection,
              ),
            ],
          ),
        ),
        const TabBar(
          tabs: [
            Tab(text: 'Comments'),
            Tab(text: 'Spent times'),
            Tab(text: 'Changes'),
            Tab(text: 'Relations'),
          ],
        ),
        Expanded(
          flex: 3,
          child: TabBarView(
            children: [commentsTab, spentTimesTab, changesTab, relationsTab],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_issueDialogProvider(widget.issueId));
    final issue = state.valueOrNull?.issue;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
          child: Text(issue != null ? issue.subject : '...', style: textTheme.headlineMedium),
        ),
        Expanded(
          child: state.buildScene(
            data: (data) => _buildContent(
              appSettings: data.appSettings,
              project: data.project,
              issueStatutes: data.issueStatutes,
              issue: data.issue,
              users: data.users,
              times: data.times,
            ),
          ),
        ),
      ],
    );

    return DefaultTabController(
      length: 4,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 64.0),
        child: SelectionArea(
          child: content,
        ),
      ),
    );
  }
}

class IssueTile extends StatelessWidget {
  final IssueModel currentIssue;
  final IssueChildModel issue;

  const IssueTile({
    super.key,
    required this.currentIssue,
    required this.issue,
  });

  static final _rootIssueProvider = FutureProvider.family.autoDispose((ref, int parentId) async {
    var currentIssue = await ref.watch(HasdProviders.issue(parentId).future);
    while (currentIssue.parentId != null) {
      currentIssue = await ref.watch(HasdProviders.issue(currentIssue.parentId!).future);
    }
    return currentIssue;
  });

  static Widget buildTreeScene(IssueModel issue) {
    final parentId = issue.parentId;
    if (parentId == null) return IssueTile(currentIssue: issue, issue: issue);

    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(_rootIssueProvider(issue.id));
      return state.buildScene(
        data: (rootIssue) => IssueTile(currentIssue: issue, issue: rootIssue),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      selected: currentIssue.id == issue.id,
      onTap: () async => showDialog(
        context: context,
        builder: (context) => IssueDialog(issueId: issue.id),
      ),
      onLongPress: () async => Utils.setClipboard('${issue.id}'),
      title: Text(issue.subject),
    );
    if (issue.children.isEmpty) return tile;

    return Column(
      children: [
        tile,
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Column(
            children: issue.children.map((issue) {
              return IssueTile(currentIssue: currentIssue, issue: issue);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
