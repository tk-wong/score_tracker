import 'package:flutter/material.dart';

class ScoreboardTitle extends StatefulWidget {
  const ScoreboardTitle({
    super.key,
    required this.onAddUser,
    required this.onResetScore,
  });

  final VoidCallback onAddUser;
  final VoidCallback onResetScore;

  @override
  State<ScoreboardTitle> createState() => _ScoreboardTitleState();
}

class _ScoreboardTitleState extends State<ScoreboardTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const double compactHeaderBreakpoint = 420;
          final bool isCompact = constraints.maxWidth < compactHeaderBreakpoint;
          return Row(
            children: <Widget>[
              Text('Users', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              if (isCompact) ...<Widget>[
                IconButton.filledTonal(
                  tooltip: 'Reset scores',
                  onPressed: widget.onResetScore,
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Add user',
                  onPressed: widget.onAddUser,
                  icon: const Icon(Icons.person_add),
                ),
              ] else ...<Widget>[
                FilledButton.icon(
                  onPressed: widget.onResetScore,
                  label: const Text('Reset scores'),
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: widget.onAddUser,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add user'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
