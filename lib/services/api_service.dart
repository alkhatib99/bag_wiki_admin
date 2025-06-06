import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/section_model.dart';

class ApiService extends GetxService {
  final String baseUrl;
  final storage = const FlutterSecureStorage();

  ApiService({required this.baseUrl});

  // Get JWT token from secure storage
  Future<String?> _getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await storage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      throw Exception('Login failed');
    }
  }

  // Get all sections (with pagination)
  // Future<Map
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
  Future<http.Response> getSections() async {
    final headers = await _getHeaders();
    return http.get(
      Uri.parse('$baseUrl/api/sections'),
      headers: headers,
    );
  }

  // GET section by ID
  Future<http.Response> getSectionById(int id) async {
    final headers = await _getHeaders();
    return http.get(
      Uri.parse('$baseUrl/api/sections/$id'),
      headers: headers,
    );
  }

  // POST new section
  Future<http.Response> createSection(SectionModel section) async {
    final headers = await _getHeaders();
    return http.post(
      Uri.parse('$baseUrl/api/sections'),
      headers: headers,
      body: json.encode(section.toJson()),
    );
  }

  // PUT update section
  Future<http.Response> updateSection(SectionModel section) async {
    final headers = await _getHeaders();
    return http.put(
      Uri.parse('$baseUrl/api/sections/${section.id}'),
      headers: headers,
      body: json.encode(section.toJson()),
    );
  }

  // DELETE section
  Future<http.Response> deleteSection(int id) async {
    final headers = await _getHeaders();
    return http.delete(
      Uri.parse('$baseUrl/api/sections/$id'),
      headers: headers,
    );
  }

  // Handle unauthorized responses (token expired)
  void handleUnauthorized() {
    // Clear token and redirect to login
    storage.delete(key: 'jwt_token');
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
