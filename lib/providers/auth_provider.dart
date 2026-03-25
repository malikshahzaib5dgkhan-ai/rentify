import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  // State variables
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String? get userRole => _currentUser?.role;

  // Login method (mock)
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (!email.contains('@')) {
        _errorMessage = 'Invalid email format';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Mock user data
      _currentUser = User(
        id: '1',
        name: email.split('@')[0],
        email: email,
        phone: '+1234567890',
        role: 'renter',
        isVerified: true,
        createdAt: DateTime.now(),
      );

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  // Signup method (mock)
  Future<bool> signup(
    String name,
    String email,
    String phone,
    String password,
    String role,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (!email.contains('@')) {
        _errorMessage = 'Invalid email format';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Mock user creation
      _currentUser = User(
        id: DateTime.now().millisecond.toString(),
        name: name,
        email: email,
        phone: phone,
        role: role,
        isVerified: false,
        createdAt: DateTime.now(),
      );

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Signup failed: ${e.toString()}';
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
