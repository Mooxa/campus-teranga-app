// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Formation _$FormationFromJson(Map<String, dynamic> json) => Formation(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      level: json['level'] as String,
      duration: json['duration'] as String,
      city: json['city'] as String,
      institution: json['institution'] as String,
      price: (json['price'] as num?)?.toDouble(),
      requirements: json['requirements'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FormationToJson(Formation instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'level': instance.level,
      'duration': instance.duration,
      'city': instance.city,
      'institution': instance.institution,
      'price': instance.price,
      'requirements': instance.requirements,
      'tags': instance.tags,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
