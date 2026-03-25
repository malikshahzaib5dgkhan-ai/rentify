import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 900;
    final authProvider = context.watch<AuthProvider>();
    final isRenter = authProvider.userRole == 'renter';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : (isTablet ? 24 : 40),
          vertical: 12,
        ),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: () => context.go('/home'),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Text(
                        'R',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Desktop menu
            if (!isMobile) ...[
              NavButton(
                label: 'Home',
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(width: 20),
              NavButton(
                label: 'Search',
                onPressed: () => context.go('/search'),
              ),
              const SizedBox(width: 20),
              if (isRenter)
                NavButton(
                  label: 'Dashboard',
                  onPressed: () => context.go('/dashboard'),
                )
              else
                NavButton(
                  label: 'My Properties',
                  onPressed: () => context.go('/dashboard'),
                ),
              const SizedBox(width: 20),
              NavButton(
                label: 'Profile',
                onPressed: () => context.go('/profile'),
              ),
              const SizedBox(width: 20),
              NavButton(
                label: 'Logout',
                onPressed: () {
                  authProvider.logout();
                  context.go('/');
                },
              ),
            ],

            // Mobile menu button
            if (isMobile)
              IconButton(
                icon: const Icon(Icons.menu),
                color: AppColors.textPrimary,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class NavButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const NavButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _isHovered ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _isHovered ? AppColors.primary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Mobile menu drawer
class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isRenter = authProvider.userRole == 'renter';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Text(
                      authProvider.currentUser?.name[0].toUpperCase() ?? 'R',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  authProvider.currentUser?.name ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  authProvider.currentUser?.email ?? 'email@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.go('/home');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search Properties'),
            onTap: () {
              context.go('/search');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(isRenter ? 'Dashboard' : 'My Properties'),
            onTap: () {
              context.go('/dashboard');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              context.go('/profile');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              authProvider.logout();
              context.go('/');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
