import 'app_settings.dart';

abstract class SettingsStore {
  Future<AppSettings> read();
  Future<void> save(AppSettings settings);
}
