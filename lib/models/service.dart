class Service {
  final String id;
  final String name;
  final String category;
  final String subcategory;
  final String description;
  final Price price;
  final ServiceLocation location;
  final Contact contact;
  final String image;
  final List<String> features;
  final double rating;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.price,
    required this.location,
    required this.contact,
    required this.image,
    required this.features,
    required this.rating,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      description: json['description'] ?? '',
      price: Price.fromJson(json['price'] ?? {}),
      location: ServiceLocation.fromJson(json['location'] ?? {}),
      contact: Contact.fromJson(json['contact'] ?? {}),
      image: json['image'] ?? '',
      features: (json['features'] as List<dynamic>?)
          ?.map((feature) => feature.toString())
          .toList() ?? [],
      rating: (json['rating'] ?? 0).toDouble(),
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
      'category': category,
      'subcategory': subcategory,
      'description': description,
      'price': price.toJson(),
      'location': location.toJson(),
      'contact': contact.toJson(),
      'image': image,
      'features': features,
      'rating': rating,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Price {
  final double amount;
  final String currency;
  final String period;

  Price({
    required this.amount,
    required this.currency,
    required this.period,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'FCFA',
      period: json['period'] ?? 'one_time',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'period': period,
    };
  }
}

class ServiceLocation {
  final String city;
  final String district;
  final String address;

  ServiceLocation({
    required this.city,
    required this.district,
    required this.address,
  });

  factory ServiceLocation.fromJson(Map<String, dynamic> json) {
    return ServiceLocation(
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

class Contact {
  final String phone;
  final String email;
  final String website;

  Contact({
    required this.phone,
    required this.email,
    required this.website,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
    };
  }
}
