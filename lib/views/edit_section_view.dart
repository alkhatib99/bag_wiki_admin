import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/section_controller.dart';
import '../models/section_model.dart';

class EditSectionView extends StatelessWidget {
  EditSectionView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final RxBool _isImageValid = true.obs;
  final RxBool _isHoveringSubmit = false.obs;

  @override
  Widget build(BuildContext context) {
    final SectionController controller = Get.find<SectionController>();
    
    // Initialize form fields if editing an existing section
    if (controller.isEditing.value && controller.selectedSection.value != null) {
      _titleController.text = controller.selectedSection.value!.title;
      _contentController.text = controller.selectedSection.value!.content;
      _imageUrlController.text = controller.selectedSection.value!.imageUrl;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditing.value ? 'Edit Section' : 'Create New Section'
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
          tooltip: 'Back to Dashboard',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              const Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9353D3)),
              ),
            );
          }
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9353D3).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.edit_document,
                                color: Color(0xFF9353D3),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() => Text(
                                    controller.isEditing.value ? 'Edit Section' : 'Create New Section',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Fill in the details below to update the website content',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Title field
                        _buildFormLabel('Section Title'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Enter section title',
                            prefixIcon: const Icon(Icons.title, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Content field
                        _buildFormLabel('Section Content'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _contentController,
                          decoration: InputDecoration(
                            hintText: 'Enter section content',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          maxLines: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter content';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Image URL field
                        _buildFormLabel('Image URL'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: InputDecoration(
                            hintText: 'Enter image URL',
                            prefixIcon: const Icon(Icons.image, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.grey),
                              onPressed: () {
                                // Force image preview refresh
                                if (_imageUrlController.text.isNotEmpty) {
                                  _isImageValid.value = true;
                                }
                              },
                              tooltip: 'Refresh Preview',
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an image URL';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // Reset image validation when URL changes
                            _isImageValid.value = true;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Image preview
                        if (_imageUrlController.text.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('Image Preview'),
                              const SizedBox(height: 8),
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF333333),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      _isImageValid.value = false;
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.broken_image,
                                              color: Colors.red,
                                              size: 48,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Invalid image URL',
                                              style: TextStyle(
                                                color: Colors.red.shade300,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        _isImageValid.value = true;
                                        return child;
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9353D3)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (!_isImageValid.value)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Please enter a valid image URL',
                                    style: TextStyle(
                                      color: Colors.red.shade300,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.cancel_outlined),
                              label: const Text('Cancel'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Obx(() => MouseRegion(
                              onEnter: (_) => _isHoveringSubmit.value = true,
                              onExit: (_) => _isHoveringSubmit.value = false,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                transform: _isHoveringSubmit.value
                                    ? (Matrix4.identity()..scale(1.05))
                                    : Matrix4.identity(),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate() && _isImageValid.value) {
                                      final section = SectionModel(
                                        id: controller.isEditing.value
                                            ? controller.selectedSection.value!.id
                                            : null,
                                        title: _titleController.text,
                                        content: _contentController.text,
                                        imageUrl: _imageUrlController.text,
                                      );
                                      
                                      if (controller.isEditing.value) {
                                        controller.updateSection(section);
                                      } else {
                                        controller.createSection(section);
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    controller.isEditing.value ? Icons.save : Icons.add,
                                    size: 18,
                                  ),
                                  label: Text(
                                    controller.isEditing.value ? 'Save Changes' : 'Create Section'
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    elevation: _isHoveringSubmit.value ? 8 : 4,
                                    shadowColor: const Color(0xFF9353D3).withOpacity(0.5),
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
  
  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
