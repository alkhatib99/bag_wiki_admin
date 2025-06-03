import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/section_model.dart';

class SectionService {
  final String baseUrl = 'https://bag-wiki-api-dart.onrender.com/api/sections';

  Future<List<SectionModel>> getSections() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SectionModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load sections');
    }
  }

  Future<SectionModel> getSection(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return SectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load section');
    }
  }

  Future<SectionModel> createSection(SectionModel section) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(section.toJson()),
    );
    if (response.statusCode == 201) {
      return SectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create section');
    }
  }

  Future<SectionModel> updateSection(SectionModel section) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${section.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(section.toJson()),
    );
    if (response.statusCode == 200) {
      return SectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update section');
    }
  }

  Future<void> deleteSection(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete section');
    }
  }
}