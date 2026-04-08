import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/score_history_entry.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key, required this.history});

  final Queue<ScoreHistoryEntry> history;

  String _formatDate(DateTime dateTime) {
    final String twoDigitHour = dateTime.hour.toString().padLeft(2, '0');
    final String twoDigitMinute = dateTime.minute.toString().padLeft(2, '0');
    final String twoDigitDay = dateTime.day.toString().padLeft(2, '0');
    final String twoDigitMonth = dateTime.month.toString().padLeft(2, '0');
    return '$twoDigitDay/$twoDigitMonth/${dateTime.year} '
        '$twoDigitHour:$twoDigitMinute';
  }

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(child: Text('No score changes yet.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final ScoreHistoryEntry entry = history.elementAt(index);
        final bool isPositive = entry.delta > 0;
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          leading: Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPositive ? Colors.green : Colors.red,
          ),
          title: Text(
            '${entry.userName} ${isPositive ? '+' : ''}${entry.delta}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${entry.reason}\n${_formatDate(entry.timestamp)}'),
          isThreeLine: true,
        );
      },
    );
  }
}
