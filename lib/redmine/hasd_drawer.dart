import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/common/utils_more.dart';
import 'package:hasd/redmine/hasd_providers.dart';
import 'package:mek/mek.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
  final _redmineApiKeyFieldBloc = FormControl<String>(
    validators: [Validators.required],
  );

  final _statuesFieldBloc = FormControl<ISet<Reference>>();
  final _doneStatusFieldBloc = FormControl<Reference?>();

  final _youtrackApiTokenFieldBloc = FormControl<String>();
  final _youtrackIssueIdBloc = FormControl<String>();

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

    _statuesFieldBloc.updateValue(issueStatutes.where((e) {
      return appSettings.issueStatutes.contains(e.id);
    }).toISet());
    _statuesFieldBloc.valueChanges
        .map((e) => e ?? const ISet<Reference>.empty())
        .distinct()
        .listen((values) async {
      await HasdProviders.settingsBin.update(
          (data) => data.change((b) => b..issueStatutes = values.map((e) => e.id).toIList()));
    });
    _doneStatusFieldBloc
        .updateValue(issueStatutes.firstWhereOrNull((e) => e.id == appSettings.doneIssueStatus));
    _doneStatusFieldBloc.valueChanges.distinct().listen((value) async {
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
          TypedReactiveTextField(
            formControl: _redmineApiKeyFieldBloc,
            type: const TextFieldType.secret(),
            decoration: InputDecoration(
              labelText: 'Api Key',
              suffixIcon: EditFieldButton(
                toggleableObscureText: true,
                onSubmit: () async {
                  await HasdProviders.settingsBin.update((data) {
                    return data.change((c) => c..apiKey = _redmineApiKeyFieldBloc.value!);
                  });
                  _redmineApiKeyFieldBloc.markAsPristine();
                  _redmineApiKeyFieldBloc.markAsUntouched();
                },
              ),
            ),
          ),
          ReactivePopupMenuButton(
            formControl: _statuesFieldBloc,
            decoration: const InputDecoration(labelText: 'Statues'),
            itemBuilder: (field) => issueStatutes.map((value) {
              return CheckedPopupMenuItem(
                value: value,
                checked: field.value?.contains(value) ?? false,
                child: Text(value.name),
              );
            }).toList(),
            builder: (field) {
              if (field.value?.isEmpty ?? true) return const Text('Please select a issue statues');
              return Text(field.value?.map((e) => e.name).join(', ') ?? '');
            },
          ),
          ReactiveDropdownField<Reference?>(
            formControl: _doneStatusFieldBloc,
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
          TypedReactiveTextField(
            formControl: _youtrackApiTokenFieldBloc,
            type: const TextFieldType.secret(),
            decoration: InputDecoration(
              labelText: 'Api Token',
              suffixIcon: EditFieldButton(
                toggleableObscureText: true,
                onSubmit: () async {
                  await HasdProviders.settingsBin.update((data) {
                    return data.change((c) => c.youtrackApiKey = _youtrackApiTokenFieldBloc.value!);
                  });
                  _youtrackApiTokenFieldBloc.markAsPristine();
                  _youtrackApiTokenFieldBloc.markAsUntouched();
                },
              ),
            ),
          ),
          TypedReactiveTextField(
            formControl: _youtrackIssueIdBloc,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Issue for spent time',
              suffixIcon: EditFieldButton(
                onSubmit: () async {
                  await HasdProviders.settingsBin.update((data) {
                    return data.change((c) => c.youtrackIssueId = _youtrackIssueIdBloc.value!);
                  });
                  _youtrackIssueIdBloc.markAsPristine();
                  _youtrackIssueIdBloc.markAsUntouched();
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
