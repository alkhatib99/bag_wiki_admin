import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/section_model.dart';

class ApiService extends GetxService {
  // Corrected base URL to point to the root of the API
  final String baseUrl = 'https://bag-wiki-api-dart.onrender.com';
  final storage = const FlutterSecureStorage();

  ApiService();

  // Get JWT token from secure storage
  Future<String?> _getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  // Login function (already correctly implemented)
  login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'), // Corrected endpoint
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await storage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Login failed');
    }
  }

  // Add authorization header if token exists
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // GET all sections
  Future<List<SectionModel>> getSections() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/sections'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => SectionModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      handleUnauthorized();
      throw Exception('Unauthorized: Session expired or invalid token');
    } else {
      throw Exception(
          'Failed to load sections: ${response.statusCode} ${response.body}');
    }
  }

  // GET section by ID
  Future<SectionModel> getSectionById(int id) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/sections/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return SectionModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      handleUnauthorized();
      throw Exception('Unauthorized: Session expired or invalid token');
    } else {
      throw Exception(
          'Failed to load section: ${response.statusCode} ${response.body}');
    }
  }

  // POST new section
  Future<http.Response> createSection(SectionModel section) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/sections/create'),
      headers: headers,
      body: json.encode(section.toJson()),
    );
    if (response.statusCode == 401) {
      handleUnauthorized();
    }
    return response;
  }

  // PUT update section - Fixed to use correct endpoint
  Future<http.Response> updateSection(SectionModel section) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/api/sections/${section.id}/update'), // Fixed endpoint
      headers: headers,
      body: json.encode(section.toJson()),
    );
    if (response.statusCode == 401) {
      handleUnauthorized();
    }
    return response;
  }

  // DELETE section
  Future<http.Response> deleteSection(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/sections/$id'),
      headers: headers,
    );
    if (response.statusCode == 401) {
      handleUnauthorized();
    }
    return response;
  }

  // Handle unauthorized responses (token expired)
  void handleUnauthorized() {
    // Clear token and redirect to login
    storage.delete(key: 'jwt_token');
    storage.delete(key: 'admin_data'); // Clear admin data as well
    Get.offAllNamed('/login');
    Get.snackbar(
      'Session Expired',
      'Please log in again to continue',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      margin: const EdgeInsets.all(16),
    );
  }
}
