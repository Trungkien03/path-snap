// lib/ui/journeys/journeys_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:path_snap/ui/components/app_loading.dart';
import 'package:path_snap/ui/journeys/journeys_view_model.dart';
import 'package:path_snap/ui/journeys/widgets/empty_journeys.dart';
import 'package:path_snap/ui/journeys/widgets/journey_card.dart';

class JourneysScreen extends StatefulWidget {
  final ScrollController? scrollController;

  const JourneysScreen({super.key, this.scrollController});

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
    return Container(
      color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(children: [_buildDragHandle(), _buildHeader()]),
          ),

          // Nội dung chính: Danh sách / Loading / Empty
          _buildSliverContent(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      width: 36,
      height: 5,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Journeys',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverContent() {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const SliverFillRemaining(
            child: AppLoading(message: 'Đang tải...'),
          );
        }

        if (_viewModel.journeys.isEmpty) {
          return const SliverFillRemaining(child: EmptyJourneys());
        }

        // Dùng SliverList để cuộn liền mạch với Sheet
        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final journey = _viewModel.journeys[index];
              return JourneyCard(journey: journey);
            }, childCount: _viewModel.journeys.length),
          ),
        );
      },
    );
  }
}
