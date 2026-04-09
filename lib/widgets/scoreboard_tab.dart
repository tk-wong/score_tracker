import 'package:flutter/material.dart';

import '../models/score_user.dart';

class ScoreboardTab extends StatelessWidget {
  const ScoreboardTab({
    super.key,
    required this.users,
    required this.onAddUser,
    required this.onAddScore,
    required this.onSubtractScore,
    required this.onResetScore,
    required this.onDeleteUser,
  });

  final List<ScoreUser> users;
  final VoidCallback onAddUser;
  final ValueChanged<ScoreUser> onAddScore;
  final ValueChanged<ScoreUser> onSubtractScore;
  final VoidCallback onResetScore;
  final ValueChanged<ScoreUser> onDeleteUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
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
                      onPressed: onResetScore,
                      icon: const Icon(Icons.refresh),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: 'Add user',
                      onPressed: onAddUser,
                      icon: const Icon(Icons.person_add),
                    ),
                  ] else ...<Widget>[
                    FilledButton.icon(
                      onPressed: onResetScore,
                      label: const Text('Reset scores'),
                      icon: const Icon(Icons.refresh),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: onAddUser,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add user'),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        Expanded(
          child: users.isEmpty
              ? const Center(child: Text('No users added yet.'))
              : ListView.separated(
                  itemCount: users.length,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final ScoreUser user = users[index];
                    final List<Widget> userDisplayList = <Widget>[
                      CircleAvatar(child: Text(user.name.characters.first)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text('Score: ${user.score}'),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Subtract score',
                        onPressed: () => onSubtractScore(user),
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: 'Add score',
                        onPressed: () => onAddScore(user),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      key: Key(user.name),
                      confirmDismiss: (DismissDirection direction) async {
                        final bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            final String userName = users[index].name;
                            return AlertDialog(
                              title: const Text('Delete user'),
                              content: Text(
                                'Are you sure you want to delete $userName? This action cannot be undone.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );

                        return confirm ?? false;
                      },
                      onDismissed: (DismissDirection direction) {
                        onDeleteUser(user);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(children: userDisplayList),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
