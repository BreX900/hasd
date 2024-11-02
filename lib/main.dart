import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/apis/jira/jira_api.dart';
import 'package:hasd/common/env.dart';
import 'package:hasd/providers/providers.dart';
import 'package:hasd/screens/app.dart';
import 'package:logging/logging.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.reportRecords();
  Observers.attachAll();

  BinEngine.instance = _BinEngine();

  if (!kIsWeb) {
    await WindowManager.instance.ensureInitialized();
    // const targetSize = Size(128 * 9, 128 * 7);
    const targetSize = Size(128 * 10, 128 * 7.5);
    final size = await WindowManager.instance.getSize();
    if (size.width < targetSize.width || size.height < targetSize.height) {
      await WindowManager.instance.setSize(Size(
        max(size.width, targetSize.width),
        max(size.height, targetSize.height),
      ));
    }
    await WindowManager.instance.setMinimumSize(targetSize);
  }

  // await RedmineProviders.settingsBin.update((data) {
  //   return data.change((c) => c
  //     ..redmineApiKey = ''
  //     ..youtrackApiKey = '');
  // });

  if (false) {
    try {
      print(Env.jiraApiUrl);
      print(Env.jiraApiToken);
      final api = JiraApi.instance;
      final data = await api.fetchIssueStatutes();
      print(jsonEncode(data));
    } on DioException catch (error) {
      print(error);
      print(error.response?.data);
    }
  }

  final container = ProviderContainer(
    observers: const [Observers.provider],
  );

  runApp(UncontrolledProviderScope(
    container: container,
    child: App(
      settings: await container.read(Providers.settings.future),
    ),
  ));
}

class _BinEngine extends BinEngineBase {
  @override
  Future<String?> getDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
