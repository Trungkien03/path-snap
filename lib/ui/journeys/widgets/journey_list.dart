// lib/ui/journeys/widgets/journey_list.dart

import 'package:flutter/cupertino.dart';
import 'package:path_snap/domain/models/journey.dart';
import 'package:path_snap/ui/journeys/widgets/journey_card.dart';

class JourneyList extends StatelessWidget {
  final List<Journey> journeys;

  const JourneyList({super.key, required this.journeys});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: journeys.length,
      itemBuilder: (context, index) {
        return JourneyCard(journey: journeys[index]);
      },
    );
  }
}
