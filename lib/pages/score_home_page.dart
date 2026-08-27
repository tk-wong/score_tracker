import 'dart:async';

import 'package:flutter/material.dart';
import 'package:score_app/controller/score_history_entry_controller.dart';
import 'package:score_app/controller/score_reason_controller.dart';
import 'package:score_app/controller/score_user_controller.dart';
import 'package:score_app/main.dart';

import '../models/score_history_entry.dart';
import '../models/score_reason.dart';
import '../models/score_user.dart';
import '../widgets/history/history_tab.dart';
import '../widgets/scoreboard/reason_dialog.dart';
import '../widgets/scoreboard/scoreboard_tab.dart';
import 'setting_page.dart';

class ScoreHomePage extends StatefulWidget {
  const ScoreHomePage({super.key});

  @override
  State<ScoreHomePage> createState() => _ScoreHomePageState();
}

class _ScoreHomePageState extends State<ScoreHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  late final ScoreUserController _userController;
  late final ScoreReasonController _reasonController;
  late final ScoreHistoryEntryController _historyController;
  late final Stream<List<ScoreUser>> _userStream;

  late StreamSubscription<List<ScoreUser>> _userSubscription;
  late StreamSubscription<List<ScoreHistoryEntry>> _historySubscription;

  List<ScoreUser> _users = [];
  bool _isUserLoading = true;

  List<ScoreHistoryEntry> _historyEntries = [];
  bool _isHistoryLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _userController = ScoreUserController.create(objectBox.store);
    _reasonController = ScoreReasonController.create(objectBox.store);
    _historyController = ScoreHistoryEntryController.create(objectBox.store);
    _userStream = _userController.getAllUsers();
    _userSubscription = _userStream.listen((List<ScoreUser> users) {
      if (mounted) {
        setState(() {
          _users = users;
          _isUserLoading = false;
        });
      }
      _historySubscription = _historyController.getAllHistoryEntries().listen((
        List<ScoreHistoryEntry> entries,
      ) {
        if (mounted) {
          setState(() {
            _historyEntries = entries;
            _isHistoryLoading = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userSubscription.cancel();
    _historySubscription.cancel();
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

    final bool exists = _userController.checkUserExists(newName.trim());

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
      _userController.addUser(newName.trim());
    });
  }

  Future<void> _changeScore(ScoreUser user, bool isIncrease) async {
    late final List<ScoreReason> filtered;
    if (isIncrease) {
      filtered = await _reasonController.getPositiveReasons().first;
    } else {
      filtered = await _reasonController.getNegativeReasons().first;
    }
    if (!mounted) {
      return;
    }
    final ScoreReason? result = await showDialog<ScoreReason>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ReasonDialog(isIncrease: isIncrease, defaultReasons: filtered);
      },
    );
    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _userController.updateUserScore(user, result.delta);
      _historyController.addHistoryEntry(user.name, result.delta, result.label);
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
      final List<ScoreUser> users = _userController.resetScores();
      for (final ScoreUser user in users) {
        // final int oldScore = user.score;
        // user.score = 0;
        _historyController.addHistoryEntry(
          user.name,
          -user.score,
          'Score reset',
        );
      }
    });
  }

  Future<void> _clearHistory() async {
    final (bool confirm, bool resetScores) =
        await showDialog<(bool, bool)>(
          context: context,
          builder: (BuildContext context) {
            bool resetScores = false;
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: const Text('Clear History'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Are you sure you want to clear all history? This action cannot be undone.',
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: resetScores,
                            onChanged: (bool? value) {
                              setState(() {
                                resetScores = value!;
                              });
                            },
                          ),
                          const Text('Also reset all scores to zero'),
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, (false, resetScores)),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () =>
                          Navigator.pop(context, (true, resetScores)),
                      child: const Text('Clear'),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        (false, false);

    if (!confirm) {
      return;
    }
    _historyController.clearHistory();
    if (resetScores) {
      _userController.resetScores();
    }
  }

  void _deleteUser(ScoreUser user) {
    setState(() {
      _users.removeWhere((ScoreUser u) => u.id == user.id);
      _userController.removeUser(user);
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
        actions: [IconButton(onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              ),
                if (mounted) 
                {setState(() {})}
  
        }, icon: Icon(Icons.settings))],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _isUserLoading
              ? const Center(child: CircularProgressIndicator())
              : ScoreboardTab(
                  users: _users,
                  onAddUser: _promptAddUser,
                  onAddScore: (ScoreUser user) => _changeScore(user, true),
                  onSubtractScore: (ScoreUser user) =>
                      _changeScore(user, false),
                  onResetScore: _resetScores,
                  onDeleteUser: _deleteUser,
                ),
          _isHistoryLoading
              ? const Center(child: CircularProgressIndicator())
              : HistoryTab(
                  history: _historyEntries,
                  onClearHistory: _clearHistory,
                ),
        ],
      ),
    );
  }
}
