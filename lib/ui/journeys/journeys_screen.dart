// lib/ui/journeys/journeys_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:path_snap/ui/journeys/journeys_view_model.dart';
import 'package:path_snap/ui/journeys/widgets/empty_journeys.dart';
import 'package:path_snap/ui/journeys/widgets/journey_list.dart';

class JourneysScreen extends StatefulWidget {
  const JourneysScreen({super.key});

  @override
  State<JourneysScreen> createState() => _JourneysScreenState();
}

class _JourneysScreenState extends State<JourneysScreen> {
  late final JourneysViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = JourneysViewModel();
    _viewModel.loadJourneys();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('My Journeys'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            // TODO: tạo chuyến đi mới
          },
        ),
      ),
      child: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            if (_viewModel.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (_viewModel.error != null) {
              return Center(
                child: Text(
                  'Lỗi: ${_viewModel.error}',
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              );
            }

            if (_viewModel.isEmpty) {
              return const EmptyJourneys();
            }

            return JourneyList(journeys: _viewModel.journeys);
          },
        ),
      ),
    );
  }
}
