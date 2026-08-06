// lib/ui/journeys/widgets/journey_card.dart

import 'package:flutter/cupertino.dart';
import 'package:path_snap/domain/models/journey.dart';

class JourneyCard extends StatelessWidget {
  final Journey journey;

  const JourneyCard({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    final isCompleted = journey.endDate != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey5.resolveFrom(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Status
          Row(
            children: [
              Expanded(
                child: Text(
                  journey.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? CupertinoColors.systemGrey5
                      : CupertinoColors.activeGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCompleted ? 'Completed' : 'Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isCompleted
                        ? CupertinoColors.systemGrey
                        : CupertinoColors.activeGreen,
                  ),
                ),
              ),
            ],
          ),

          if (journey.description != null) ...[
            const SizedBox(height: 6),
            Text(
              journey.description!,
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey.resolveFrom(context),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 10),

          // Date
          Row(
            children: [
              Icon(
                CupertinoIcons.calendar,
                size: 14,
                color: CupertinoColors.systemGrey.resolveFrom(context),
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(journey.startDate),
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey.resolveFrom(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
