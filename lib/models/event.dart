class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final EventLocation location;
  final String category;
  final String image;
  final Organizer organizer;
  final int capacity;
  final List<String> registeredUsers;
  final bool isFree;
  final Price price;
  final List<String> requirements;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.image,
    required this.organizer,
    required this.capacity,
    required this.registeredUsers,
    required this.isFree,
    required this.price,
    required this.requirements,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] ?? '',
      location: EventLocation.fromJson(json['location'] ?? {}),
      category: json['category'] ?? 'other',
      image: json['image'] ?? '',
      organizer: Organizer.fromJson(json['organizer'] ?? {}),
      capacity: json['capacity'] ?? 0,
      registeredUsers: (json['registeredUsers'] as List<dynamic>?)
          ?.map((user) => user.toString())
          .toList() ?? [],
      isFree: json['isFree'] ?? true,
      price: Price.fromJson(json['price'] ?? {}),
      requirements: (json['requirements'] as List<dynamic>?)
          ?.map((req) => req.toString())
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
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time,
      'location': location.toJson(),
      'category': category,
      'image': image,
      'organizer': organizer.toJson(),
      'capacity': capacity,
      'registeredUsers': registeredUsers,
      'isFree': isFree,
      'price': price.toJson(),
      'requirements': requirements,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class EventLocation {
  final String name;
  final String address;
  final String city;

  EventLocation({
    required this.name,
    required this.address,
    required this.city,
  });

  factory EventLocation.fromJson(Map<String, dynamic> json) {
    return EventLocation(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
    };
  }
}

class Organizer {
  final String name;
  final OrganizerContact contact;

  Organizer({
    required this.name,
    required this.contact,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      name: json['name'] ?? '',
      contact: OrganizerContact.fromJson(json['contact'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact.toJson(),
    };
  }
}

class OrganizerContact {
  final String phone;
  final String email;

  OrganizerContact({
    required this.phone,
    required this.email,
  });

  factory OrganizerContact.fromJson(Map<String, dynamic> json) {
    return OrganizerContact(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
    };
  }
}

class Price {
  final double amount;
  final String currency;

  Price({
    required this.amount,
    required this.currency,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'FCFA',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
    };
  }
}
