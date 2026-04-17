import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';
import '../models/home_models.dart';
import 'activity_tab.dart';
import 'insights_tab.dart';
import 'overview_tab.dart';
import 'recurring_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final user = Supabase.instance.client.auth.currentUser;
    final activeTab = homeTabs[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.dashboardBackground,
      bottomNavigationBar: _buildBottomNav(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.dashboardBackgroundTop,
              AppColors.dashboardBackground,
              AppColors.dashboardBackgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1100;
              final padding = isWide ? 40.0 : 20.0;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(padding, 12, padding, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TopBar(
                            controller: controller,
                            email: user?.email ?? '',
                            activeTab: activeTab,
                          ),
                          const SizedBox(height: 20),
                          _HomeTabContent(
                            currentIndex: _currentIndex,
                            isWide: isWide,
                            displayName: _displayNameFromEmail(user?.email),
                            onNavigateToTab: _switchTab,
                            onShowMessage: (message) =>
                                _showMockMessage(context, message),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      height: 76,
      backgroundColor: Colors.white.withAlpha(245),
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.navIndicator,
      selectedIndex: _currentIndex,
      onDestinationSelected: _switchTab,
      destinations: [
        for (final tab in homeTabs)
          NavigationDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.selectedIcon),
            label: tab.label,
          ),
      ],
    );
  }

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showMockMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _displayNameFromEmail(String? email) {
    if (email == null || email.isEmpty) return 'there';

    final local = email.split('@').first.trim();
    if (local.isEmpty) return 'there';

    return local
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.length > 1 ? part.substring(1) : ''}',
        )
        .join(' ');
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.controller,
    required this.email,
    required this.activeTab,
  });

  final AuthController controller;
  final String email;
  final HomeTabItem activeTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(220),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            activeTab.icon,
            color: AppColors.dashboardPrimary,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activeTab.label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${activeTab.subtitle}  •  $email',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => OutlinedButton.icon(
            onPressed: controller.isLoading.value ? null : controller.signOut,
            icon: controller.isLoading.value
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.dashboardPrimary,
                    ),
                  )
                : const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.dashboardPrimary,
              side: const BorderSide(color: AppColors.outlineSoft),
              backgroundColor: Colors.white.withAlpha(190),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  const _HomeTabContent({
    required this.currentIndex,
    required this.isWide,
    required this.displayName,
    required this.onNavigateToTab,
    required this.onShowMessage,
  });

  final int currentIndex;
  final bool isWide;
  final String displayName;
  final ValueChanged<int> onNavigateToTab;
  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    switch (currentIndex) {
      case 0:
        return OverviewTab(
          isWide: isWide,
          displayName: displayName,
          onNavigateToTab: onNavigateToTab,
          onShowMessage: onShowMessage,
        );
      case 1:
        return InsightsTab(isWide: isWide, onShowMessage: onShowMessage);
      case 2:
        return ActivityTab(isWide: isWide, onShowMessage: onShowMessage);
      case 3:
        return RecurringTab(isWide: isWide, onShowMessage: onShowMessage);
      default:
        return const SizedBox.shrink();
    }
  }
}
