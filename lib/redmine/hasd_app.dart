import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/redmine/redmine_api.dart';
import 'package:hasd/apis/redmine/redmine_dto.dart';
import 'package:hasd/apis/youtrack/youtrack_api.dart';
import 'package:hasd/common/env.dart';
import 'package:hasd/common/t.dart';
import 'package:hasd/redmine/hasd_providers.dart';
import 'package:hasd/redmine/hasd_screens.dart';
import 'package:hasd/redmine/timesheet_screen.dart';
import 'package:mek/mek.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:window_manager/window_manager.dart';

class HasdApp extends ConsumerStatefulWidget {
  final AppSettings settings;

  const HasdApp({
    super.key,
    required this.settings,
  });

  static HasdAppState of(BuildContext context) {
    return context.findAncestorStateOfType<HasdAppState>()!;
  }

  @override
  ConsumerState<HasdApp> createState() => HasdAppState();
}

class HasdAppState extends ConsumerState<HasdApp> with WindowListener {
  var _hasCredentials = true;
  var _timesheet = true;

  @override
  void initState() {
    super.initState();
    _init(widget.settings);
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
    ref.invalidate(HasdProviders.issues);
    ref.invalidate(HasdProviders.issue);
    ref.invalidate(HasdProviders.times);
  }

  void _init(AppSettings settings) {
    return;
    final hasCredentials = settings.apiKey.isNotEmpty;
    if (_hasCredentials != hasCredentials) setState(() => _hasCredentials = hasCredentials);
    if (settings.apiKey.isEmpty) return;
    RedmineApi.instance = RedmineApi(settings.apiKey, Env.redmineApiUrl);
    YoutrackApi.instance =
        settings.youtrackApiKey.isNotEmpty ? YoutrackApi(settings.youtrackApiKey) : null;
  }

  void toggleTimesheet() {
    setState(() {
      _timesheet = !_timesheet;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listenManualFuture(HasdProviders.settings.future, _init);

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
    await HasdProviders.settingsBin.update((data) {
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
