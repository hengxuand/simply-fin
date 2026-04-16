import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';
import 'home/home_models.dart';
import 'home/home_widgets.dart';

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
                            onShowMessage: (message) => _showMockMessage(
                              context,
                              message,
                            ),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
        return _OverviewTab(
          isWide: isWide,
          displayName: displayName,
          onNavigateToTab: onNavigateToTab,
          onShowMessage: onShowMessage,
        );
      case 1:
        return _InsightsTab(
          isWide: isWide,
          onShowMessage: onShowMessage,
        );
      case 2:
        return _ActivityTab(
          isWide: isWide,
          onShowMessage: onShowMessage,
        );
      case 3:
        return _RecurringTab(
          isWide: isWide,
          onShowMessage: onShowMessage,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.isWide,
    required this.displayName,
    required this.onNavigateToTab,
    required this.onShowMessage,
  });

  final bool isWide;
  final String displayName;
  final ValueChanged<int> onNavigateToTab;
  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _HeroSection(displayName: displayName)),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: _QuickActionsPanel(
                  onNavigateToTab: onNavigateToTab,
                  onShowMessage: onShowMessage,
                ),
              ),
            ],
          )
        else ...[
          _HeroSection(displayName: displayName),
          const SizedBox(height: 16),
          _QuickActionsPanel(
            onNavigateToTab: onNavigateToTab,
            onShowMessage: onShowMessage,
          ),
        ],
        const SizedBox(height: 20),
        _SummaryCards(isWide: isWide),
        const SizedBox(height: 20),
        if (isWide)
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PreviewCard()),
              SizedBox(width: 20),
              Expanded(child: _MomentumCard()),
            ],
          )
        else
          const Column(
            children: [
              _PreviewCard(),
              SizedBox(height: 20),
              _MomentumCard(),
            ],
          ),
      ],
    );
  }
}

class _InsightsTab extends StatelessWidget {
  const _InsightsTab({
    required this.isWide,
    required this.onShowMessage,
  });

  final bool isWide;
  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: _InsightFeed(onShowMessage: onShowMessage),
          ),
          const SizedBox(width: 20),
          const Expanded(flex: 5, child: _SpendingBreakdown()),
        ],
      );
    }

    return Column(
      children: [
        _InsightFeed(onShowMessage: onShowMessage),
        const SizedBox(height: 20),
        const _SpendingBreakdown(),
      ],
    );
  }
}

class _ActivityTab extends StatelessWidget {
  const _ActivityTab({
    required this.isWide,
    required this.onShowMessage,
  });

  final bool isWide;
  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: _StatementTimeline()),
          const SizedBox(width: 20),
          Expanded(child: _UploadPanel(onShowMessage: onShowMessage)),
        ],
      );
    }

    return Column(
      children: [
        const _StatementTimeline(),
        const SizedBox(height: 20),
        _UploadPanel(onShowMessage: onShowMessage),
      ],
    );
  }
}

class _RecurringTab extends StatelessWidget {
  const _RecurringTab({
    required this.isWide,
    required this.onShowMessage,
  });

  final bool isWide;
  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: _RecurringChargesPanel()),
          const SizedBox(width: 20),
          Expanded(
            child: _SubscriptionOpportunities(onShowMessage: onShowMessage),
          ),
        ],
      );
    }

    return Column(
      children: [
        const _RecurringChargesPanel(),
        const SizedBox(height: 20),
        _SubscriptionOpportunities(onShowMessage: onShowMessage),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.heroStart,
            AppColors.dashboardPrimary,
            AppColors.heroEnd,
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F315EFB),
            blurRadius: 28,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Mock insights preview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Hi $displayName, your money story is taking shape.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 31,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Upload card statements and surface trends, unusual spikes, recurring charges, and cash flow pressure points without overloading the first screen.',
            style: TextStyle(
              color: AppColors.heroTextMuted,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 26),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              HeroStatChip(
                icon: Icons.file_present_rounded,
                label: 'Statements analyzed',
                value: '12',
              ),
              HeroStatChip(
                icon: Icons.auto_graph_rounded,
                label: 'Spending trend',
                value: '-8.4%',
              ),
              HeroStatChip(
                icon: Icons.local_fire_department_rounded,
                label: 'Top risk',
                value: 'Dining out',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel({
    required this.onNavigateToTab,
    required this.onShowMessage,
  });

  final ValueChanged<int> onNavigateToTab;
  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start here',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep the home tab focused on the headline picture. Use the tabs below to dive into details.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          QuickActionTile(
            icon: Icons.cloud_upload_rounded,
            title: 'Upload statement',
            subtitle: 'Add a credit card PDF or photo',
            color: AppColors.dashboardPrimary,
            onTap: () => onShowMessage(
              'Upload flow is mocked for now. The Activity tab is ready for real wiring next.',
            ),
          ),
          const SizedBox(height: 12),
          QuickActionTile(
            icon: Icons.auto_awesome_rounded,
            title: 'Review insights',
            subtitle: 'See trends and unusual spending',
            color: AppColors.teal,
            onTap: () => onNavigateToTab(1),
          ),
          const SizedBox(height: 12),
          QuickActionTile(
            icon: Icons.repeat_rounded,
            title: 'Check subscriptions',
            subtitle: 'Track recurring charges and leaks',
            color: AppColors.amber,
            onTap: () => onNavigateToTab(3),
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final cards = [
      const MetricCard(
        title: 'Monthly spend',
        value: '\$4,820',
        change: '-8.4% vs last month',
        color: AppColors.dashboardPrimary,
        icon: Icons.account_balance_wallet_rounded,
      ),
      const MetricCard(
        title: 'Essentials ratio',
        value: '61%',
        change: 'Healthy range',
        color: AppColors.teal,
        icon: Icons.savings_rounded,
      ),
      const MetricCard(
        title: 'Subscriptions',
        value: '\$146',
        change: '+2 new services',
        color: AppColors.amber,
        icon: Icons.autorenew_rounded,
      ),
      const MetricCard(
        title: 'Spending alerts',
        value: '4',
        change: '2 high priority',
        color: AppColors.rose,
        icon: Icons.notification_important_rounded,
      ),
    ];

    if (isWide) {
      return Row(
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 16),
          Expanded(child: cards[1]),
          const SizedBox(width: 16),
          Expanded(child: cards[2]),
          const SizedBox(width: 16),
          Expanded(child: cards[3]),
        ],
      );
    }

    return Column(
      children: [
        cards[0],
        const SizedBox(height: 14),
        cards[1],
        const SizedBox(height: 14),
        cards[2],
        const SizedBox(height: 14),
        cards[3],
      ],
    );
  }
}

class _InsightFeed extends StatelessWidget {
  const _InsightFeed({required this.onShowMessage});

  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'AI insights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => onShowMessage(
                  'Insight drill-down is part of the next step.',
                ),
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'This section is designed to become the intelligence layer once statement parsing is connected.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < insightItems.length; i++) ...[
            InsightCard(item: insightItems[i]),
            if (i != insightItems.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _SpendingBreakdown extends StatelessWidget {
  const _SpendingBreakdown();

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spending mix',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'A category-first view built for transaction clustering and budget coaching.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          const SpendRing(),
          const SizedBox(height: 20),
          for (final item in categorySpendItems) CategorySpendTile(item: item),
        ],
      ),
    );
  }
}

class _StatementTimeline extends StatelessWidget {
  const _StatementTimeline();

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analysis pipeline',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This mock timeline previews the post-upload experience and gives the dashboard a strong product direction.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          for (final item in timelineItems) TimelineTile(item: item),
        ],
      ),
    );
  }
}

class _UploadPanel extends StatelessWidget {
  const _UploadPanel({required this.onShowMessage});

  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.cloud_upload_rounded, color: AppColors.dashboardPrimary),
              SizedBox(width: 10),
              Text(
                'Statement inbox',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'This tab is where upload progress, parsing status, and statement history can live once the backend is ready.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardTint,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.cardTintBorder, width: 1.4),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.description_rounded,
                  size: 42,
                  color: Color(0xFF5B7BFF),
                ),
                SizedBox(height: 12),
                Text(
                  'April statement.pdf',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'OCR parsed 248 transactions in 19 seconds',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => onShowMessage(
              'Upload flow is mocked for now. This screen is ready for real data wiring next.',
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Upload statement'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.dashboardPrimary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const MiniStatusRow(
            label: 'Needs review',
            value: '3 merchants',
            color: AppColors.amber,
          ),
          const SizedBox(height: 8),
          const MiniStatusRow(
            label: 'Recurring charges found',
            value: '7 active',
            color: AppColors.teal,
          ),
        ],
      ),
    );
  }
}

class _RecurringChargesPanel extends StatelessWidget {
  const _RecurringChargesPanel();

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Recurring charges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '\$145.47 / mo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dashboardPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'A useful anchor for future cancellation suggestions and cash flow forecasting.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          for (final charge in recurringCharges) ...[
            RecurringChargeTile(charge: charge),
            if (charge != recurringCharges.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard();

  @override
  Widget build(BuildContext context) {
    return const DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What this home tab should answer',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'The first screen now focuses on three quick questions: how am I doing overall, what needs attention, and where do I go next.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 18),
          MiniStatusRow(
            label: 'Biggest savings opportunity',
            value: '\$180 dining',
            color: AppColors.rose,
          ),
          SizedBox(height: 12),
          MiniStatusRow(
            label: 'Latest statement processed',
            value: 'Apr 2026',
            color: AppColors.dashboardPrimary,
          ),
          SizedBox(height: 12),
          MiniStatusRow(
            label: 'Recurring cost pressure',
            value: 'Moderate',
            color: AppColors.amber,
          ),
        ],
      ),
    );
  }
}

class _MomentumCard extends StatelessWidget {
  const _MomentumCard();

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Momentum',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'A compact trend snapshot keeps the overview useful without making it feel like four pages stacked into one.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.momentumStart, AppColors.momentumEnd],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MiniBar(height: 54, color: AppColors.amber, label: 'Jan'),
                  SizedBox(width: 14),
                  MiniBar(height: 82, color: AppColors.rose, label: 'Feb'),
                  SizedBox(width: 14),
                  MiniBar(
                    height: 114,
                    color: AppColors.dashboardPrimary,
                    label: 'Mar',
                  ),
                  SizedBox(width: 14),
                  MiniBar(height: 96, color: AppColors.teal, label: 'Apr'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionOpportunities extends StatelessWidget {
  const _SubscriptionOpportunities({required this.onShowMessage});

  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subscription opportunities',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This tab can evolve into cancellation suggestions, duplicate service detection, and monthly savings recommendations.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 18),
          const OpportunityTile(
            title: 'Two streaming services overlap',
            subtitle: 'Potential savings of \$15.49 if one goes unused',
            color: AppColors.teal,
          ),
          const SizedBox(height: 12),
          const OpportunityTile(
            title: 'Adobe plan is your largest recurring tool cost',
            subtitle: 'Watch for infrequent use before the next renewal',
            color: AppColors.amber,
          ),
          const SizedBox(height: 12),
          const OpportunityTile(
            title: 'Gym spend is steady for 6 months',
            subtitle: 'Keep if active, otherwise it is a strong savings candidate',
            color: AppColors.rose,
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () => onShowMessage(
              'Cancellation workflows are not wired yet, but this tab is ready for that product direction.',
            ),
            icon: const Icon(Icons.tips_and_updates_outlined),
            label: const Text('Explore recommendations'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.dashboardPrimary,
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: AppColors.outlineSoftAlt),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
