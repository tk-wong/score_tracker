
import 'package:score_app/models/score_user.dart';
import 'package:score_app/objectbox.g.dart';

class ScoreUserController {
  late final Store _store;
  late final Box<ScoreUser> _scoreUserBox;
  ScoreUserController.create(this._store) {
    _scoreUserBox = _store.box<ScoreUser>();
  }

  Stream<List<ScoreUser>> getAllUsers() {
    final userStream = _scoreUserBox
        .query()
        .order(ScoreUser_.score, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((q) => q.find())
        ;
    return userStream;
  }

  void removeUser(ScoreUser user) {
    _scoreUserBox.remove(user.id);
  }

  void addUser(String name) {
    if (checkUserExists(name)) {
      return;
    }
    final newUser = ScoreUser(name: name);
    _scoreUserBox.put(newUser);
  }

  void addDefaultUsers() {
    final List<ScoreUser> users = <ScoreUser>[
      ScoreUser(name: 'Alice'),
      ScoreUser(name: 'Bob'),
    ];
    if (_scoreUserBox.isEmpty()) {
      _scoreUserBox.putMany(users);
    }
  }

  bool checkUserExists(String name) {
    final query = _scoreUserBox
        .query(ScoreUser_.name.equals(name, caseSensitive: false))
        .build();
    final exists = query.findFirst() != null;
    query.close();
    return exists;
  }

  List<ScoreUser> resetScores() {
    final query = _scoreUserBox.query().build();
    final users = query.find();
    for (final user in users) {
      user.score = 0;
    }
    _scoreUserBox.putMany(users);
    query.close();
    return users;
  }

  void updateUserScore(ScoreUser user, int delta) {
    user.score += delta;
    _scoreUserBox.put(user);
  }
}
