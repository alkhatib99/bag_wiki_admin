import 'package:json_annotation/json_annotation.dart';

part 'section_model.g.dart';

@JsonSerializable()
class SectionModel {
  final int? id;
  final String title;
  final String content;
  
  @JsonKey(name: 'imageUrl')
  final String imageUrl;
  
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  
  SectionModel({
    this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });
  
  factory SectionModel.fromJson(Map<String, dynamic> json) => _$SectionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SectionModelToJson(this);
}
