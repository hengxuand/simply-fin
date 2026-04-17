import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/home_widgets.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key,
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
              // const SizedBox(width: 20),
              // Expanded(
              //   flex: 4,
              //   child: _QuickActionsPanel(
              //     onNavigateToTab: onNavigateToTab,
              //     onShowMessage: onShowMessage,
              //   ),
              // ),
            ],
          )
        else ...[
          _HeroSection(displayName: displayName),
        //   const SizedBox(height: 16),
        //   _QuickActionsPanel(
        //     onNavigateToTab: onNavigateToTab,
        //     onShowMessage: onShowMessage,
        //   ),
        ],
        const SizedBox(height: 20),
        _SummaryCards(isWide: isWide),
        // const SizedBox(height: 20),
        // if (isWide)
        //   const Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Expanded(child: _PreviewCard()),
        //       SizedBox(width: 20),
        //       Expanded(child: _MomentumCard()),
        //     ],
        //   )
        // else
        //   const Column(
        //     children: [_PreviewCard(), SizedBox(height: 20), _MomentumCard()],
        //   ),
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
          colors: [AppColors.heroStart, AppColors.heroMid, AppColors.heroEnd],
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
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
