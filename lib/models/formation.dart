class Formation {
  final String id;
  final String name;
  final String shortName;
  final String type;
  final Location location;
  final String description;
  final String image;
  final String website;
  final String phone;
  final String email;
  final List<Program> programs;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Formation({
    required this.id,
    required this.name,
    required this.shortName,
    required this.type,
    required this.location,
    required this.description,
    required this.image,
    required this.website,
    required this.phone,
    required this.email,
    required this.programs,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Formation.fromJson(Map<String, dynamic> json) {
    return Formation(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      shortName: json['shortName'] ?? '',
      type: json['type'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      website: json['website'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      programs: (json['programs'] as List<dynamic>?)
          ?.map((program) => Program.fromJson(program))
          .toList() ?? [],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'shortName': shortName,
      'type': type,
      'location': location.toJson(),
      'description': description,
      'image': image,
      'website': website,
      'phone': phone,
      'email': email,
      'programs': programs.map((program) => program.toJson()).toList(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Location {
  final String city;
  final String district;
  final String address;

  Location({
    required this.city,
    required this.district,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'district': district,
      'address': address,
    };
  }
}

class Program {
  final String name;
  final String level;
  final String duration;
  final String language;

  Program({
    required this.name,
    required this.level,
    required this.duration,
    required this.language,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      name: json['name'] ?? '',
      level: json['level'] ?? '',
      duration: json['duration'] ?? '',
      language: json['language'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
      'duration': duration,
      'language': language,
    };
  }
}
