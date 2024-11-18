import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/jira/jira_api.dart';
import 'package:hasd/apis/redmine/redmine_api.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/dto/jira_config_dto.dart';
import 'package:hasd/dto/redmine_config_dto.dart';
import 'package:hasd/dto/youtrack_config_dto.dart';
import 'package:hasd/providers/providers.dart';
import 'package:hasd/services/jira_service.dart';
import 'package:hasd/services/redmine_service.dart';
import 'package:hasd/services/service.dart';
import 'package:hasd/shared/env.dart';
import 'package:hasd/shared/utils_more.dart';
import 'package:hasd/widgets/field_padding.dart';
import 'package:mek/mek.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _stateProvider = FutureProvider((ref) async {
  final youtrackConfig = await ref.watch(Providers.youtrackConfig.future);
  final appSettings = await ref.watch(Providers.settings.future);

  final issueStatutes = await ref.watch(Providers.issueStatutes.future);

  return (
    youtrackConfig: youtrackConfig,
    appSettings: appSettings,
    issueStatutes: issueStatutes,
  );
});

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  final _redmineApiKeyFieldBloc = FormControl<String>(
    validators: [Validators.required],
    disabled: true,
  );

  final _statuesFieldBloc = FormControl<ISet<Reference>>();
  final _doneStatusFieldBloc = FormControl<Reference?>();

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final (:youtrackConfig, :appSettings, :issueStatutes) = await ref.read(_stateProvider.future);

    _redmineApiKeyFieldBloc.updateValue(appSettings.apiKey);

    _statuesFieldBloc.updateValue(issueStatutes.where((e) {
      return appSettings.issueStatutes.contains(e.id);
    }).toISet());
    _statuesFieldBloc.valueChanges
        .map((e) => e ?? const ISet<Reference>.empty())
        .distinct()
        .listen((values) async {
      await Providers.settingsBin.update(
          (data) => data.change((b) => b..issueStatutes = values.map((e) => e.id).toIList()));
    });
    _doneStatusFieldBloc
        .updateValue(issueStatutes.firstWhereOrNull((e) => e.id == appSettings.doneIssueStatus));
    _doneStatusFieldBloc.valueChanges.distinct().listen((value) async {
      await Providers.settingsBin
          .update((data) => data.change((b) => b..doneIssueStatus = value?.id));
    });
  }

  Widget _buildContent({required IList<Reference> issueStatutes}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32.0),
        FieldPadding(ReactivePopupMenuButton(
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
            return Text(field.value?.map((e) => e.name).join(', ') ?? '');
          },
        )),
        FieldPadding(ReactiveDropdownField<Reference?>(
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
        )),
        const _YoutrackForm(),
        switch (Env.flavor) {
          Flavor.redmine => const _RedmineForm(),
          Flavor.jira => const _JiraForm(),
        },
      ],
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

class _RedmineForm extends ConsumerStatefulWidget {
  const _RedmineForm();

  @override
  ConsumerState<_RedmineForm> createState() => _RedmineFormState();
}

class _RedmineFormState extends ConsumerState<_RedmineForm> {
  final _baseUrlControl = FormControl<String>(
    validators: [Validators.required],
  );
  final _apiKeyControl = FormControl<String>(
    validators: [Validators.required],
  );

  late final _form = FormArray(disabled: true, [
    _baseUrlControl,
    _apiKeyControl,
  ]);

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final config = await RedmineConfigDto.bin.read();

    _baseUrlControl.updateValue(config?.baseUrl);
    _apiKeyControl.updateValue(config?.apiKey);
  }

  Future<void> _save() async {
    final config = RedmineConfigDto(
      baseUrl: _baseUrlControl.value!,
      apiKey: _apiKeyControl.value!,
    );
    final service = RedmineService(RedmineApi(
      baseUrl: config.baseUrl,
      key: config.apiKey,
    ));
    await service.fetchIssues();
    await RedmineConfigDto.bin.write(config);
    Service.instance = service;
    _form.markAsClean(enabled: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = ref.watch(_form.provider.status.disabled);

    return Column(
      children: [
        const SizedBox(height: 32.0),
        ParagraphTile(
          title: const Text('Easy Redmine'),
          trailing: IconButton(
            onPressed: isDisabled ? _form.markAsEnabled : _form.handleVoidSubmit(_save),
            icon: isDisabled ? const Icon(Icons.edit) : const Icon(Icons.check),
          ),
        ),
        FieldPadding(ReactiveTypedTextField(
          formControl: _baseUrlControl,
          decoration: const InputDecoration(labelText: 'Base url'),
        )),
        FieldPadding(ReactiveTypedTextField(
          formControl: _apiKeyControl,
          type: const TextFieldType.secret(),
          decoration: const InputDecoration(labelText: 'Api Token'),
        )),
      ],
    );
  }
}

class _YoutrackForm extends ConsumerStatefulWidget {
  const _YoutrackForm();

  @override
  ConsumerState<_YoutrackForm> createState() => _YoutrackFormState();
}

class _YoutrackFormState extends ConsumerState<_YoutrackForm> {
  final _baseUrlControl = FormControl<String>(
    validators: [Validators.required],
  );
  final _apiTokenControl = FormControl<String>(
    validators: [Validators.required],
  );
  final _ticketIdControl = FormControl<String>(
    validators: [Validators.required],
  );
  late final _form = FormArray(disabled: true, [
    _baseUrlControl,
    _apiTokenControl,
    _ticketIdControl,
  ]);

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final config = await YoutrackConfigDto.bin.read();

    _baseUrlControl.updateValue(config?.baseUrl);
    _apiTokenControl.updateValue(config?.apiToken);
    _ticketIdControl.updateValue(config?.ticketId);
  }

  Future<void> _save() async {
    final config = YoutrackConfigDto(
      baseUrl: _baseUrlControl.value!,
      apiToken: _apiTokenControl.value!,
      ticketId: _ticketIdControl.value!,
    );
    YoutrackApi.instance = YoutrackApi(
      baseUrl: config.baseUrl,
      token: config.apiToken,
    );
    await YoutrackApi.instance!.fetchIssueWorkItems();
    await YoutrackConfigDto.bin.write(config);
    _form.markAsClean(enabled: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = ref.watch(_form.provider.status.disabled);

    return Column(
      children: [
        const SizedBox(height: 32.0),
        ParagraphTile(
          title: const Text('Youtrack'),
          trailing: IconButton(
            onPressed: isDisabled ? _form.markAsEnabled : _form.handleVoidSubmit(_save),
            icon: isDisabled ? const Icon(Icons.edit) : const Icon(Icons.check),
          ),
        ),
        FieldPadding(ReactiveTypedTextField(
          formControl: _baseUrlControl,
          decoration: const InputDecoration(labelText: 'Base url'),
        )),
        FieldPadding(ReactiveTypedTextField(
          formControl: _apiTokenControl,
          type: const TextFieldType.secret(),
          decoration: const InputDecoration(labelText: 'Api Token'),
        )),
        FieldPadding(ReactiveTypedTextField(
          formControl: _ticketIdControl,
          decoration: const InputDecoration(labelText: 'Ticket for spent time'),
        )),
      ],
    );
  }
}

class _JiraForm extends ConsumerStatefulWidget {
  const _JiraForm();

  @override
  ConsumerState<_JiraForm> createState() => _JiraFormState();
}

class _JiraFormState extends ConsumerState<_JiraForm> {
  final _baseUrlControl = FormControl<String>(
    validators: [Validators.required],
  );
  final _userEmailControl = FormControl<String>(
    validators: [Validators.required],
  );
  final _apiTokenControl = FormControl<String>(
    validators: [Validators.required],
  );
  late final _form = FormArray(disabled: true, [
    _baseUrlControl,
    _userEmailControl,
    _apiTokenControl,
  ]);

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final config = await JiraConfigDto.bin.read();

    _baseUrlControl.updateValue(config?.baseUrl);
    _userEmailControl.updateValue(config?.userEmail);
    _apiTokenControl.updateValue(config?.apiToken);
  }

  Future<void> _save() async {
    final config = JiraConfigDto(
      baseUrl: _baseUrlControl.value!,
      userEmail: _userEmailControl.value!,
      apiToken: _apiTokenControl.value!,
    );
    final service = JiraService(JiraApi(
      baseUrl: config.baseUrl,
      userEmail: config.userEmail,
      token: config.apiToken,
    ));
    await service.fetchIssues();
    await JiraConfigDto.bin.write(config);
    Service.instance = service;
    _form.markAsClean(enabled: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = ref.watch(_form.provider.status.disabled);

    return Column(
      children: [
        const SizedBox(height: 32.0),
        ParagraphTile(
          title: const Text('Jira'),
          trailing: IconButton(
            onPressed: isDisabled ? _form.markAsEnabled : _form.handleVoidSubmit(_save),
            icon: isDisabled ? const Icon(Icons.edit) : const Icon(Icons.check),
          ),
        ),
        FieldPadding(ReactiveTypedTextField(
          formControl: _baseUrlControl,
          decoration: const InputDecoration(labelText: 'Base url'),
        )),
        FieldPadding(ReactiveTypedTextField(
          formControl: _userEmailControl,
          type: const TextFieldType.email(),
          decoration: const InputDecoration(labelText: 'User email'),
        )),
        FieldPadding(ReactiveTypedTextField(
          formControl: _apiTokenControl,
          type: const TextFieldType.secret(),
          decoration: const InputDecoration(labelText: 'Api Token'),
        )),
      ],
    );
  }
}
