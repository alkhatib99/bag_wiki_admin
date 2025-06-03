import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool rememberMe = false.obs;

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            // Add ConstrainedBox to limit the width on larger screens
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxWidth: 450), // Max width for the form area
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
                      // Use local asset for the logo
                      child: Image.asset(
                        'assets/images/logo.png', // Load from local assets
                        errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.account_circle,
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
                    'Login to manage content',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Login Form Container (already has padding)
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
                          'EMAIL',
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
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            filled: true,
                            fillColor: AppTheme.inputDark,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppTheme.primaryPurple,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppTheme.primaryPurple,
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),

                        // Password Field
                        Text(
                          'PASSWORD',
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
                              obscureText:
                                  !authController.passwordVisible.value,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
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
                              ),
                            )),
                        const SizedBox(height: 16),

                        // Remember Me Checkbox
                        Row(
                          children: [
                            Obx(() => Checkbox(
                                  value: rememberMe.value,
                                  onChanged: (value) =>
                                      rememberMe.value = value ?? false,
                                  activeColor: AppTheme.primaryPurple,
                                  checkColor: Colors.white,
                                  side: BorderSide(color: Colors.grey[600]!),
                                )),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        Obx(() => ElevatedButton(
                              onPressed: authController.isLoading.value
                                  ? null
                                  : () => _handleLogin(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryPurple,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 5,
                                shadowColor:
                                    AppTheme.primaryPurple.withOpacity(0.5),
                              ),
                              child: authController.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'LOGIN',
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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authController.errorMessage.value,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink()),
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
      authController.setErrorMessage('Email is required');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      authController.setErrorMessage('Please enter a valid email');
      return;
    }

    if (password.isEmpty) {
      authController.setErrorMessage('Password is required');
      return;
    }

    // Attempt login
    authController.login(email, password, rememberMe.value);
  }
}
