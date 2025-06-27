import 'package:bag_wiki_admin/models/section_model.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
class SectionCard extends StatefulWidget {
  final SectionModel section;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(SectionModel)? onSave;

  const SectionCard({
    Key? key,
    required this.section,
    this.onEdit,
    this.onDelete,
    this.onSave,
  }) : super(key: key);

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.section.title);
    _contentController = TextEditingController(text: widget.section.content);
    _imageUrlController = TextEditingController(text: widget.section.imageUrl);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset controllers if cancelling edit
        _titleController.text = widget.section.title;
        _contentController.text = widget.section.content;
        _imageUrlController.text = widget.section.imageUrl;
      }
    });
  }

  void _saveChanges() {
    if (widget.onSave != null) {
      final updatedSection = SectionModel(
        id: widget.section.id,
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: _imageUrlController.text,
      );
      widget.onSave!(updatedSection);
      _toggleEditMode(); // Exit edit mode after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.glassCardDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            if (widget.section.imageUrl.isNotEmpty)
              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Image.network(
                      widget.section.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.cardDark,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[700],
                            size: 48,
                          ),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppTheme.cardDark,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryPurple,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!_isEditing)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Text(
                        widget.section.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isEditing)
                    Column(
                      children: [
                        _buildTextField(_titleController, 'Title'),
                        const SizedBox(height: 8),
                        _buildTextField(_contentController, 'Content', maxLines: 5),
                        const SizedBox(height: 8),
                        _buildTextField(_imageUrlController, 'Image URL'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _toggleEditMode,
                              child: const Text('Cancel', style: TextStyle(color: AppTheme.textGrey)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.section.imageUrl.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              widget.section.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Text(
                          widget.section.content,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.onEdit != null)
                              IconButton(
                                onPressed: _toggleEditMode,
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit',
                                color: AppTheme.accentBlue,
                                splashRadius: 24,
                              ),
                            if (widget.onDelete != null)
                              IconButton(
                                onPressed: widget.onDelete,
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete',
                                color: AppTheme.error,
                                splashRadius: 24,
                              ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppTheme.textLight),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppTheme.textGrey),
        filled: true,
        fillColor: AppTheme.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
        ),
      ),
    );
  }
}


