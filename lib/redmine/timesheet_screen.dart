import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/redmine/hasd_app.dart';
import 'package:hasd/redmine/hasd_drawer.dart';
import 'package:hasd/redmine/hasd_providers.dart';
import 'package:hasd/redmine/issue_dialog.dart';
import 'package:hasd/redmine/redmine_dto.dart';
import 'package:hasd/redmine/utils.dart';
import 'package:intl/intl.dart';
import 'package:mek/mek.dart';
import 'package:recase/recase.dart';

final _stateProvider = FutureProvider.family((ref, (Date, Date) _) async {
  final (spentFrom, spentTo) = _;

  final appSettings = await ref.watch(HasdProviders.settings.future);

  final times = await ref.watch(HasdProviders.times((
    spentFrom: spentFrom,
    spentTo: spentTo,
    issueId: null,
  )).future);

  return (
    appSettings: appSettings,
    times: times,
  );
});

class TimesheetScreen extends ConsumerStatefulWidget {
  const TimesheetScreen({super.key});

  @override
  ConsumerState<TimesheetScreen> createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends ConsumerState<TimesheetScreen> {
  final _calendarController = MonthCalendarController(MonthCalendarValue(
    hiddenWeekdays: const [DateTime.saturday, DateTime.sunday],
  ));

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Widget _buildBody({required IList<TimEntryDto> monthTimes}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final locale = Localizations.localeOf(context);
    final dayFormat = DateFormat.d(locale.languageCode);

    return MonthCalendar(
      controller: _calendarController,
      hiddenWeekdays: const [DateTime.saturday, DateTime.sunday],
      cellBuilder: (context, data, dateTime) {
        dateTime = dateTime.date;
        final times = monthTimes.where((e) => e.spentOn == dateTime);
        final totalTime = times.fold(Duration.zero, (total, e) => total + e.hours);

        final entries = times.map((time) {
          return FlatListTile(
            dense: true,
            onTap: () async => showDialog(
              context: context,
              builder: (context) => IssueDialog(issueId: time.entityId),
            ),
            title: Text('${formatDuration(time.hours)} ${time.activity.name}'),
            subtitle: Text('#${time.entityId}'),
          );
        }).toList();

        return Card(
          elevation: data.isInMonth(dateTime) ? 8.0 : 0.0,
          child: Column(
            children: [
              FlatListTile(
                title: Text(dayFormat.format(dateTime), style: textTheme.titleSmall),
                trailing: totalTime > Duration.zero ? Text(formatDuration(totalTime)) : null,
              ),
              Expanded(
                child: ListView(
                  children: entries,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final range = ref.watch(_calendarController.select((value) {
      return (value.initialMonthDay.toDate(), value.lastMonthDay.toDate());
    }));
    final state = ref.watch(_stateProvider(range));

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final t = MaterialLocalizations.of(context);

    final now = DateTime.timestamp().date;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timesheet'),
        actions: [
          IconButton(
            onPressed: () => HasdApp.of(context).toggleTimesheet(),
            icon: const Icon(Icons.table_chart),
          ),
        ],
      ),
      drawer: const HasdDrawer(),
      body: Column(
        children: [
          MonthCalendarHeader(
            controller: _calendarController,
            lastDate: now.copyWith(month: now.month + 1, day: -1),
            headerBuilder: (context, date) {
              return Text(t.formatMonthYear(date).sentenceCase, style: textTheme.headlineSmall);
            },
          ),
          Expanded(
            child: state.buildScene(
              data: (data) => _buildBody(monthTimes: data.times),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthCalendarHeader extends ConsumerWidget {
  final MonthCalendarController controller;

  final DateTime? lastDate;
  final Widget Function(BuildContext context, DateTime date) headerBuilder;

  const MonthCalendarHeader({
    super.key,
    this.lastDate,
    required this.controller,
    required this.headerBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(controller.provider);

    return Row(
      children: [
        IconButton(
          onPressed: controller.goToPreviousMonth,
          icon: const Icon(Icons.navigate_before),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: headerBuilder(context, value.selectedDay),
        ),
        const Spacer(),
        IconButton(
          onPressed: lastDate != null && lastDate!.isAfter(value.lastVisibleDay)
              ? controller.goToNextMonth
              : null,
          icon: const Icon(Icons.navigate_next),
        ),
      ],
    );
  }
}

class MonthCalendar extends ConsumerWidget {
  final MonthCalendarController controller;
  final List<int> hiddenWeekdays;

  final Widget Function(BuildContext context, MonthCalendarValue data, DateTime dateTime)
      cellBuilder;

  const MonthCalendar({
    super.key,
    this.hiddenWeekdays = const <int>[],
    required this.controller,
    required this.cellBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(controller.provider);

    final cells = <DateTime>[];
    for (var currentMonthDate = value.initialVisibleDay;
        currentMonthDate.isBefore(value.lastVisibleDay);
        currentMonthDate = currentMonthDate.add(const Duration(days: 1))) {
      if (currentMonthDate.weekday == DateTime.saturday) continue;
      if (currentMonthDate.weekday == DateTime.sunday) continue;

      cells.add(currentMonthDate);
    }

    final rows = cells.splitByLength(5);

    return Column(
      children: rows.map((cells) {
        return Expanded(
          child: Row(
            children: cells.map((cell) {
              return Expanded(
                child: cellBuilder(context, value, cell),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class MonthCalendarController extends ValueNotifier<MonthCalendarValue> {
  // ignore: matching_super_parameters
  MonthCalendarController(super.value);

  void goToPreviousMonth() {
    value = value.copyWith(
      selectedDay: value.selectedDay.copyWith(month: value.selectedDay.month - 1),
    );
  }

  void goToNextMonth() {
    value = value.copyWith(
      selectedDay: value.selectedDay.copyWith(month: value.selectedDay.month + 1),
    );
  }
}

/// TODO: Replace with [DateTimeExtensions]
class MonthCalendarValue {
  final DateTime selectedDay;
  final List<int> hiddenWeekdays;

  late final DateTime initialMonthDay = selectedDay.initialMonthDay;
  late final DateTime lastMonthDay = selectedDay.lastMonthDay;

  late final DateTime initialVisibleDay = _getInitialVisibleDay(initialMonthDay);
  late final DateTime lastVisibleDay = _getLastVisibleDay(lastMonthDay);

  MonthCalendarValue({
    DateTime? selectedDay,
    this.hiddenWeekdays = const <int>[],
  }) : selectedDay = selectedDay ?? DateTime.now().date;

  bool isInMonth(DateTime day) {
    if (day == initialMonthDay || day == lastMonthDay) return true;
    return day.isAfter(initialMonthDay) && day.isBefore(lastMonthDay);
  }

  DateTime _getInitialVisibleDay(DateTime dateTime) {
    for (var i = dateTime.weekday; i <= 7; i++) {
      if (!hiddenWeekdays.contains(i)) return dateTime.initialWeekDay;
    }
    return dateTime.add(const Duration(days: 7)).initialWeekDay;
  }

  DateTime _getLastVisibleDay(DateTime dateTime) {
    for (var i = dateTime.weekday; i >= 1; i--) {
      if (!hiddenWeekdays.contains(i)) return dateTime.lastWeekDay;
    }
    return dateTime.subtract(const Duration(days: 7)).lastWeekDay;
  }

  MonthCalendarValue copyWith({
    DateTime? selectedDay,
    List<int>? hiddenWeekdays,
  }) {
    return MonthCalendarValue(
      selectedDay: selectedDay ?? this.selectedDay,
      hiddenWeekdays: hiddenWeekdays ?? this.hiddenWeekdays,
    );
  }
}
