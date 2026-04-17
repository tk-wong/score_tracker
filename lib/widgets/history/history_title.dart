import 'package:flutter/material.dart';

class HistoryTitle extends StatelessWidget {
  const HistoryTitle({super.key, required this.onClearHistory});
  final VoidCallback onClearHistory;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const double compactHeaderBreakpoint = 420;
          final bool isCompact = constraints.maxWidth < compactHeaderBreakpoint;
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
                  onPressed: onClearHistory,
                  icon: const Icon(Icons.cleaning_services),
                ),
              ] else ...<Widget>[
                FilledButton.icon(
                  onPressed: onClearHistory,
                  label: const Text('Clear history'),
                  icon: const Icon(Icons.cleaning_services),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
