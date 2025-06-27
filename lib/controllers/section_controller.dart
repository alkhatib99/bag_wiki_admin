import 'package:bag_wiki_admin/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/section_model.dart';
import '../services/section_service.dart';

class SectionController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<SectionModel> sections = <SectionModel>[].obs;
  final Rx<SectionModel?> selectedSection = Rx<SectionModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxBool isDeleting = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeletingSection = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSections();
  }

  Future<void> fetchSections() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      sections.value = await _apiService.getSections();
      print('Sections loaded: ${sections.length}');
    } catch (e) {
      print('Error fetching sections: $e');
      _showErrorSnackbar('Failed to load sections', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSection(SectionModel section) async {
    try {
      isCreating.value = true;
      final response = await _apiService.createSection(section);
      if (response.statusCode == 201) {
        await fetchSections();
        Get.back();
        _showSuccessSnackbar(
            'Section created', 'The section has been created successfully.');
      } else {
        throw Exception('Failed to create section: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to create section', e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateSection(SectionModel section) async {
    try {
      isUpdating.value = true;
      final response = await _apiService.updateSection(section);
      if (response.statusCode == 200) {
        await fetchSections();
        Get.back();
        _showSuccessSnackbar(
            'Section updated', 'The section has been updated successfully.');
      } else {
        throw Exception('Failed to update section: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to update section', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteSection(int id) async {
    try {
      isDeletingSection.value = true;
      final response = await _apiService.deleteSection(id);
      if (response.statusCode == 204 || response.statusCode == 200) {
        await fetchSections();
        _showSuccessSnackbar(
            'Section deleted', 'The section has been deleted successfully.');
      } else {
        throw Exception('Failed to delete section: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to delete section', e.toString());
    } finally {
      isDeletingSection.value = false;
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
    );
  }

  void setErrorMessage(String s) {
    errorMessage.value = s;
    Future.delayed(const Duration(seconds: 5), () {
      if (errorMessage.value == s) {
        errorMessage.value = '';
      }
    });
  }
}
