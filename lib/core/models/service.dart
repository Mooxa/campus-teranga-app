import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

/// Service model for student services
@JsonSerializable()
class Service {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? subcategory;
  final String? city;
  final String? contact;
  final String? website;
  final double? price;
  final List<String> tags;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Service({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.subcategory,
    this.city,
    this.contact,
    this.website,
    this.price,
    required this.tags,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  Service copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? subcategory,
    String? city,
    String? contact,
    String? website,
    double? price,
    List<String>? tags,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      city: city ?? this.city,
      contact: contact ?? this.contact,
      website: website ?? this.website,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Service && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Service(id: $id, title: $title, category: $category)';
  }
}
