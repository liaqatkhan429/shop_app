import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/viewmodels/sidebar_viewmodel.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget child;
  const MainLayoutScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          _AppSidebar(),
          // Divider line between sidebar and content
          Container(width: 1, color: const Color(0xFF1F2937)),
          // Main Content
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _AppSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.sidebarDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'POS System',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Shop Management System',
                        style: GoogleFonts.poppins(
                          color: AppColors.textDarkSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Nav Items
          Expanded(
            child: FutureBuilder<UserRole>(
              future: context.read<SessionService>().getActiveSession(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final role = snapshot.data!;

                return Consumer<SidebarViewModel>(
                  builder: (context, sidebar, _) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [

                        // ADMIN ONLY
                        if (role == UserRole.admin)
                          _SidebarNavItem(
                            icon: Icons.dashboard_outlined,
                            title: 'Dashboard',
                            index: 0,
                            sidebar: sidebar,
                            routeName: 'dashboard',
                          ),

                        // BOTH ADMIN & USER
                        _SidebarNavItem(
                          icon: Icons.receipt_long_outlined,
                          title: 'Create Invoice',
                          index: 1,
                          sidebar: sidebar,
                          routeName: 'create_invoice',
                        ),

                        _SidebarNavItem(
                          icon: Icons.people_outline,
                          title: 'Customers',
                          index: 2,
                          sidebar: sidebar,
                          routeName: 'clients',
                        ),

                        _SidebarNavItem(
                          icon: Icons.inventory_2_outlined,
                          title: 'Products',
                          index: 3,
                          sidebar: sidebar,
                          routeName: 'items',
                        ),

                        // ADMIN ONLY
                        if (role == UserRole.admin)
                          _SidebarNavItem(
                            icon: Icons.perm_identity_outlined,
                            title: 'Users',
                            index: 4,
                            sidebar: sidebar,
                            routeName: 'users',
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // Bottom section
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            height: 0.5,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                  child: Text(
                    'SYSTEM',
                    style: GoogleFonts.poppins(
                      color: AppColors.textDarkSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _SidebarFooterItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                ),
                _SidebarFooterItem(
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  color: const Color(0xFFF87171),
                  onTap: () async {
                    await Provider.of<AuthService>(context, listen: false).logout();
                    if (context.mounted) context.goNamed('login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final int index;
  final SidebarViewModel sidebar;
  final String? routeName;

  const _SidebarNavItem({
    required this.icon,
    required this.title,
    required this.index,
    required this.sidebar,
    required this.routeName,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.sidebar.selectedIndex == widget.index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          widget.sidebar.setSelectedIndex(widget.index);
          if (widget.routeName != null) context.goNamed(widget.routeName!);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue
                : _hovered
                    ? AppColors.sidebarHover
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: isSelected ? Colors.white : AppColors.textDarkSecondary,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : AppColors.textDarkSecondary,
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarFooterItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const _SidebarFooterItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color = AppColors.textDarkSecondary,
  });

  @override
  State<_SidebarFooterItem> createState() => _SidebarFooterItemState();
}

class _SidebarFooterItemState extends State<_SidebarFooterItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.sidebarHover : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: widget.color, size: 16),
              const SizedBox(width: 12),
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  color: widget.color,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
