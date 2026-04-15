import 'package:flutter/material.dart';
import 'package:score_app/models/score_history_entry.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key, required this.history});

  final List<ScoreHistoryEntry> history;
  String _formatDate(DateTime dateTime) {
    DateTime localDateTime = dateTime.toLocal();
    final String twoDigitHour = localDateTime.hour.toString().padLeft(2, '0');
    final String twoDigitMinute = localDateTime.minute.toString().padLeft(
      2,
      '0',
    );
    final String twoDigitDay = localDateTime.day.toString().padLeft(2, '0');
    final String twoDigitMonth = localDateTime.month.toString().padLeft(2, '0');
    return '$twoDigitDay/$twoDigitMonth/${localDateTime.year} '
        '$twoDigitHour:$twoDigitMinute';
  }

  @override
  Widget build(BuildContext context) {
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
