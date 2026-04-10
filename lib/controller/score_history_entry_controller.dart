import 'package:objectbox/objectbox.dart';
import 'package:score_app/models/score_history_entry.dart';

class ScoreHistoryEntryController {
  late final Store _store;
  late final Box<ScoreHistoryEntry> _scoreHistoryEntryBox;
  ScoreHistoryEntryController.create(this._store) {
    _scoreHistoryEntryBox = _store.box<ScoreHistoryEntry>();
  }

  Stream<List<ScoreHistoryEntry>> getAllHistoryEntries() {
    final query = _scoreHistoryEntryBox.query().watch(triggerImmediately: true);
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