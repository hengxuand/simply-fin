import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/home_models.dart';
import '../widgets/home_widgets.dart';

class InsightsTab extends StatelessWidget {
  const InsightsTab({
    super.key,
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
          Expanded(flex: 6, child: _InsightFeed(onShowMessage: onShowMessage)),
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
