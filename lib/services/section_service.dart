import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/section_model.dart';

class SectionService {
  // Production API endpoint for Render-deployed Dart backend
  final String baseUrl = 'https://bag-wiki-api-dart.onrender.com/api/sections';

  Future<List<SectionModel>> getSections() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => SectionModel.fromJson(data)).toList();
      } else {
        throw Exception(
            'Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load sections: $e');
    }
  }

  Future<SectionModel> getSection(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return SectionModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load section: $e');
    }
  }

  Future<SectionModel> createSection(SectionModel section) async {
    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(section.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        return SectionModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to create section: $e');
    }
  }

  Future<SectionModel> updateSection(SectionModel section) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/${section.id}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(section.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return SectionModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to update section: $e');
    }
  }

  Future<void> deleteSection(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
            'Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to delete section: $e');
    }
  }
}
