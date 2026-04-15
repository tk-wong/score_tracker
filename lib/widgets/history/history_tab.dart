import 'package:flutter/material.dart';
import 'package:score_app/widgets/history/history_title.dart';
import 'package:score_app/widgets/history/history_list.dart';
import '../../models/score_history_entry.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key, required this.history});

  final List<ScoreHistoryEntry> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(child: Text('No score changes yet.'));
    }

    return Column(
      children: [
        HistoryTitle(),
        Expanded(child: HistoryList(history: history)),
      ],
    );
  }
}
