import 'package:flutter/material.dart';
import 'package:score_app/models/score_user.dart';

class ScoreboardList extends StatefulWidget {
  const ScoreboardList({
    super.key,
    required this.users,
    required this.onAddScore,
    required this.onSubtractScore,
    required this.onDeleteUser,
  });

  final List<ScoreUser> users;
  final Function(ScoreUser) onAddScore;
  final Function(ScoreUser) onSubtractScore;
  final Function(ScoreUser) onDeleteUser;

  @override
  State<ScoreboardList> createState() => _ScoreboardListState();
}

class _ScoreboardListState extends State<ScoreboardList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.users.length,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final ScoreUser user = widget.users[index];
        final List<Widget> userDisplayList = <Widget>[
          CircleAvatar(child: Text(user.name.characters.first)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.name, style: Theme.of(context).textTheme.titleMedium),
                Text('Score: ${user.score}'),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Subtract score',
            onPressed: () => widget.onSubtractScore(user),
            icon: const Icon(Icons.remove),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: 'Add score',
            onPressed: () => widget.onAddScore(user),
            icon: const Icon(Icons.add),
          ),
        ];
        return Dismissible(
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Delete',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          direction: DismissDirection.endToStart,
          key: Key(user.id.toString()),
          confirmDismiss: (DismissDirection direction) async {
            final bool? confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext dialogContext) {
                final String userName = widget.users[index].name;
                return AlertDialog(
                  title: const Text('Delete user'),
                  content: Text(
                    'Are you sure you want to delete $userName? This action cannot be undone.',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );

            return confirm ?? false;
          },
          onDismissed: (DismissDirection direction) {
            widget.onDeleteUser(user);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: userDisplayList),
            ),
          ),
        );
      },
    );
  }
}
