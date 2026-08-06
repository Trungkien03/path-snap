import 'package:flutter/material.dart';
import 'package:path_snap/domain/models/journey.dart';
import 'package:path_snap/ui/journeys/widgets/journey_card.dart';

class JourneyList extends StatelessWidget {
  final List<Journey> journeys;

  const JourneyList({Key? key, required this.journeys}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: journeys.length,
      itemBuilder: (context, index) {
        return JourneyCard(journey: journeys[index]);
      },
    );
  }
}
