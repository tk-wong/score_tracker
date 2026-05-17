import 'package:score_app/models/score_reason.dart';
import 'package:score_app/objectbox.g.dart';

class ScoreReasonController {
  late final _store;
  late final _scoreReasonBox;
  ScoreReasonController.create(this._store) {
    _scoreReasonBox = _store.box<ScoreReason>();
  }

  Stream<List<ScoreReason>> getAllReasons() {
    final Stream<Query<ScoreReason>> query = _scoreReasonBox
        .query()
        .order(ScoreReason_.delta, flags: Order.descending)
        .watch(triggerImmediately: true);
    return query.map((q) => q.find());
  }

  Stream<List<ScoreReason>> getPositiveReasons() {
    final Stream<Query<ScoreReason>> query = _scoreReasonBox
        .query(ScoreReason_.delta.greaterOrEqual(0))
        .order(ScoreReason_.delta, flags: Order.descending)
        .watch(triggerImmediately: true);
    return query.map((q) => q.find());
  }

  Stream<List<ScoreReason>> getNegativeReasons() {
    final Stream<Query<ScoreReason>> query = _scoreReasonBox
        .query(ScoreReason_.delta.lessThan(0))
        .order(ScoreReason_.delta, flags: Order.descending)
        .watch(triggerImmediately: true);
    return query.map((q) => q.find());
  }

  void deleteReason(int id) {
    _scoreReasonBox.remove(id);
  }
  void loadDefaultReasons() {
    final List<ScoreReason> defaultReasons = <ScoreReason>[
      ScoreReason(label: 'Correct answer', delta: 10),
      ScoreReason(label: 'Fastest response', delta: 5),
      ScoreReason(label: 'Teamwork bonus', delta: 3),
      ScoreReason(label: 'Wrong answer', delta: -5),
      ScoreReason(label: 'Rule violation', delta: -10),
    ];

    if (_scoreReasonBox.isEmpty()) {
      _scoreReasonBox.putMany(defaultReasons);
    }
  }
}
