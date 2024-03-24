import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hasd/redmine/hasd_app.dart';
import 'package:hasd/redmine/hasd_providers.dart';
import 'package:logging/logging.dart';
import 'package:mek/mek.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.reportRecords();
  Observers.attachAll();

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

  final container = ProviderContainer(
    observers: const [Observers.provider],
  );

  runApp(UncontrolledProviderScope(
    container: container,
    child: HasdApp(
      settings: await container.read(HasdProviders.settings.future),
    ),
  ));
}
