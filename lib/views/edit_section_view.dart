import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/section_controller.dart';
import '../models/section_model.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_button.dart';

class EditSectionView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final SectionController sectionController = Get.find<SectionController>();
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  
  final RxBool isEditing = false.obs;
  final RxInt sectionId = RxInt(-1);

  EditSectionView({Key? key}) : super(key: key) {
    // Check if we're editing an existing section
    if (Get.arguments != null) {
      final section = Get.arguments as Map<String, dynamic>;
      sectionId.value = section['id'];
      titleController.text = section['title'] ?? '';
      contentController.text = section['content'] ?? '';
      imageUrlController.text = section['imageUrl'] ?? '';
      isEditing.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Obx(() => Text(
          isEditing.value ? 'Edit Section' : 'Create Section',
          style: TextStyle(
            shadows: [
              Shadow(
                color: AppTheme.primaryPurple.withOpacity(0.7),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Show confirmation if form has been modified
            if (_isFormModified()) {
              _showDiscardChangesDialog(context);
            } else {
              Get.back();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: AppTheme.glassCardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field
                    Text(
                      'TITLE',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter section title',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Content field
                    Text(
                      'CONTENT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: contentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter section content',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                      maxLines: 10,
                    ),
                    const SizedBox(height: 24),
                    
                    // Image URL field
                    Text(
                      'IMAGE URL',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: imageUrlController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter image URL',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Image preview
                    Obx(() {
                      final imageUrl = imageUrlController.text.obs.value;
                      if (imageUrl.isEmpty) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.inputDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 48,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No image URL provided',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IMAGE PREVIEW',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.inputDark,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.red[400],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Failed to load image',
                                        style: TextStyle(
                                          color: Colors.red[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppTheme.inputDark,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme.primaryPurple,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Error message
              Obx(() => sectionController.errorMessage.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
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
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              sectionController.errorMessage.value,
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
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SharedButton(
                    text: 'Cancel',
                    icon: Icons.close,
                    isSecondary: true,
                    onPressed: () {
                      if (_isFormModified()) {
                        _showDiscardChangesDialog(context);
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  Obx(() => SharedButton(
                    text: isEditing.value ? 'Update' : 'Create',
                    icon: isEditing.value ? Icons.save : Icons.add,
                    isLoading: sectionController.isLoading.value,
                    onPressed: _handleSubmit,
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  bool _isFormModified() {
    if (isEditing.value) {
      final section = Get.arguments as Map<String, dynamic>;
      return titleController.text != section['title'] ||
             contentController.text != section['content'] ||
             imageUrlController.text != section['imageUrl'];
    } else {
      return titleController.text.isNotEmpty ||
             contentController.text.isNotEmpty ||
             imageUrlController.text.isNotEmpty;
    }
  }
  
  void _showDiscardChangesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'Discard Changes?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: TextStyle(color: AppTheme.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.back();
            },
            style: AppTheme.dangerButtonStyle,
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
  
  void _handleSubmit() {
    // Validate form
    if (titleController.text.isEmpty) {
      sectionController.setErrorMessage('Title is required');
      return;
    }
    
    if (contentController.text.isEmpty) {
      sectionController.setErrorMessage('Content is required');
      return;
    }
    
    if (imageUrlController.text.isEmpty) {
      sectionController.setErrorMessage('Image URL is required');
      return;
    }
    
    // Create section model
    final section = SectionModel(
      id: isEditing.value ? sectionId.value : null,
      title: titleController.text,
      content: contentController.text,
      imageUrl: imageUrlController.text,
    );
    
    // Submit form
    if (isEditing.value) {
      sectionController.updateSection(section);
    } else {
      // sectionController.createSection(section);
    }
  }
}
