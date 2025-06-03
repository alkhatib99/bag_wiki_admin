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
  
  // User data
  final Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});
  
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }
  
  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    final token = await storage.read(key: 'jwt_token');
    if (token != null) {
      try {
        // Validate token by making a request to the API
        final response = await _apiService.getSections();
        if (response.statusCode == 200) {
          // Token is valid, get user data from storage
          final userDataStr = await storage.read(key: 'user_data');
          if (userDataStr != null) {
            userData.value = json.decode(userDataStr);
            isLoggedIn.value = true;
          }
        } else {
          // Token is invalid, clear storage
          await logout(showConfirmation: false);
        }
      } catch (e) {
        print('Error checking login status: $e');
        await logout(showConfirmation: false);
      }
    }
  }
  
  // Login function
  Future<void> login(String email, String password, bool rememberMe) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await http.post(
        Uri.parse('${_apiService.baseUrl}/auth/login'),
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
        
        // Store token and user data
        await storage.write(key: 'jwt_token', value: token);
        await storage.write(key: 'user_data', value: json.encode(user));
        
        // Store remember me preference
        await storage.write(key: 'remember_me', value: rememberMe.toString());
        
        // Update controller state
        userData.value = user;
        isLoggedIn.value = true;
        
        // Navigate to dashboard
        Get.offAllNamed('/dashboard');
      } else {
        final data = json.decode(response.body);
        setErrorMessage(data['error'] ?? 'Login failed');
      }
    } catch (e) {
      setErrorMessage('Connection error. Please try again.');
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
    
    // Check if "remember me" was enabled
    final rememberMe = await storage.read(key: 'remember_me');
    
    // Clear storage
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'user_data');
    
    // Keep remember me preference if it was true
    if (rememberMe == 'true') {
      await storage.write(key: 'remember_me', value: 'true');
    } else {
      await storage.delete(key: 'remember_me');
    }
    
    // Update controller state
    userData.value = {};
    isLoggedIn.value = false;
    
    // Navigate to login
    Get.offAllNamed('/login');
  }
  
  // Check if user has admin role
  bool isAdmin() {
    return userData.value['role'] == 'admin';
  }
  
  // Check if user has viewer role
  bool isViewer() {
    return userData.value['role'] == 'viewer';
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
}
