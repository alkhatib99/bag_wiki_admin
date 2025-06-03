import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/section_model.dart';
import '../services/section_service.dart';

class SectionController extends GetxController {
  final SectionService _sectionService = SectionService();
  
  final RxList<SectionModel> sections = <SectionModel>[].obs;
  final Rx<SectionModel?> selectedSection = Rx<SectionModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxBool isDeleting = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchSections();
  }
  
  Future<void> fetchSections() async {
    try {
      isLoading.value = true;
      sections.value = await _sectionService.getSections();
    } catch (e) {
      _showErrorSnackbar('Failed to load sections', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> getSection(int id) async {
    try {
      isLoading.value = true;
      selectedSection.value = await _sectionService.getSection(id);
    } catch (e) {
      _showErrorSnackbar('Failed to load section', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> createSection(SectionModel section) async {
    try {
      isLoading.value = true;
      await _sectionService.createSection(section);
      await fetchSections();
      Get.back();
      _showSuccessSnackbar('Section created', 'The section has been created successfully.');
    } catch (e) {
      _showErrorSnackbar('Failed to create section', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> updateSection(SectionModel section) async {
    try {
      isLoading.value = true;
      await _sectionService.updateSection(section);
      await fetchSections();
      Get.back();
      _showSuccessSnackbar('Section updated', 'The section has been updated successfully.');
    } catch (e) {
      _showErrorSnackbar('Failed to update section', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> deleteSection(int id) async {
    try {
      isDeleting.value = true;
      await _sectionService.deleteSection(id);
      await fetchSections();
      _showSuccessSnackbar('Section deleted', 'The section has been deleted successfully.');
    } catch (e) {
      _showErrorSnackbar('Failed to delete section', e.toString());
    } finally {
      isDeleting.value = false;
    }
  }
  
  void setSelectedSection(SectionModel? section) {
    selectedSection.value = section;
    isEditing.value = section != null;
  }
  
  void clearSelectedSection() {
    selectedSection.value = null;
    isEditing.value = false;
  }
  
  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade800,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
  
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade800,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
