import 'package:hasd/dto/app_settings_dto.dart';
import 'package:mekart/mekart.dart';
import 'package:path_provider/path_provider.dart';

extension Bins on BinSession {
  BinStore<AppSettings> get settings => BinStore(
        session: this,
        name: 'app_settings.json',
        deserializer: (data) => AppSettings.fromJson(data as Map<String, dynamic>),
        fallbackData: const AppSettings(),
      );
}

abstract final class Instances {
  static final BinConnection bin = BinConnection(_BinEngine());
}

class _BinEngine extends BinEngineBase {
  @override
  Future<String?> getDirectoryPath() async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }
}
