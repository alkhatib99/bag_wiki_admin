import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({Key? key}) : super(key: key) {
    // Check for prefilled credentials from environment (optional)
    _loadPrefillCredentials();
  }

  // Load prefilled credentials if available
  void _loadPrefillCredentials() async {
    // This could be extended to read from .env or .env.local files
    // For now, we'll leave it empty but the structure is ready
    // You can uncomment and modify the following lines if you have environment setup:
    
    // const adminEmail = String.fromEnvironment('ADMIN_EMAIL', defaultValue: '');
    // const adminPassword = String.fromEnvironment('ADMIN_PASSWORD', defaultValue: '');
    
    // if (adminEmail.isNotEmpty) {
    //   emailController.text = adminEmail;
    // }
    // if (adminPassword.isNotEmpty) {
    //   passwordController.text = adminPassword;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and Header
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.admin_panel_settings,
                            size: 120,
                            color: AppTheme.primaryPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'BAG WIKI ADMIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: AppTheme.primaryPurple.withOpacity(0.7),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Admin Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Login Form Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: AppTheme.primaryPurple.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        Text(
                          'ADMIN EMAIL',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter admin email',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            filled: true,
                            fillColor: AppTheme.inputDark,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.admin_panel_settings,
                              color: AppTheme.primaryPurple,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppTheme.primaryPurple,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            // Clear error message when user starts typing
                            if (authController.errorMessage.isNotEmpty) {
                              authController.clearErrorMessage();
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Password Field
                        Text(
                          'ADMIN PASSWORD',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => TextField(
                              controller: passwordController,
                              obscureText: !authController.passwordVisible.value,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter admin password',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                filled: true,
                                fillColor: AppTheme.inputDark,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: AppTheme.primaryPurple,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    authController.passwordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () =>
                                      authController.togglePasswordVisibility(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryPurple,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                // Clear error message when user starts typing
                                if (authController.errorMessage.isNotEmpty) {
                                  authController.clearErrorMessage();
                                }
                              },
                              onSubmitted: (value) {
                                // Allow login on Enter key press
                                _handleLogin();
                              },
                            )),
                        const SizedBox(height: 32),

                        // Login Button
                        Obx(() => ElevatedButton(
                              onPressed: authController.isLoading.value
                                  ? null
                                  : () => _handleLogin(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 5,
                                shadowColor: AppTheme.primaryPurple.withOpacity(0.5),
                                disabledBackgroundColor: Colors.grey[700],
                              ),
                              child: authController.isLoading.value
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'LOGGING IN...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'LOGIN AS ADMIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            )),
                      ],
                    ),
                  ),

                  // Error Message
                  const SizedBox(height: 24),
                  Obx(() => authController.errorMessage.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Login Failed',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      authController.errorMessage.value,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => authController.clearErrorMessage(),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink()),

                  // Info message for development
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[300],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Use the admin credentials configured in your backend environment.',
                            style: TextStyle(
                              color: Colors.blue[300],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Basic validation
    if (email.isEmpty) {
      authController.setErrorMessage('Admin email is required');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      authController.setErrorMessage('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      authController.setErrorMessage('Admin password is required');
      return;
    }

    // Attempt login
    authController.login(email, password);
  }
}

