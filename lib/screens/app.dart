import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/jira/jira_api.dart';
import 'package:hasd/apis/redmine/redmine_api.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/dto/jira_config_dto.dart';
import 'package:hasd/dto/redmine_config_dto.dart';
import 'package:hasd/dto/youtrack_config_dto.dart';
import 'package:hasd/providers/providers.dart';
import 'package:hasd/screens/dashboard_screen.dart';
import 'package:hasd/screens/timesheet_screen.dart';
import 'package:hasd/services/jira_service.dart';
import 'package:hasd/services/redmine_service.dart';
import 'package:hasd/services/service.dart';
import 'package:hasd/shared/env.dart';
import 'package:hasd/shared/t.dart';
import 'package:mek/mek.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:window_manager/window_manager.dart';

class App extends ConsumerStatefulWidget {
  final AppSettings settings;

  const App({
    super.key,
    required this.settings,
  });

  static MainAppState of(BuildContext context) => context.findAncestorStateOfType<MainAppState>()!;

  @override
  ConsumerState<App> createState() => MainAppState();
}

class MainAppState extends ConsumerState<App> with WindowListener {
  var _hasCredentials = false;
  var _timesheet = false;

  @override
  void initState() {
    super.initState();
    unawaited(_init(widget.settings));
    if (!kIsWeb) WindowManager.instance.addListener(this);
  }

  @override
  void dispose() {
    if (!kIsWeb) WindowManager.instance.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    super.onWindowFocus();
    ref.invalidate(Providers.issues);
    ref.invalidate(Providers.issue);
    ref.invalidate(Providers.times);
  }

  Future<void> _init(AppSettings settings) async {
    // final hasCredentials = settings.apiKey.isNotEmpty;
    // if (_hasCredentials != hasCredentials) setState(() => _hasCredentials = hasCredentials);
    // if (settings.apiKey.isEmpty) return;
    // RedmineApi.instance = RedmineApi(settings.apiKey, Env.redmineApiUrl);

    final youtrackConfig = await YoutrackConfigDto.bin.read();
    if (youtrackConfig != null) {
      YoutrackApi.instance = YoutrackApi(
        baseUrl: youtrackConfig.baseUrl,
        token: youtrackConfig.apiToken,
      );
    }

    Service? service;
    switch (Env.flavor) {
      case Flavor.redmine:
        final jiraConfig = await RedmineConfigDto.bin.read();
        if (jiraConfig == null) break;

        service = RedmineService(RedmineApi(
          baseUrl: jiraConfig.baseUrl,
          key: jiraConfig.apiKey,
        ));
      case Flavor.jira:
        final jiraConfig = await JiraConfigDto.bin.read();
        if (jiraConfig == null) break;

        service = JiraService(JiraApi(
          baseUrl: jiraConfig.baseUrl,
          userEmail: jiraConfig.userEmail,
          token: jiraConfig.apiToken,
        ));
    }
    if (service != null) Service.instance = service;

    if (youtrackConfig == null || service == null) return;
    setState(() => _hasCredentials = true);
  }

  void toggleTimesheet() {
    setState(() {
      _timesheet = !_timesheet;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listenManualFuture(Providers.settings.future, _init);

    return MaterialApp(
      key: ValueKey(_hasCredentials),
      title: 'Hasd',
      debugShowCheckedModeBanner: false,
      theme: MekTheme.build(context: context).copyWith(
        extensions: {
          const DataBuilders(errorListener: T.showSnackBarError),
        },
      ),
      locale: const Locale('it', 'IT'),
      supportedLocales: kWidgetsSupportedLanguages.map(Locale.new),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) {
        final colors = Theme.of(context).colorScheme;
        return MultiSplitViewTheme(
          data: MultiSplitViewThemeData(
            dividerPainter: DividerPainter(
              backgroundColor: colors.surfaceVariant,
              highlightedBackgroundColor: colors.surfaceTint,
            ),
          ),
          child: child!,
        );
      },
      home: _hasCredentials
          ? (_timesheet ? const TimesheetScreen() : const DashboardScreen())
          : const _InitializationScreen(),
    );
  }
}

class _InitializationScreen extends ConsumerStatefulWidget {
  const _InitializationScreen();

  @override
  ConsumerState<_InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends ConsumerState<_InitializationScreen> {
  final _redmineApiKey = FieldBloc(initialValue: '');

  Future<void> _submit() async {
    await Providers.settingsBin.update((data) {
      return data.change((c) => c..apiKey = _redmineApiKey.state.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        child: const Icon(Icons.check),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: FieldText(
          fieldBloc: _redmineApiKey,
          converter: FieldConvert.text,
          decoration: const InputDecoration(labelText: 'Redmine ApiKey'),
        ),
      ),
    );
  }
}
