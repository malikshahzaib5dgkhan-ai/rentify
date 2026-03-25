class AppConstants {
  // App info
  static const String appName = 'Rentify';
  static const String appVersion = '1.0.0';

  // API endpoints (placeholder for now)
  static const String baseUrl = 'https://api.rentify.com';
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String signupEndpoint = '$baseUrl/auth/signup';
  static const String propertiesEndpoint = '$baseUrl/properties';

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Splash screen
  static const Duration splashDuration = Duration(seconds: 3);

  // Pagination
  static const int pageSize = 20;

  // Form validation
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^[0-9]{10,15}$';

  // User roles
  static const String roleRenter = 'renter';
  static const String roleLandlord = 'landlord';
}
