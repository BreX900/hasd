// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hasd/common/module_button.dart';
// import 'package:hasd/you_track/you_track_api.dart';
// import 'package:hasd/you_track/you_track_providers.dart';
// import 'package:mek/mek.dart';
// import 'package:pure_extensions/pure_extensions.dart';
//
// class Time {
//   final DateTime date;
//   final IssueLinkTypeYt? type;
//
//   const Time({
//     required this.date,
//     this.type,
//   });
// }
//
// class AppBloc extends ChangeNotifier {
//   String? _issueId;
//   DateTime? _workingAt;
//   final _worked = <String, Duration>{};
//
//   bool isWorking(String issueId) {
//     return _issueId == issueId;
//   }
//
//   Duration? get(String issueId) {
//     if (_issueId != issueId && !_worked.containsKey(issueId)) return null;
//
//     return (_worked[issueId] ?? Duration.zero) +
//         (_issueId != issueId || _workingAt == null
//             ? Duration.zero
//             : DateTime.now().difference(_workingAt!));
//   }
//
//   void play(String issueId) {
//     if (_issueId != null) pause(_issueId!);
//     _issueId = issueId;
//     _workingAt = DateTime.now();
//     notifyListeners();
//   }
//
//   void pause(String issueId) {
//     _worked[issueId] = (_worked[issueId] ?? Duration.zero) + DateTime.now().difference(_workingAt!);
//     _issueId = null;
//     _workingAt = null;
//     notifyListeners();
//   }
//
//   void delete(String issueId) {
//     _issueId = null;
//     _workingAt = null;
//     _worked.remove(issueId);
//     notifyListeners();
//   }
//
//   Duration stop(String issueId) {
//     pause(issueId);
//     final worked = _worked.remove(issueId)!;
//     notifyListeners();
//     return worked;
//   }
//
//   void add(String issueId, Duration duration) {
//     if (_issueId != null) pause(_issueId!);
//     _issueId = issueId;
//     _workingAt = DateTime.now();
//     _worked[issueId] = (_worked[issueId] ?? Duration.zero) + duration;
//     notifyListeners();
//   }
// }
//
// final _app = ChangeNotifierProvider((ref) => AppBloc());
//
// String formatDuration(Duration duration, {bool hours = false, bool seconds = false}) {
//   return [
//     if (duration.days > 0) '${duration.days}d',
//     if (duration.inHours > 0 || hours) '${duration.hours}h',
//     '${duration.minutes}m',
//     if (seconds) '${duration.seconds}s',
//   ].join(' ');
// }
//
// class YouTrackScreen extends ConsumerStatefulWidget {
//   const YouTrackScreen({super.key});
//
//   @override
//   ConsumerState<YouTrackScreen> createState() => _YouTrackScreenState();
// }
//
// class _YouTrackScreenState extends ConsumerState<YouTrackScreen> {
//   // final _workSpace = FieldBloc(initialValue: '');
//   final _project = FieldBloc<ProjectYt?>(initialValue: null);
//   final _issue = FieldBloc<IssueYt?>(initialValue: null);
//
//   @override
//   Widget build(BuildContext context) {
//     final projectsState = ref.watch(YouTrackProviders.projects);
//
//     final currentIssue = ref.watch(_issue.select((state) => state.value));
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('YouTrack'),
//         actions: [
//           IconButton(
//             onPressed: () => ref.invalidate(YouTrackProviders.invalidator),
//             icon: const Icon(Icons.refresh),
//           ),
//           const ModuleButton(),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size(0.0, 64.0),
//           child: Row(
//             children: [
//               // Expanded(
//               //   child: FieldDropdown<String>(
//               //     fieldBloc: _workSpace,
//               //     onChanged: (_) => _issue.updateValue(null),
//               //     items: (projectsState.valueOrNull ?? const []).map((e) {
//               //       return DropdownMenuItem(
//               //         value: e,
//               //         child: Text(e.name!),
//               //       );
//               //     }).toList(),
//               //   ),
//               // ),
//               Expanded(
//                 child: FieldDropdown<ProjectYt?>(
//                   fieldBloc: _project,
//                   onChanged: (_) => _issue.updateValue(null),
//                   items: (projectsState.valueOrNull ?? const []).map((e) {
//                     return DropdownMenuItem(
//                       value: e,
//                       child: Text(e.name!),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               Expanded(
//                 child: TimerWidget(
//                   issueId: '',
//                   onStopped: currentIssue != null
//                       ? (type, duration) => ref.read(_app.notifier).add(currentIssue.id!, duration)
//                       : null,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Consumer(
//         builder: (context, ref, _) {
//           final currentProject = ref.watch(_project.select((state) => state.value));
//           if (currentProject == null) return const SizedBox.shrink();
//
//           final issuesState = ref.watch(YouTrackProviders.issues(currentProject.id!));
//           final issues = issuesState.valueOrNull ?? [];
//
//           return Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: issues.length,
//                         itemBuilder: (context, index) {
//                           final issue = issues[index];
//
//                           return ListTile(
//                             selected: currentIssue?.id == issue.id,
//                             onTap: () => _issue.updateValue(issue),
//                             title: Text(issue.summary!),
//                           );
//                         },
//                       ),
//                     ),
//                     const Divider(),
//                     IconButton(
//                       // ignore: discarded_futures
//                       onPressed: () => showDialog(
//                         context: context,
//                         builder: (context) => IssueDialog(
//                           projectId: _project.state.value!.name!,
//                         ),
//                       ),
//                       icon: const Icon(Icons.add),
//                     ),
//                   ],
//                 ),
//               ),
//               const VerticalDivider(width: 0.0),
//               Expanded(
//                 child: Builder(builder: (context) {
//                   if (currentIssue == null) return const SizedBox.shrink();
//
//                   final timesState = ref.watch(YouTrackProviders.times(currentIssue.id!));
//                   final times = timesState.valueOrNull ?? const [];
//
//                   return Column(
//                     children: [
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: times.length,
//                           itemBuilder: (context, index) {
//                             final time = times[index];
//
//                             return ListTile(
//                               title: Text(
//                                   '${time.author!.fullName}: ${formatDuration(Duration(minutes: time.duration!.minutes!))}'),
//                               trailing: IconButton(
//                                 onPressed: () async {
//                                   await YouTrackProviders.client
//                                       .deleteIssuesIdTimeTrackingWorkItemsIssueWorkItemId(
//                                           currentIssue.id!, time.id!);
//                                   ref.invalidate(YouTrackProviders.times(currentIssue.id!));
//                                 },
//                                 icon: const Icon(Icons.delete),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       const Divider(height: 0.0),
//                       TimerWidget(
//                         issueId: currentIssue.id!,
//                         onStopped: (timeType, duration) async {
//                           await YouTrackProviders.client.postIssuesIdTimeTrackingWorkItems(
//                             currentIssue.id!,
//                             data: IssueWorkItemYt(
//                               type: timeType,
//                               duration: DurationValueYt(minutes: duration.inMinutes),
//                               text: 'Test',
//                             ),
//                           );
//                           ref.invalidate(YouTrackProviders.times(currentIssue.id!));
//                         },
//                       ),
//                     ],
//                   );
//                 }),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class TimerWidget extends ConsumerStatefulWidget {
//   final String issueId;
//   final void Function(WorkItemTypeYt timeType, Duration duration)? onStopped;
//
//   const TimerWidget({
//     super.key,
//     required this.issueId,
//     required this.onStopped,
//   });
//
//   @override
//   ConsumerState<TimerWidget> createState() => _TimerWidgetState();
// }
//
// class _TimerWidgetState extends ConsumerState<TimerWidget> {
//   final _timeType = FieldBloc<WorkItemTypeYt?>(initialValue: null);
//   bool _isWorking = false;
//
//   void _play() {
//     ref.read(_app.notifier).play(widget.issueId);
//   }
//
//   Future<void> _update() async {
//     if (!_isWorking) return;
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await Future.delayed(const Duration(seconds: 1));
//       setState(() {});
//       await _update();
//     });
//   }
//
//   void _cancel() {
//     ref.read(_app.notifier).delete(widget.issueId);
//   }
//
//   void _pause() {
//     ref.read(_app.notifier).pause(widget.issueId);
//   }
//
//   void _stop() {
//     final timeType = _timeType.state.value;
//     if (timeType == null) return;
//     final duration = ref.read(_app.notifier).stop(widget.issueId);
//     widget.onStopped!(timeType, duration);
//     _timeType.updateValue(null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final duration = ref.watch(_app.select((value) => value.get(widget.issueId)));
//     final isWorking = ref.watch(_app.select((value) => value.isWorking(widget.issueId)));
//
//     ref.listen<bool>(_app.select((value) => value.isWorking(widget.issueId)), (prev, curr) {
//       if (prev == curr) return;
//       _isWorking = curr;
//       if (_isWorking) unawaited(_update());
//     });
//
//     if (duration == null) {
//       return SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           onPressed: _play,
//           style: ElevatedButton.styleFrom(
//             shape: const ContinuousRectangleBorder(),
//             elevation: 0.0,
//           ),
//           child: const Text('Start!'),
//         ),
//       );
//     }
//
//     final timeTypesState = ref.watch(YouTrackProviders.timeTypes);
//
//     return ConstrainedBox(
//       constraints: const BoxConstraints(minHeight: 64.0),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: widget.onStopped != null ? _stop : null,
//             icon: const Icon(Icons.stop),
//           ),
//           IconButton(
//             onPressed: isWorking ? _pause : _play,
//             icon: isWorking ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
//           ),
//           SizedBox(
//             width: 96.0,
//             child: Text(formatDuration(duration, hours: true, seconds: true)),
//           ),
//           Expanded(
//             child: FieldDropdown(
//               fieldBloc: _timeType,
//               decoration: const InputDecoration(
//                 labelText: 'Type',
//                 isDense: true,
//                 contentPadding: EdgeInsets.zero,
//               ),
//               items: (timeTypesState.valueOrNull ?? []).map((e) {
//                 return DropdownMenuItem(
//                   value: e,
//                   child: Text(e.name!),
//                 );
//               }).toList(),
//             ),
//           ),
//           IconButton(
//             onPressed: _cancel,
//             icon: const Icon(Icons.delete),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class IssueDialog extends ConsumerStatefulWidget {
//   final String projectId;
//
//   const IssueDialog({
//     super.key,
//     required this.projectId,
//   });
//
//   @override
//   ConsumerState<IssueDialog> createState() => _IssueDialogState();
// }
//
// class _IssueDialogState extends ConsumerState<IssueDialog> {
//   final _title = FieldBloc<String>(initialValue: '');
//   final _description = FieldBloc<String>(initialValue: '');
//   final _type = FieldBloc<IssueLinkTypeYt?>(initialValue: null);
//
//   @override
//   Widget build(BuildContext context) {
//     final issueTypesState = ref.watch(YouTrackProviders.issueTypes(widget.projectId));
//
//     return AlertDialog(
//       title: const Text('Issue'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FieldText(
//             fieldBloc: _title,
//             converter: FieldConvert.text,
//             decoration: const InputDecoration(
//               labelText: 'Title',
//             ),
//           ),
//           FieldText(
//             fieldBloc: _description,
//             converter: FieldConvert.text,
//             decoration: const InputDecoration(
//               labelText: 'Description',
//             ),
//           ),
//           FieldDropdown(
//             fieldBloc: _type,
//             decoration: const InputDecoration(
//               labelText: 'Type',
//             ),
//             items: (issueTypesState.valueOrNull ?? []).map((e) {
//               return DropdownMenuItem(
//                 value: e,
//                 child: Text(e.id ?? ''),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {},
//           child: const Text('Save'),
//         ),
//       ],
//     );
//   }
// }
