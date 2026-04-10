import 'package:score_app/models/score_user.dart';
import 'package:score_app/objectbox.g.dart';

class ScoreUserController {
  late final Store _store;
  late final Box<ScoreUser> _scoreUserBox;
  ScoreUserController.create(this._store) {
    _scoreUserBox = _store.box<ScoreUser>();
  }

  Stream<List<ScoreUser>> getAllUsers() {
    final query = _scoreUserBox.query().watch(triggerImmediately: true);
    return query.map((q) => q.find());
  }

  void removeUser(ScoreUser user) {
    _scoreUserBox.remove(user.id);
  }

  void addUser(String name) {
    final newUser = ScoreUser(name: name);
    _scoreUserBox.put(newUser);
  }
}
