import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/redmine/hasd_providers.dart';
import 'package:hasd/redmine/redmine_dto.dart';
import 'package:hasd/redmine/utils.dart';
import 'package:mek/mek.dart';

final _stateProvider = FutureProvider((ref) async {
  final appSettings = await ref.watch(HasdProviders.settings.future);

  final issueStatutes = await ref.watch(HasdProviders.issueStatutes.future);

  return (
    appSettings: appSettings,
    issueStatutes: issueStatutes,
  );
});

class HasdDrawer extends ConsumerStatefulWidget {
  const HasdDrawer({super.key});

  @override
  ConsumerState<HasdDrawer> createState() => _HasdDrawerState();
}

class _HasdDrawerState extends ConsumerState<HasdDrawer> {
  final _redmineApiKeyFieldBloc = FieldBloc(
    initialValue: '',
    validator: const TextValidation(minLength: 1),
  );

  final _statuesFieldBloc = FieldBloc(initialValue: IList<Reference>());
  final _doneStatusFieldBloc = FieldBloc<Reference?>(initialValue: null);

  final _youtrackApiTokenFieldBloc = FieldBloc(initialValue: '');
  final _youtrackIssueIdBloc = FieldBloc(initialValue: '');

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final (:appSettings, :issueStatutes) = await ref.read(_stateProvider.future);

    _redmineApiKeyFieldBloc.updateValue(appSettings.apiKey);
    _youtrackApiTokenFieldBloc.updateValue(appSettings.youtrackApiKey);
    _youtrackIssueIdBloc.updateValue(appSettings.youtrackIssueId);

    _statuesFieldBloc.updateValue(appSettings.issueStatutes.map((issueStatusId) {
      return issueStatutes.firstWhere((e) => e.id == issueStatusId);
    }).toIList());
    _statuesFieldBloc.stream.map((state) => state.value).distinct().listen((values) async {
      await HasdProviders.settingsBin.update(
          (data) => data.change((b) => b..issueStatutes = values.map((e) => e.id).toIList()));
    });
    _doneStatusFieldBloc
        .updateValue(issueStatutes.firstWhereOrNull((e) => e.id == appSettings.doneIssueStatus));
    _doneStatusFieldBloc.stream.map((state) => state.value).distinct().listen((value) async {
      await HasdProviders.settingsBin
          .update((data) => data.change((b) => b..doneIssueStatus = value?.id));
    });
  }

  Widget _buildContent({required IList<Reference> issueStatutes}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32.0),
          Text('Easy Redmine', style: textTheme.headlineLarge),
          FieldText(
            fieldBloc: _redmineApiKeyFieldBloc,
            converter: FieldConvert.text,
            type: const TextFieldType.secret(),
            decoration: InputDecoration(
              labelText: 'Api Key',
              suffixIcon: EditFieldButton(
                toggleableObscureText: true,
                onSubmit: () async {
                  await HasdProviders.settingsBin.update((data) {
                    return data.change((c) => c..apiKey = _redmineApiKeyFieldBloc.state.value);
                  });
                  _redmineApiKeyFieldBloc.markAsUpdated();
                },
              ),
            ),
          ),
          FieldMultiDropdown(
            fieldBloc: _statuesFieldBloc,
            decoration: const InputDecoration(labelText: 'Statues'),
            itemBuilder: (context, selection) => issueStatutes.map((value) {
              return CheckedPopupMenuItem(
                value: value,
                checked: selection.contains(value),
                child: Text(value.name),
              );
            }).toList(),
            builder: (context, selection) {
              if (selection.isEmpty) return const Text('Please select a issue statues');
              return Text(selection.map((e) => e.name).join(', '));
            },
          ),
          FieldDropdown<Reference?>(
            fieldBloc: _doneStatusFieldBloc,
            decoration: const InputDecoration(
              labelText: 'Status to mark issue with 100% progress.',
            ),
            items: [
              const DropdownMenuItem(child: Text('No status selected.')),
              ...issueStatutes.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(' ${value.name}'),
                );
              }),
            ],
          ),
          const SizedBox(height: 32.0),
          Text('Youtrack', style: textTheme.headlineLarge),
          FieldText(
            fieldBloc: _youtrackApiTokenFieldBloc,
            converter: FieldConvert.text,
            type: const TextFieldType.secret(),
            decoration: InputDecoration(
              labelText: 'Api Token',
              suffixIcon: EditFieldButton(
                toggleableObscureText: true,
                onSubmit: () async {
                  await HasdProviders.settingsBin.update((data) {
                    return data
                        .change((c) => c.youtrackApiKey = _youtrackApiTokenFieldBloc.state.value);
                  });
                  _youtrackApiTokenFieldBloc.markAsUpdated();
                },
              ),
            ),
          ),
          FieldText(
            fieldBloc: _youtrackIssueIdBloc,
            converter: FieldConvert.text,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Issue for spent time',
              suffixIcon: EditFieldButton(
                onSubmit: () async {
                  await HasdProviders.settingsBin.update((data) {
                    return data.change((c) => c.youtrackIssueId = _youtrackIssueIdBloc.state.value);
                  });
                  _youtrackIssueIdBloc.markAsUpdated();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_stateProvider);

    return Drawer(
      child: state.buildScene(data: (data) => _buildContent(issueStatutes: data.issueStatutes)),
    );
  }
}
