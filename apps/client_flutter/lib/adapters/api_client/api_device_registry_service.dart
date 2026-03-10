import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scribble/adapters/secure_storage/device_installation_store.dart';
import 'package:scribble/usecases/auth_usecases/auth_session.dart';

class DeviceRegistrationMetadata {
  final String deviceId;
  final String platform;
  final String name;
  final String? appVersion;

  const DeviceRegistrationMetadata({
    required this.deviceId,
    required this.platform,
    required this.name,
    required this.appVersion,
  });
}

abstract class DeviceRegistrationMetadataProvider {
  Future<DeviceRegistrationMetadata> getCurrent();
}

class AndroidDeviceRegistrationMetadataProvider
    implements DeviceRegistrationMetadataProvider {
  final DeviceInstallationStore _deviceInstallationStore;
  final DeviceInfoPlugin _deviceInfoPlugin;
  final Future<PackageInfo> Function() _packageInfoLoader;

  AndroidDeviceRegistrationMetadataProvider({
    required DeviceInstallationStore deviceInstallationStore,
    DeviceInfoPlugin? deviceInfoPlugin,
    Future<PackageInfo> Function()? packageInfoLoader,
  }) : _deviceInstallationStore = deviceInstallationStore,
       _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin(),
       _packageInfoLoader = packageInfoLoader ?? PackageInfo.fromPlatform;

  @override
  Future<DeviceRegistrationMetadata> getCurrent() async {
    final deviceId = await _deviceInstallationStore.getOrCreateDeviceId();
    final android = await _deviceInfoPlugin.androidInfo;
    final packageInfo = await _packageInfoLoader();
    final manufacturer = android.manufacturer.trim();
    final model = android.model.trim();
    final name = manufacturer.isEmpty
        ? (model.isEmpty ? 'Android Device' : model)
        : model.isEmpty
        ? manufacturer
        : '$manufacturer $model';
    final version = packageInfo.buildNumber.isEmpty
        ? packageInfo.version
        : '${packageInfo.version}+${packageInfo.buildNumber}';

    return DeviceRegistrationMetadata(
      deviceId: deviceId,
      platform: 'android',
      name: name,
      appVersion: version,
    );
  }
}

class ApiDeviceRegistryService {
  final String baseUrl;
  final http.Client _client;
  final DeviceRegistrationMetadataProvider _metadataProvider;

  ApiDeviceRegistryService({
    required this.baseUrl,
    required DeviceRegistrationMetadataProvider metadataProvider,
    http.Client? client,
  }) : _metadataProvider = metadataProvider,
       _client = client ?? http.Client();

  Future<void> registerCurrentDevice({required AuthSession session}) async {
    final metadata = await _metadataProvider.getCurrent();
    final response = await _send(
      () => _client.post(
        _resolve('/devices'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session.accessToken}',
        },
        body: jsonEncode({
          'device_id': metadata.deviceId,
          'platform': metadata.platform,
          'name': metadata.name,
          'app_version': metadata.appVersion,
        }),
      ),
    );

    if (response.statusCode == 401) {
      throw StateError('API_UNAUTHORIZED');
    }
    if (response.statusCode != 201) {
      throw StateError('API_REQUEST_FAILED');
    }
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request();
    } on http.ClientException {
      throw StateError('API_NETWORK_ERROR');
    } on FormatException {
      throw StateError('API_NETWORK_ERROR');
    }
  }

  Uri _resolve(String path) => Uri.parse(baseUrl + path);
}
