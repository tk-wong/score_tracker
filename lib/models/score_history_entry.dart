class ScoreHistoryEntry {
  const ScoreHistoryEntry({
    required this.userName,
    required this.delta,
    required this.reason,
    required this.timestamp,
  });

  final String userName;
  final int delta;
  final String reason;
  final DateTime timestamp;
}
