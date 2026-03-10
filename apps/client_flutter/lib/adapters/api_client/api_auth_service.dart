import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scribble/usecases/auth_usecases/auth_service.dart';
import 'package:scribble/usecases/auth_usecases/auth_session.dart';

class ApiAuthService implements AuthService {
  final String baseUrl;
  final http.Client _client;

  ApiAuthService({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _send(
      () => _client.post(
        _resolve('/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );

    if (response.statusCode == 401) {
      throw StateError('API_UNAUTHORIZED');
    }
    if (response.statusCode != 200) {
      throw StateError('API_REQUEST_FAILED');
    }

    return _toAuthSession(_decodeJson(response.body) as Map<String, dynamic>);
  }

  @override
  Future<AuthSession> refresh({required String refreshToken}) async {
    final response = await _send(
      () => _client.post(
        _resolve('/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      ),
    );

    if (response.statusCode == 401) {
      throw StateError('API_UNAUTHORIZED');
    }
    if (response.statusCode != 200) {
      throw StateError('API_REQUEST_FAILED');
    }

    return _toAuthSession(_decodeJson(response.body) as Map<String, dynamic>);
  }

  @override
  Future<void> signOut({required String accessToken}) async {
    final response = await _send(
      () => _client.post(
        _resolve('/auth/logout'),
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    if (response.statusCode == 401) {
      throw StateError('API_UNAUTHORIZED');
    }
    if (response.statusCode != 204) {
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

  AuthSession _toAuthSession(Map<String, dynamic> body) {
    final accessToken = body['access_token'] as String;
    final refreshToken = body['refresh_token'] as String;
    final claims = _decodeJwtPayload(accessToken);
    final userId = claims['sub'] as String;
    final exp = claims['exp'];
    if (exp is! num) {
      throw StateError('API_REQUEST_FAILED');
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000),
    );
  }

  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw StateError('API_REQUEST_FAILED');
    }
    final normalized = base64Url.normalize(parts[1]);
    final payload = utf8.decode(base64Url.decode(normalized));
    return _decodeJson(payload) as Map<String, dynamic>;
  }

  Object _decodeJson(String raw) {
    try {
      return jsonDecode(raw);
    } on FormatException {
      throw StateError('API_REQUEST_FAILED');
    }
  }

  Uri _resolve(String path) => Uri.parse(baseUrl + path);
}
