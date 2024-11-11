import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiExceptionHandler {
  static Future<dynamic> handleApiCall(Future<http.Response> apiCall) async {
    try {
      final response = await apiCall.timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        // Decode JSON response if successful
        return json.decode(response.body);
      } else {
        throw ApiException('Something went wrong. Please try again later. ${response.statusCode}');
      }
    } on TimeoutException {
      throw ApiException('Request timed out. Something went wrong. Please try again later.');
    } on http.ClientException {
      throw ApiException('Network error. Please check your connection and try again.');
    } catch (e) {
      throw ApiException('Something went wrong. Please try again later. $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
