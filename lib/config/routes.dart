import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/property_details_screen.dart';
import '../screens/logout_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final path = state.uri.path;
    final isAuth = context.read<AuthProvider>().isAuthenticated;

    // Public routes that don't require authentication
    if (path == '/' || path == '/onboarding' || path == '/login' || path == '/signup') {
      return null;
    }

    // If trying to access protected routes without auth, redirect to login
    if (!isAuth && (path.startsWith('/home') || path.startsWith('/search') || 
        path.startsWith('/dashboard') || path.startsWith('/profile') || 
        path.startsWith('/property'))) {
      return '/';
    }

    return null;
  },
  routes: [
    // Splash screen
    GoRoute(
      path: '/',
      name: 'splash',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SplashScreen(),
      ),
    ),

    // Onboarding
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const OnboardingScreen(),
      ),
    ),

    // Login
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const LoginScreen(),
      ),
    ),

    // Signup
    GoRoute(
      path: '/signup',
      name: 'signup',
      pageBuilder: (context, state) {
        final role = state.uri.queryParameters['role'] ?? 'renter';
        return MaterialPage(
          key: state.pageKey,
          child: SignupScreen(role: role),
        );
      },
    ),

    // Home
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const HomeScreen(),
      ),
    ),

    // Search
    GoRoute(
      path: '/search',
      name: 'search',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SearchScreen(),
      ),
    ),

    // Dashboard
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const DashboardScreen(),
      ),
    ),

    // Profile
    GoRoute(
      path: '/profile',
      name: 'profile',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ProfileScreen(),
      ),
    ),

    // Property Details
    GoRoute(
      path: '/property/:id',
      name: 'property-details',
      pageBuilder: (context, state) {
        final propertyId = state.pathParameters['id'] ?? '';
        return MaterialPage(
          key: state.pageKey,
          child: PropertyDetailsScreen(propertyId: propertyId),
        );
      },
    ),

    // Logout
    GoRoute(
      path: '/logout',
      name: 'logout',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const LogoutScreen(),
      ),
    ),
  ],

  // Error route
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  ),
);
