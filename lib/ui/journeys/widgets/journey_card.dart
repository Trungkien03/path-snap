// lib/ui/journeys/widgets/journey_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_snap/domain/models/journey.dart';

class JourneyCard extends StatelessWidget {
  final Journey journey;

  const JourneyCard({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.image),
        title: Text(journey.title),
        subtitle: Text(journey.startDate.toString()),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // context.push('/journey/${journey.id}');
        },
      ),
    );
  }
}
