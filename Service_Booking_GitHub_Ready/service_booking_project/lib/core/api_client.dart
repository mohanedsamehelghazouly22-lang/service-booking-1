import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int status;
  ApiException(this.message, this.status);
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8080/api');
  final String baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> request(String method, String path, {Map<String, dynamic>? body, bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await _storage.read(key: 'access_token');
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    final uri = Uri.parse('$baseUrl$path');
    late http.Response response;
    switch (method) {
      case 'GET': response = await http.get(uri, headers: headers); break;
      case 'POST': response = await http.post(uri, headers: headers, body: jsonEncode(body ?? {})); break;
      case 'PUT': response = await http.put(uri, headers: headers, body: jsonEncode(body ?? {})); break;
      case 'DELETE': response = await http.delete(uri, headers: headers); break;
      default: throw ArgumentError('Unsupported HTTP method');
    }
    final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(data['message']?.toString() ?? 'Request failed', response.statusCode);
    }
    return data;
  }

  Future<void> saveToken(String token) => _storage.write(key: 'access_token', value: token);
  Future<void> clearToken() => _storage.delete(key: 'access_token');
}
