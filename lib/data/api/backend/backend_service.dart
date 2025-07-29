import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:xm_frontend/data/api/api_endpoints.dart';

class BackendService {
  // Replace with your backend URL and check ifconfig and look for en0
  static String backendUrl = dotenv.get('BASE_URL'); // 192.168.132.172

  /// Fetches a custom token from the backend for the given user ID
  static Future<String> fetchCustomToken(String userId) async {
    try {
      final url = backendUrl + ApiEndpoints.customToken;
      //    debugPrint(url);
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        throw Exception('Failed to fetch custom token: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching custom token: $e');
    }
  }

  /// Authenticates the user with Firebase using the provided custom token
  static Future<void> authenticateWithFirebase(String customToken) async {}

  /// Logs out the current Firebase user
  static Future<void> logout() async {
    // try {
    //   await FirebaseAuth.instance.signOut();
    //   //    print('User logged out successfully');
    // } catch (e) {
    //   throw Exception('Error during logout: $e');
    // }
  }

  /// Gets the currently authenticated user's UID
  static String? getCurrentUserId() {
    return null;
  }
}
