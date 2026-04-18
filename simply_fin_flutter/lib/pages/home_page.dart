import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';
import '../models/home_models.dart';
import '../services/statement_upload_service.dart';
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
  late final _uploadService = Get.find<StatementUploadService>();
  bool _isUploading = false;

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
    // Split tabs: first half | plus button | second half
    final half = homeTabs.length ~/ 2;
    final leftTabs = homeTabs.sublist(0, half);
    final rightTabs = homeTabs.sublist(half);

    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background bar
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(245),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),
          // Left nav items
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: MediaQuery.of(context).size.width / 2,
            child: Row(
              children: [
                for (int i = 0; i < leftTabs.length; i++)
                  Expanded(
                    child: _NavItem(
                      tab: leftTabs[i],
                      selected: _currentIndex == i,
                      onTap: () => _switchTab(i),
                    ),
                  ),
              ],
            ),
          ),
          // Right nav items
          Positioned(
            left: MediaQuery.of(context).size.width / 2,
            top: 0,
            bottom: 0,
            right: 0,
            child: Row(
              children: [
                for (int i = 0; i < rightTabs.length; i++)
                  Expanded(
                    child: _NavItem(
                      tab: rightTabs[i],
                      selected: _currentIndex == half + i,
                      onTap: () => _switchTab(half + i),
                    ),
                  ),
              ],
            ),
          ),
          // Center plus button
          Positioned(
            top: -22,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _isUploading ? null : _handleUpload,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.dashboardPrimary,
                        Color(0xFF6366F1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dashboardPrimary.withAlpha(100),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _isUploading
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleUpload() async {
    setState(() => _isUploading = true);
    try {
      final res = await _uploadService.pickAndUpload();
      if (!mounted) return;
      switch (res.result) {
        case UploadResult.success:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ?? 'Uploaded!'),
              backgroundColor: Colors.green,
            ),
          );
        case UploadResult.duplicate:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ?? 'Duplicate statement.'),
              backgroundColor: Colors.orange,
            ),
          );
        case UploadResult.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ?? 'Upload failed.'),
              backgroundColor: Colors.red,
            ),
          );
        case UploadResult.cancelled:
          break;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final HomeTabItem tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: selected ? AppColors.navIndicator : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              selected ? tab.selectedIcon : tab.icon,
              color: selected ? AppColors.dashboardPrimary : Colors.grey,
              size: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            tab.label,
            style: TextStyle(
              fontSize: 11,
              color: selected ? AppColors.dashboardPrimary : Colors.grey,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

