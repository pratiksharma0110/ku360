import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ku360/services/shared_pref.dart';

class ApiService {
  ApiService();
  final sharedPref = SharedPrefHelper();

  Future<http.Response> _makeRequest(
    String url,
    String method,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) async {
    late http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(Uri.parse(url), headers: headers);
        break;
      case 'POST':
        response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'PUT':
        response = await http.put(
          Uri.parse(url),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'DELETE':
        response = await http.delete(Uri.parse(url), headers: headers);
        break;
      default:
        throw Exception("Unsupported HTTP method: $method");
    }

    return response;
  }

  Future<http.Response> securedRequest(
    String url, {
    String method = 'GET',
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final String? jwtToken = await sharedPref.getValue("jwt_token");
      if (jwtToken == null) {
        throw Exception("No token found");
      }

      final Map<String, String> defaultHeaders = {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      };

      final Map<String, String> finalHeaders = {
        ...defaultHeaders,
        if (headers != null) ...headers,
      };

      return _makeRequest(url, method, finalHeaders, body);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> publicRequest(
   {
    String? url,
  String method = 'GET',
  Map<String, String>? headers,
  Map<String, dynamic>? body,
  Map<String, String>? queryParams, 
}) async {
  try {
    
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> finalHeaders = {
      ...defaultHeaders,
      if (headers != null) ...headers,
    };

   
    final Uri uri = queryParams != null
        ? Uri.parse(url!).replace(queryParameters: queryParams)
        : Uri.parse(url!);

   
    return _makeRequest(uri.toString(), method, finalHeaders, body);
  } catch (e) {
    rethrow;
  }
}


  
}
