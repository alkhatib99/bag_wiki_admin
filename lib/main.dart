import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bag_wiki_admin/controllers/auth_controller.dart';
import 'package:bag_wiki_admin/controllers/section_controller.dart';
import 'package:bag_wiki_admin/services/api_service.dart';
import 'package:bag_wiki_admin/views/login_view.dart';
import 'package:bag_wiki_admin/views/dashboard_view.dart';
import 'package:bag_wiki_admin/views/edit_section_view.dart';
import 'package:bag_wiki_admin/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BAG Wiki Admin',
      theme: AppTheme.themeData,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(
          name: '/dashboard',
          page: () => DashboardView(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/edit-section',
          page: () => EditSectionView(),
          transition: Transition.rightToLeft,
        ),
      ],
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize API service
    Get.put(ApiService(baseUrl: 'https://bag-wiki-api_dart.onrender.com'),
        permanent: true);

    // Initialize controllers
    Get.put(AuthController(), permanent: true);
    Get.put(SectionController(), permanent: true);
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Check auth status after animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkAuthStatus();
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    final authController = Get.find<AuthController>();
    await authController.checkLoginStatus();

    if (authController.isLoggedIn.value) {
      Get.offAllNamed('/dashboard');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
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
                      child: Image.network(
                        'https://dapp.bagguild.com/assets/images/logo.png',
                        errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.account_circle,
                            size: 120,
                            color: AppTheme.primaryPurple),
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
