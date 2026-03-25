import 'package:flutter/material.dart';
import '../models/property.dart';

class PropertyProvider extends ChangeNotifier {
  // State variables
  List<Property> _properties = [];
  List<Property> _filteredProperties = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  double _minPrice = 0;
  double _maxPrice = 10000;

  // Getters
  List<Property> get properties => _filteredProperties.isEmpty ? _properties : _filteredProperties;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  PropertyProvider() {
    _initializeMockData();
  }

  // Initialize with mock data
  void _initializeMockData() {
    _properties = [
      Property(
        id: '1',
        title: 'Modern Apartment Downtown',
        description: 'Beautiful 2-bedroom apartment in the heart of downtown with city views.',
        price: 1500,
        area: 950,
        bedrooms: 2,
        bathrooms: 1,
        location: 'Downtown, City Center',
        latitude: 40.7128,
        longitude: -74.0060,
        imageUrls: ['https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500'],
        amenities: ['WiFi', 'Gym', 'Parking', 'Pool'],
        propertyType: 'apartment',
        landlordId: 'l1',
        landlordName: 'John Smith',
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Property(
        id: '2',
        title: 'Cozy Studio Apartment',
        description: 'Affordable studio apartment perfect for students and young professionals.',
        price: 900,
        area: 550,
        bedrooms: 0,
        bathrooms: 1,
        location: 'Midtown, Residential Area',
        latitude: 40.7614,
        longitude: -73.9776,
        imageUrls: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500'],
        amenities: ['WiFi', 'Laundry', 'Heating'],
        propertyType: 'studio',
        landlordId: 'l2',
        landlordName: 'Sarah Johnson',
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Property(
        id: '3',
        title: '3-Bedroom Family Home',
        description: 'Spacious family home with backyard, perfect for families.',
        price: 2500,
        area: 1800,
        bedrooms: 3,
        bathrooms: 2,
        location: 'Suburban Area',
        latitude: 40.7282,
        longitude: -73.7949,
        imageUrls: ['https://images.unsplash.com/photo-1570129477492-45a003537e1f?w=500'],
        amenities: ['Garden', 'Yard', 'Garage', 'Heating', 'AC'],
        propertyType: 'house',
        landlordId: 'l3',
        landlordName: 'Mike Davis',
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Property(
        id: '4',
        title: 'Luxury Penthouse',
        description: 'Premium penthouse with panoramic city views and modern amenities.',
        price: 3500,
        area: 2200,
        bedrooms: 3,
        bathrooms: 3,
        location: 'City Center, Premium District',
        latitude: 40.7505,
        longitude: -73.9972,
        imageUrls: ['https://images.unsplash.com/photo-1512917774080-9b274b3e3be7?w=500'],
        amenities: ['Pool', 'Gym', 'Concierge', 'WiFi', 'Cable TV'],
        propertyType: 'penthouse',
        landlordId: 'l4',
        landlordName: 'Emily Wilson',
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Property(
        id: '5',
        title: 'Affordable 1-Bedroom Apartment',
        description: 'Great value 1-bedroom apartment in a safe neighborhood.',
        price: 1200,
        area: 750,
        bedrooms: 1,
        bathrooms: 1,
        location: 'Residential Neighborhood',
        latitude: 40.6892,
        longitude: -74.0445,
        imageUrls: ['https://images.unsplash.com/photo-1516996122274-23ee221c5d4d?w=500'],
        amenities: ['WiFi', 'Security', 'Parking'],
        propertyType: 'apartment',
        landlordId: 'l5',
        landlordName: 'Robert Brown',
        isAvailable: true,
        createdAt: DateTime.now(),
      ),
    ];
    notifyListeners();
  }

  // Fetch properties
  Future<void> fetchProperties() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch properties: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search properties
  void searchProperties(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter by price range
  void filterByPrice(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  // Apply all filters
  void _applyFilters() {
    _filteredProperties = _properties.where((property) {
      final matchesQuery = _searchQuery.isEmpty ||
          property.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          property.location.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesPrice = property.price >= _minPrice && property.price <= _maxPrice;

      return matchesQuery && matchesPrice;
    }).toList();

    notifyListeners();
  }

  // Reset filters
  void resetFilters() {
    _searchQuery = '';
    _minPrice = 0;
    _maxPrice = 10000;
    _filteredProperties = [];
    notifyListeners();
  }

  // Get single property by ID
  Property? getPropertyById(String id) {
    try {
      return _properties.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
