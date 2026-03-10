import 'package:scribble/adapters/secure_storage/secure_value_store.dart';
import 'package:uuid/uuid.dart';

abstract class DeviceInstallationStore {
  Future<String> getOrCreateDeviceId();
}

class SecureDeviceInstallationStore implements DeviceInstallationStore {
  static const _deviceIdKey = 'device.id';

  final SecureValueStore _store;
  final String Function() _idGenerator;

  SecureDeviceInstallationStore({
    SecureValueStore? store,
    String Function()? idGenerator,
  })
    : _store = store ?? FlutterSecureValueStore(),
      _idGenerator = idGenerator ?? const Uuid().v4;

  @override
  Future<String> getOrCreateDeviceId() async {
    final existing = await _store.read(key: _deviceIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final created = _idGenerator();
    await _store.write(key: _deviceIdKey, value: created);
    return created;
  }
}
