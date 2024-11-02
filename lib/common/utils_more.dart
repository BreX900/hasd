import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/redmine/redmine_api.dart';
import 'package:hasd/models/models.dart';
import 'package:intl/intl.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';
import 'package:url_launcher/url_launcher.dart';

const List<String> _wordMimeTypes = [
  'application/msword', // .doc
  'application/msword', // .dot
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document', // .docx
  'application/vnd.openxmlformats-officedocument.wordprocessingml.template', // .dotx
  'application/vnd.ms-word.document.macroEnabled.12', // .docm
  'application/vnd.ms-word.template.macroEnabled.12', // .dotm
  'application/vnd.ms-excel', // .xls
  'application/vnd.ms-excel', // .xlt
  'application/vnd.ms-excel', // .xla
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // .xlsx
  'application/vnd.openxmlformats-officedocument.spreadsheetml.template', // .xltx
  'application/vnd.ms-excel.sheet.macroEnabled.12', // .xlsm
  'application/vnd.ms-excel.template.macroEnabled.12', // .xltm
  'application/vnd.ms-excel.addin.macroEnabled.12', // .xlam
  'application/vnd.ms-excel.sheet.binary.macroEnabled.12', // .xlsb
  'application/vnd.ms-powerpoint', // .ppt
  'application/vnd.ms-powerpoint', // .pot
  'application/vnd.ms-powerpoint', // .pps
  'application/vnd.ms-powerpoint', // .ppa
  'application/vnd.openxmlformats-officedocument.presentationml.presentation', // .pptx
  'application/vnd.openxmlformats-officedocument.presentationml.template', // .potx
  'application/vnd.openxmlformats-officedocument.presentationml.slideshow', // .ppsx
  'application/vnd.ms-powerpoint.addin.macroEnabled.12', // .ppam
  'application/vnd.ms-powerpoint.presentation.macroEnabled.12', // .pptm
  'application/vnd.ms-powerpoint.template.macroEnabled.12', // .potm
  'application/vnd.ms-powerpoint.slideshow.macroEnabled.12', // .ppsm
  'application/vnd.ms-access', // .mdb
];
Future<void> launchFileWebView(BuildContext context, AttachmentModel attachment) async {
  if (_wordMimeTypes.contains(attachment.mimeType)) {
    final uri = Uri.parse(attachment.contentUrl);
    final officeUri = Uri.parse('https://view.officeapps.live.com/op/view.aspx');
    final fileUri = officeUri.replace(queryParameters: {
      'src': RedmineApi.instance.joinApiKey(uri).toString(),
      'wdOrigin': 'BROWSELINK',
    });
    await launchUrl(fileUri);
  } else {
    await launchUrl(Uri.parse(attachment.contentUrl));
  }
}

String formatDuration(Duration source) {
  final text = '${source.hours}h ${source.minutes}m';
  if (source.inDays == 0) return text;

  return '${source.inDays}d $text';
}

String formatDateTime(DateTime source) => DateFormat('yyyy-MM-dd hh:mm').format(source);

extension WidgetAsyncValue<T> on AsyncValue<T> {
  String buildText({required String Function(T data) data}) {
    return when(
      skipError: true,
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: data,
      error: (error, _) => '$error',
      loading: () => '...',
    );
  }

  Widget buildScene({required Widget Function(T data) data}) {
    return when(
      skipError: true,
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: data,
      error: (error, _) => Text('$error'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class HoursFieldConverter extends FieldConvert<Duration> {
  const HoursFieldConverter();

  @override
  String toText(Duration? value) => value != null ? formatDuration(value) : '';

  @override
  Duration? toValue(String text) {
    final regExp = RegExp(r'^ *(?:(\d+)d)? *?(?:(\d+)h)? *?(?:(\d+)m)? *$');
    final match = regExp.matchAsPrefix(text);
    if (match == null) return null;

    final days = match.group(1);
    final hours = match.group(2);
    final minutes = match.group(3);

    return Duration(
      hours: (hours != null ? int.parse(hours) : 0) + (days != null ? int.parse(days) * 8 : 0),
      minutes: minutes != null ? int.parse(minutes) : 0,
    );
  }
}
