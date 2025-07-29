import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BaseService {
  final String backendUrl = dotenv.get('BASE_URL'); // 192.168.132.172
  final Dio _dio = Dio();

  BaseService() {
    // Optional: Set default options for Dio
    _dio.options = BaseOptions(
      baseUrl: backendUrl,
      connectTimeout: const Duration(seconds: 10), // 10 seconds
      receiveTimeout: const Duration(seconds: 10), // 10 seconds
      headers: {'Content-Type': 'application/json'},
    );

    // Add interceptors if needed (e.g., for logging or authentication)
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(endpoint, data: body);

      // Check if response data is null or malformed
      if (response.data == null) {
        throw Exception('API response is null');
      }

      return response.data;
    } catch (error) {
      //   debugPrint('Error in POST request: $error');
      throw Exception('Failed POST request: $error');
    }
  }

  // create a delete method
  Future<dynamic> delete(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.delete(endpoint, data: body);
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.data; // Dio automatically decodes JSON by default
    } else {
      throw Exception(
        'Error: ${response.statusCode} - ${response.statusMessage}',
      );
    }
  }

  void _handleDioError(DioException error) {
    if (error.response != null) {
      throw Exception(
        'Dio error: ${error.response?.statusCode} - ${error.response?.statusMessage}',
      );
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      throw Exception('Connection timed out');
    } else {
      throw Exception('Unexpected error: ${error.message}');
    }
  }
}
