import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/score_history_entry.dart';
import '../models/score_reason.dart';
import '../models/score_user.dart';
import '../widgets/history_tab.dart';
import '../widgets/reason_dialog.dart';
import '../widgets/scoreboard_tab.dart';

class ScoreHomePage extends StatefulWidget {
  const ScoreHomePage({super.key});

  @override
  State<ScoreHomePage> createState() => _ScoreHomePageState();
}

class _ScoreHomePageState extends State<ScoreHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<ScoreUser> _users = <ScoreUser>[
    ScoreUser(name: 'Alice'),
    ScoreUser(name: 'Bob'),
  ];

  final List<ScoreReason> _defaultReasons = const <ScoreReason>[
    ScoreReason(label: 'Correct answer', delta: 10),
    ScoreReason(label: 'Fastest response', delta: 5),
    ScoreReason(label: 'Teamwork bonus', delta: 3),
    ScoreReason(label: 'Wrong answer', delta: -5),
    ScoreReason(label: 'Rule violation', delta: -10),
  ];

  final Queue<ScoreHistoryEntry> _history = ListQueue<ScoreHistoryEntry>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _promptAddUser() async {
    final TextEditingController controller = TextEditingController();
    final String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add user'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter user name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final String value = controller.text.trim();
                if (value.isEmpty) {
                  return;
                }
                Navigator.pop(context, value);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (newName == null || newName.isEmpty) {
      return;
    }

    final bool exists = _users.any(
      (ScoreUser user) =>
          user.name.toLowerCase() == newName.trim().toLowerCase(),
    );

    if (exists) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User already exists.')));
      return;
    }

    setState(() {
      _users.add(ScoreUser(name: newName.trim()));
    });
  }

  Future<void> _changeScore(ScoreUser user, bool isIncrease) async {
    final List<ScoreReason> filtered = _defaultReasons.where((
      ScoreReason item,
    ) {
      if (isIncrease) {
        return item.delta > 0;
      }
      return item.delta < 0;
    }).toList();

    final ScoreReason? result = await showDialog<ScoreReason>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ReasonDialog(isIncrease: isIncrease, defaultReasons: filtered);
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      user.score += result.delta;
      _history.addFirst(
        ScoreHistoryEntry(
          userName: user.name,
          delta: result.delta,
          reason: result.label,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  Future<void> _resetScores() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset all scores'),
          content: const Text(
            'Are you sure you want to reset all scores to zero? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      for (final ScoreUser user in _users) {
        final int oldScore = user.score;
        user.score = 0;
        _history.addFirst(
          ScoreHistoryEntry(
            userName: user.name,
            delta: -oldScore,
            reason: 'Score reset',
            timestamp: DateTime.now(),
          ),
        );
      }
    });
  }

  void _deleteUser(ScoreUser user) {
    setState(() {
      _users.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Tracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(text: 'Scoreboard', icon: Icon(Icons.groups)),
            Tab(text: 'History', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ScoreboardTab(
            users: _users,
            onAddUser: _promptAddUser,
            onAddScore: (ScoreUser user) => _changeScore(user, true),
            onSubtractScore: (ScoreUser user) => _changeScore(user, false),
            onResetScore: _resetScores,
            onDeleteUser: _deleteUser,
          ),
          HistoryTab(history: _history),
        ],
      ),
    );
  }
}
