class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final double area;
  final int bedrooms;
  final int bathrooms;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  final List<String> amenities;
  final String propertyType; // 'apartment', 'house', 'condo', etc.
  final String landlordId;
  final String landlordName;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    required this.amenities,
    required this.propertyType,
    required this.landlordId,
    required this.landlordName,
    required this.isAvailable,
    required this.createdAt,
    this.updatedAt,
  });

  Property copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    double? area,
    int? bedrooms,
    int? bathrooms,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? imageUrls,
    List<String>? amenities,
    String? propertyType,
    String? landlordId,
    String? landlordName,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      area: area ?? this.area,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrls: imageUrls ?? this.imageUrls,
      amenities: amenities ?? this.amenities,
      propertyType: propertyType ?? this.propertyType,
      landlordId: landlordId ?? this.landlordId,
      landlordName: landlordName ?? this.landlordName,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrls: List<String>.from(json['imageUrls'] as List),
      amenities: List<String>.from(json['amenities'] as List),
      propertyType: json['propertyType'] as String,
      landlordId: json['landlordId'] as String,
      landlordName: json['landlordName'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'area': area,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrls': imageUrls,
      'amenities': amenities,
      'propertyType': propertyType,
      'landlordId': landlordId,
      'landlordName': landlordName,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
