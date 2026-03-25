import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isRenter = authProvider.userRole == 'renter';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: const DashboardContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          
          // Navigate based on selected tab
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
              // Dashboard - already here
              break;
            case 3:
              context.go('/profile');
              break;
            case 4:
              authProvider.logout();
              context.go('/splash');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: isRenter ? 'Dashboard' : 'Properties',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final authProvider = context.watch<AuthProvider>();
    final isRenter = authProvider.userRole == 'renter';

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Text(
                        authProvider.currentUser?.name[0].toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isRenter ? '📊 Renter Dashboard' : '🏠 Properties Manager',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          authProvider.currentUser?.name ?? 'User',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            if (isRenter) ...[
              _RenterDashboard(),
            ] else ...[
              _LandlordDashboard(),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _RenterDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Cards with enhanced design
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _ModernStatCard(
              title: 'Searches',
              icon: Icons.search,
              value: '5',
              color: AppColors.primary,
              gradient: [AppColors.primary, AppColors.primaryLight],
            ),
            _ModernStatCard(
              title: 'Favorites',
              icon: Icons.favorite,
              value: '12',
              color: AppColors.error,
              gradient: [AppColors.error, Colors.pink.shade400],
            ),
            _ModernStatCard(
              title: 'Alerts',
              icon: Icons.notifications,
              value: '3',
              color: AppColors.warning,
              gradient: [AppColors.warning, Colors.orange.shade400],
            ),
            _ModernStatCard(
              title: 'Applications',
              icon: Icons.description,
              value: '2',
              color: AppColors.success,
              gradient: [AppColors.success, Colors.teal.shade400],
            ),
          ],
        ),
        const SizedBox(height: 30),

        // Recent Searches Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/search'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _SearchItem(
                query: 'Apartment in Downtown',
                results: '24',
                icon: Icons.apartment,
              ),
              const Divider(height: 1),
              _SearchItem(
                query: '2 Bedroom near Metro',
                results: '18',
                icon: Icons.home,
              ),
              const Divider(height: 1),
              _SearchItem(
                query: 'Budget-friendly Studios',
                results: '31',
                icon: Icons.door_front_door,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Saved Properties Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Saved Properties',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/search'),
              child: const Text('Browse More'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _SavedPropertyItem(
                title: 'Modern Apartment Downtown',
                price: '\$1,500',
              ),
              const Divider(height: 1),
              _SavedPropertyItem(
                title: 'Cozy Studio Apartment',
                price: '\$900',
              ),
              const Divider(height: 1),
              _SavedPropertyItem(
                title: '3-Bedroom Family Home',
                price: '\$2,500',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LandlordDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Cards with enhanced design
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _ModernStatCard(
              title: 'Properties',
              icon: Icons.apartment,
              value: '8',
              color: AppColors.primary,
              gradient: [AppColors.primary, AppColors.primaryLight],
            ),
            _ModernStatCard(
              title: 'Active',
              icon: Icons.check_circle,
              value: '6',
              color: AppColors.success,
              gradient: [AppColors.success, Colors.teal.shade400],
            ),
            _ModernStatCard(
              title: 'Inquiries',
              icon: Icons.mail,
              value: '5',
              color: AppColors.warning,
              gradient: [AppColors.warning, Colors.orange.shade400],
            ),
            _ModernStatCard(
              title: 'Views',
              icon: Icons.visibility,
              value: '324',
              color: AppColors.info,
              gradient: [AppColors.info, Colors.cyan.shade400],
            ),
          ],
        ),
        const SizedBox(height: 30),

        // Quick Actions
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: isMobile ? double.infinity : null,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Post New Property'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Property listing form coming soon')),
              );
            },
          ),
        ),
        const SizedBox(height: 30),

        // Recent Inquiries Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Inquiries',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _InquiryItem(
                name: 'John Doe',
                property: 'Modern Apartment Downtown',
                date: '2 hours ago',
              ),
              const Divider(height: 1),
              _InquiryItem(
                name: 'Sarah Johnson',
                property: 'Cozy Studio Apartment',
                date: '1 day ago',
              ),
              const Divider(height: 1),
              _InquiryItem(
                name: 'Mike Smith',
                property: '3-Bedroom Family Home',
                date: '3 days ago',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModernStatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final Color color;
  final List<Color> gradient;

  const _ModernStatCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchItem extends StatelessWidget {
  final String query;
  final String results;
  final IconData icon;

  const _SearchItem({
    required this.query,
    required this.results,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(query, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text(
                  '$results results found',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, 
            size: 16, 
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _SavedPropertyItem extends StatelessWidget {
  final String title;
  final String price;

  const _SavedPropertyItem({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(
                price,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.favorite, color: AppColors.error),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _InquiryItem extends StatelessWidget {
  final String name;
  final String property;
  final String date;

  const _InquiryItem({
    required this.name,
    required this.property,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            name[0],
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(
                property,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.message, color: AppColors.primary),
      ],
    );
  }
}


