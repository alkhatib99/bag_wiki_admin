import 'package:bag_wiki_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final storage = const FlutterSecureStorage();

  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool passwordVisible = false.obs;

  // Admin user data (simplified for single admin)
  final Rx<Map<String, dynamic>> adminData = Rx<Map<String, dynamic>>({});

  @override
  onInit() async {
    await checkLoginStatus();
    super.onInit();
  }

  // Check if admin is already logged in
  checkLoginStatus() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final token = await storage.read(key: 'jwt_token');
      if (token != null) {
        // Validate token by making a request to the API
        // If getSections throws an error (e.g., 401), it will be caught
        await _apiService.getSections(); // Just call to validate token
        
        // If getSections succeeds, token is valid
        final adminDataStr = await storage.read(key: 'admin_data');
        if (adminDataStr != null) {
          adminData.value = json.decode(adminDataStr);
          isLoggedIn.value = true;
          // Navigate to dashboard if not already there
          if (Get.currentRoute != AppRoutes.dashboard) {
            Get.offAllNamed(AppRoutes.dashboard);
          }
        } else {
          // Token exists but no admin data, logout
          await logout(showConfirmation: false);
        }
      } else {
        // No token, ensure we are on login page
        if (Get.currentRoute != AppRoutes.login) {
          Get.offAllNamed(AppRoutes.login);
        }
      }
    } catch (e) {
      print('Error checking login status: $e');
      // If token validation fails, logout
      await logout(showConfirmation: false);
    } finally {
      isLoading.value = false;
    }
  }

  // Login function for admin only
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      var response = await http.post(
        Uri.parse('${_apiService.baseUrl}/auth/login'), // Corrected endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final user = data['user'];

        // Store token and admin data
        await storage.write(key: 'jwt_token', value: token);
        await storage.write(key: 'admin_data', value: json.encode(user));

        // Update controller state
        adminData.value = user;
        isLoggedIn.value = true;

        // Navigate to dashboard
        Get.offAllNamed(AppRoutes.dashboard);
        
        // Show success message
        Get.snackbar(
          'Login Successful',
          'Welcome to BAG Wiki Admin Dashboard',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );
      } else if (response.statusCode == 401) {
        setErrorMessage('Invalid admin credentials. Please check your email and password.');
      } else {
        final data = json.decode(response.body);
        setErrorMessage(data['error'] ?? 'Login failed. Please try again.');
      }
    } catch (e) {
      setErrorMessage('Connection error. Please check your internet connection and try again.');
      print('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Logout function
  Future<void> logout({bool showConfirmation = true}) async {
    if (showConfirmation) {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Logout', style: TextStyle(color: Color(0xFF9353D3))),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    // Clear all storage
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'admin_data');

    // Update controller state
    adminData.value = {};
    isLoggedIn.value = false;

    // Navigate to login
    Get.offAllNamed('/login');
    
    if (showConfirmation) {
      Get.snackbar(
        'Logged Out',
        'You have been successfully logged out',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Check if logged in user is admin (always true for this simplified version)
  bool isAdmin() {
    return isLoggedIn.value && adminData.value.isNotEmpty;
  }

  // Get admin email
  String getAdminEmail() {
    return adminData.value['email'] ?? '';
  }

  // Set error message with auto-clear after 5 seconds
  void setErrorMessage(String message) {
    errorMessage.value = message;
    Future.delayed(const Duration(seconds: 5), () {
      if (errorMessage.value == message) {
        errorMessage.value = '';
      }
    });
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  // Clear error message manually
  void clearErrorMessage() {
    errorMessage.value = '';
  }
}


