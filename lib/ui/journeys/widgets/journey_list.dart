import 'package:flutter/cupertino.dart';
import 'package:path_snap/domain/models/journey.dart';
import 'package:path_snap/ui/journeys/widgets/journey_card.dart';

class JourneyList extends StatelessWidget {
  final List<Journey> journeys;
  final ScrollController? scrollController;

  const JourneyList({super.key, required this.journeys, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: journeys.length,
      itemBuilder: (context, index) {
        return JourneyCard(journey: journeys[index]);
      },
    );
  }
}
