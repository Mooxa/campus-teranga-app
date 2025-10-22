import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

/// Event model for student events and activities
@JsonSerializable()
class Event {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String? address;
  final double? price;
  final int? maxParticipants;
  final int currentParticipants;
  final List<String> tags;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.address,
    this.price,
    this.maxParticipants,
    required this.currentParticipants,
    required this.tags,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    String? address,
    double? price,
    int? maxParticipants,
    int? currentParticipants,
    List<String>? tags,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      address: address ?? this.address,
      price: price ?? this.price,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if the event is upcoming
  bool get isUpcoming => startDate.isAfter(DateTime.now());

  /// Check if the event is past
  bool get isPast => endDate.isBefore(DateTime.now());

  /// Check if the event is currently happening
  bool get isOngoing => 
      startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now());

  /// Check if the event has available spots
  bool get hasAvailableSpots => 
      maxParticipants == null || currentParticipants < maxParticipants!;

  /// Get remaining spots
  int? get remainingSpots => 
      maxParticipants != null ? maxParticipants! - currentParticipants : null;

  /// Get formatted date range
  String get formattedDateRange {
    final start = '${startDate.day}/${startDate.month}/${startDate.year}';
    final end = '${endDate.day}/${endDate.month}/${endDate.year}';
    return startDate.year == endDate.year && 
           startDate.month == endDate.month && 
           startDate.day == endDate.day
        ? start
        : '$start - $end';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Event(id: $id, title: $title, category: $category, startDate: $startDate)';
  }
}
