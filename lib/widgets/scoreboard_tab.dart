import 'package:flutter/material.dart';

import '../models/score_user.dart';

class ScoreboardTab extends StatefulWidget {
  const ScoreboardTab({
    super.key,
    required this.users,
    required this.onAddUser,
    required this.onAddScore,
    required this.onSubtractScore,
  });

  final List<ScoreUser> users;
  final VoidCallback onAddUser;
  final ValueChanged<ScoreUser> onAddScore;
  final ValueChanged<ScoreUser> onSubtractScore;

  @override
  State<ScoreboardTab> createState() => _ScoreboardTabState();
}

class _ScoreboardTabState extends State<ScoreboardTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Text('Users', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              FilledButton.icon(
                onPressed: widget.onAddUser,
                icon: const Icon(Icons.person_add),
                label: const Text('Add user'),
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.users.isEmpty
              ? const Center(child: Text('No users added yet.'))
              : ListView.separated(
                  itemCount: widget.users.length,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final ScoreUser user = widget.users[index];
                        return Dismissible(
                          background: Container(
                            // color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Delete',
                              style: const TextStyle(color: Colors.white, fontSize:16),
                              
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          key: Key(user.name),
                          onDismissed: (direction) {
                            setState(() {
                              widget.users.removeAt(index);
                            });

                            // Handle dismissal logic if needed
                          },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                child: Text(user.name.characters.first),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      user.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
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
                            ],
                          ),
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
