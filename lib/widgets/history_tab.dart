import 'package:flutter/material.dart';

import '../models/score_history_entry.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key, required this.history});

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
    if (history.isEmpty) {
      return const Center(child: Text('No score changes yet.'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              const double compactHeaderBreakpoint = 420;
              final bool isCompact =
                  constraints.maxWidth < compactHeaderBreakpoint;
              return Row(
                children: <Widget>[
                  Text(
                    'Score History',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  if (isCompact) ...<Widget>[
                    IconButton.filledTonal(
                      tooltip: 'Clear history',
                      onPressed: null,
                      icon: const Icon(Icons.cleaning_services),
                    ),
                  ] else ...<Widget>[
                    FilledButton.icon(
                      onPressed: null,
                      label: const Text('Clear history'),
                      icon: const Icon(Icons.cleaning_services),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        Expanded(
          child: ListView.separated(
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
                tileColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                leading: Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                title: Text(
                  '${entry.userName} ${isPositive ? '+' : ''}${entry.delta}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${entry.reason}\n${_formatDate(entry.timestamp)}',
                ),
                isThreeLine: true,
              );
            },
          ),
        ),
      ],
    );
  }
}
