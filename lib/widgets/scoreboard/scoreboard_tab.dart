import 'package:flutter/material.dart';
import 'package:score_app/widgets/scoreboard/scoreboard_list.dart';
import 'package:score_app/widgets/scoreboard/scoreboard_title.dart';

import '../../models/score_user.dart';

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
        ScoreboardTitle(
          onAddUser: onAddUser,
          onResetScore: onResetScore,
          emptyUserList: users.isEmpty,
        ),
        Expanded(
          child: users.isEmpty
              ? const Center(child: Text('No users added yet.'))
              : ScoreboardList(
                  users: users,
                  onAddScore: onAddScore,
                  onSubtractScore: onSubtractScore,
                  onDeleteUser: onDeleteUser,
                ),
        ),
      ],
    );
  }
}
