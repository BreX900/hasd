import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/common/utils.dart';
import 'package:hasd/common/utils_more.dart';
import 'package:hasd/models/models.dart';
import 'package:hasd/providers/providers.dart';
import 'package:hasd/screens/app.dart';
import 'package:hasd/screens/app_drawer.dart';
import 'package:hasd/screens/issue_dialog.dart';
import 'package:hasd/services/service.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:url_launcher/url_launcher.dart';

final _stateProvider = FutureProvider((ref) async {
  final appSettings = await ref.watch(Providers.settings.future);

  final issueStatutes = await ref.watch(Providers.issueStatutes.future);
  final issues = await ref.watch(Providers.issues.future);

  return (appSettings: appSettings, issueStatutes: issueStatutes, issues: issues);
});

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Widget _buildBody({
    required AppSettings appSettings,
    required IList<Reference> issueStatutes,
    required IList<IssueModel> issues,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final statutes = appSettings.issueStatutes
        .mapNonNulls((id) => issueStatutes.firstWhereOrNull((e) => e.id == id));
    final groups = issues.groupListsBy((e) => e.status.id);

    if (statutes.isEmpty) return const InfoView(title: Text('Please select a issue statues'));

    return MultiSplitView(
      children: statutes.map((issueStatus) {
        return DragTarget<IssueModel>(
          onWillAcceptWithDetails: (details) => details.data.status.id != issueStatus.id,
          onAcceptWithDetails: (details) async =>
              Providers.updateIssue(ref, details.data, status: issueStatus),
          builder: (context, draggedIssues, __) {
            final issues = [...draggedIssues.nonNulls, ...?groups[issueStatus.id]];

            return Column(
              children: [
                Text(issueStatus.name, style: textTheme.headlineLarge),
                Expanded(
                  child: ListView.builder(
                    itemCount: issues.length,
                    itemBuilder: (context, index) {
                      final issue = issues[index];

                      return DraggableWithSize<IssueModel>(
                        data: issue,
                        affinity: Axis.horizontal,
                        childWhenDragging: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        child: IssueCard(
                          appSettings: appSettings,
                          issue: issue,
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_stateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
              final issueId = await Service.instance.resolveIssueIdentification(clipboard!.text!);

              if (!context.mounted) return;
              await showDialog(
                context: context,
                builder: (context) => IssueDialog(issueId: issueId),
              );
            },
            icon: const Icon(Icons.open_in_new),
          ),
          IconButton(
            onPressed: () => App.of(context).toggleTimesheet(),
            icon: const Icon(Icons.dashboard),
          ),
        ],
        flexibleSpace: LinearProgressIndicatorBar(isVisible: state.isLoading),
      ),
      drawer: const AppDrawer(),
      body: state.buildScene(
        data: (data) => _buildBody(
          appSettings: data.appSettings,
          issueStatutes: data.issueStatutes,
          issues: data.issues,
        ),
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  final AppSettings appSettings;
  final IssueModel issue;

  const IssueCard({
    super.key,
    required this.appSettings,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    final settings = appSettings.issues['${issue.id}'] ?? const IssueSettings();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final blockedBy = settings.blockedBy;
    final docsIn = settings.docsIn;

    final banners = <Widget>[
      if (blockedBy != null)
        Consumer(builder: (context, ref, _) {
          final issueState = ref.watch(Providers.issue(blockedBy));

          return ListTile(
            onTap: () async => showDialog(
              context: context,
              builder: (context) => IssueDialog(issueId: issueState.requireValue.id),
            ),
            title: Text('Blocked by: $blockedBy'),
            subtitle: Text('Status: ${issueState.buildText(data: (issue) => issue.status.name)}'),
          );
        }),
      if (docsIn != null)
        Consumer(builder: (context, ref, _) {
          final issueState = ref.watch(Providers.issue(docsIn));

          return ListTile(
            onTap: () async => showDialog(
              context: context,
              builder: (context) => IssueDialog(issueId: issueState.requireValue.id),
            ),
            title: Text('Documentation in: $docsIn'),
            subtitle: Text('Status: ${issueState.buildText(data: (issue) => issue.status.name)}'),
          );
        }),
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(issue.subject, style: textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: IssueInfoBar(issue: issue),
        ),
        if (settings.info.isNotEmpty)
          ListTile(
            title: const Text('Personal Info'),
            subtitle: Text(settings.info),
          ),
        if (banners.length == 1)
          banners.single
        else if (banners.length > 1)
          Row(children: banners.map((e) => Expanded(child: e)).toList()),
      ],
    );

    return Card(
      margin: const EdgeInsets.all(4.0),
      elevation: 8.0,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        onTap: () async => showDialog(
          context: context,
          builder: (context) => IssueDialog(issueId: issue.id),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: content,
        ),
      ),
    );
  }
}

class IssueInfoBar extends ConsumerWidget {
  final IssueModel issue;

  const IssueInfoBar({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      runSpacing: 2.0,
      spacing: 4.0,
      children: <Widget>[
        Tooltip(message: 'Project', child: Text(issue.project.name)),
        Tooltip(
          message: 'Id',
          child: InkWell(
            onTap: () async => launchUrl(Uri.parse(issue.hrefUrl)),
            onLongPress: () async => Utils.setClipboard(issue.key),
            onDoubleTap: () async => Utils.setClipboard(issue.hrefUrl),
            child: Text('#${issue.key}'),
          ),
        ),
        Tooltip(message: 'Status', child: Text(issue.status.name)),
        Tooltip(message: 'Author', child: Text(issue.author.name)),
        Tooltip(message: 'Assigned to', child: Text(issue.assignedTo?.name ?? '---')),
        // Tooltip(message: 'Created on', child: Text(formatDateTime(issue.createdOn))),
        // Tooltip(message: 'Updated on', child: Text(formatDateTime(issue.updatedOn))),
        if (issue.closedOn != null)
          Tooltip(message: 'Closed on', child: Text(formatDateTime(issue.closedOn!))),
        if (issue.dueDate != null) Tooltip(message: 'Due date', child: Text(issue.dueDate!)),
      ].expandIndexed((index, child) sync* {
        if (index != 0) yield const Text(' - ');
        yield child;
      }).toList(),
    );
  }
}
