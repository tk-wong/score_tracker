import 'package:score_app/models/score_history_entry.dart';
import 'package:score_app/objectbox.g.dart';

class ScoreHistoryEntryController {
  late final Store _store;
  late final Box<ScoreHistoryEntry> _scoreHistoryEntryBox;
  ScoreHistoryEntryController.create(this._store) {
    _scoreHistoryEntryBox = _store.box<ScoreHistoryEntry>();
  }

  Stream<List<ScoreHistoryEntry>> getAllHistoryEntries() {
    final query = _scoreHistoryEntryBox
        .query()
        .order(ScoreHistoryEntry_.timestamp, flags: Order.descending)
        .watch(triggerImmediately: true);
    return query.map((q) => q.find());
  }

  void addHistoryEntry(String userName, int delta, String reason) {
    final newEntry = ScoreHistoryEntry(
      userName: userName,
      delta: delta,
      reason: reason,
      timestamp: DateTime.now(),
    );
    _scoreHistoryEntryBox.put(newEntry);
  }

  void clearHistory() {
    _scoreHistoryEntryBox.removeAll();
  }
}
