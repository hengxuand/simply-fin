import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/home_models.dart';
import '../widgets/home_widgets.dart';

class ActivityTab extends StatelessWidget {
  const ActivityTab({
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
              Icon(
                Icons.cloud_upload_rounded,
                color: AppColors.dashboardPrimary,
              ),
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
                  color: AppColors.iconAccent,
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
