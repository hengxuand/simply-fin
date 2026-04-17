import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/home_models.dart';
import '../widgets/home_widgets.dart';

class RecurringTab extends StatelessWidget {
  const RecurringTab({
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
            subtitle:
                'Keep if active, otherwise it is a strong savings candidate',
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
