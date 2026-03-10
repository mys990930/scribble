import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/adapters/secure_storage/device_installation_store.dart';
import 'package:scribble/adapters/secure_storage/secure_value_store.dart';

class FakeSecureValueStore implements SecureValueStore {
  final Map<String, String> values = {};

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async {
    return values[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}

void main() {
  group('SecureDeviceInstallationStore', () {
    test('device id가 없으면 생성 후 저장한다', () async {
      final store = FakeSecureValueStore();
      final installationStore = SecureDeviceInstallationStore(
        store: store,
        idGenerator: () => 'generated-device-id',
      );

      final deviceId = await installationStore.getOrCreateDeviceId();

      expect(deviceId, 'generated-device-id');
      expect(store.values['device.id'], 'generated-device-id');
    });

    test('device id가 있으면 기존 값을 재사용한다', () async {
      final store = FakeSecureValueStore()..values['device.id'] = 'existing-device-id';
      final installationStore = SecureDeviceInstallationStore(
        store: store,
        idGenerator: () => 'generated-device-id',
      );

      final deviceId = await installationStore.getOrCreateDeviceId();

      expect(deviceId, 'existing-device-id');
      expect(store.values['device.id'], 'existing-device-id');
    });
  });
}
