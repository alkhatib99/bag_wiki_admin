import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/section_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_button.dart';
import '../widgets/section_card.dart';
import '../widgets/confirm_dialog.dart';

class DashboardView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final SectionController sectionController = Get.find<SectionController>();

  DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Text(
          'BAG WIKI ADMIN',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
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
        actions: [
          // User profile button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(() => PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      authController.logout();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authController.userData.value['username'] ?? 'User',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          Text(
                            authController.userData.value['email'] ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textGrey,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: authController.isAdmin()
                                  ? AppTheme.primaryPurple.withOpacity(0.2)
                                  : AppTheme.accentBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              authController.isAdmin() ? 'Admin' : 'Viewer',
                              style: TextStyle(
                                fontSize: 10,
                                color: authController.isAdmin()
                                    ? AppTheme.primaryPurple
                                    : AppTheme.accentBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: AppTheme.error),
                          SizedBox(width: 8),
                          Text('Logout',
                              style: TextStyle(color: AppTheme.error)),
                        ],
                      ),
                    ),
                  ],
                  child: CircleAvatar(
                    backgroundColor: AppTheme.primaryPurple,
                    child: Text(
                      authController.userData.value['username']
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sections',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          '${sectionController.sections.length} items',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                  ],
                ),
                // Only show add button for admin users
                Obx(() => authController.isAdmin()
                    ? SharedButton(
                        text: 'Add Section',
                        icon: Icons.add,
                        onPressed: () => Get.toNamed('/edit-section'),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),

          // Sections list
          Expanded(
            child: Obx(() {
              if (sectionController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryPurple,
                  ),
                );
              }

              if (sectionController.sections.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No sections found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (authController.isAdmin())
                        TextButton(
                          onPressed: () => Get.toNamed('/edit-section'),
                          child: const Text('Add your first section'),
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => sectionController.fetchSections(),
                color: AppTheme.primaryPurple,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sectionController.sections.length,
                  itemBuilder: (context, index) {
                    final section = sectionController.sections[index];
                    return SectionCard(
                      section: section.toJson(),
                      onEdit: authController.isAdmin()
                          ? () =>
                              Get.toNamed('/edit-section', arguments: section)
                          : null,
                      onDelete: authController.isAdmin()
                          ? () => _confirmDelete(section.id ?? 0)
                          : null,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: Get.context!,
      builder: (context) => ConfirmDialog(
        title: 'Delete Section',
        content:
            'Are you sure you want to delete this section? This action cannot be undone.',
        confirmText: 'Delete',
        cancelText: 'Cancel',
        isDestructive: true,
        onConfirm: () {
          Get.back();
          sectionController.deleteSection(id);
        },
      ),
    );
  }
}
