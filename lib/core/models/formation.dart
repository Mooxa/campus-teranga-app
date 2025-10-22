import 'package:json_annotation/json_annotation.dart';

part 'formation.g.dart';

/// Formation model for educational programs
@JsonSerializable()
class Formation {
  final String id;
  final String title;
  final String description;
  final String type;
  final String level;
  final String duration;
  final String city;
  final String institution;
  final double? price;
  final String? requirements;
  final List<String> tags;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Formation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.level,
    required this.duration,
    required this.city,
    required this.institution,
    this.price,
    this.requirements,
    required this.tags,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Formation.fromJson(Map<String, dynamic> json) => _$FormationFromJson(json);
  Map<String, dynamic> toJson() => _$FormationToJson(this);

  Formation copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? level,
    String? duration,
    String? city,
    String? institution,
    double? price,
    String? requirements,
    List<String>? tags,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Formation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      level: level ?? this.level,
      duration: duration ?? this.duration,
      city: city ?? this.city,
      institution: institution ?? this.institution,
      price: price ?? this.price,
      requirements: requirements ?? this.requirements,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Formation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Formation(id: $id, title: $title, type: $type, level: $level)';
  }
}
