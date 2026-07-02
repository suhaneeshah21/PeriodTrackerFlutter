class CycleEntry {
  final String? id;
  final DateTime startDate;
  final String flow;
  final int cycleLength;
  final int periodDuration;
  final List<String> symptoms;
  final DateTime createdAt;

  CycleEntry({
    this.id,
    required this.startDate,
    required this.flow,
    required this.cycleLength,
    required this.periodDuration,
    required this.symptoms,
    required this.createdAt,
  });

  // Convert to Map to save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'flow': flow,
      'cycleLength': cycleLength,
      'periodDuration': periodDuration,
      'symptoms': symptoms,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert Firestore document back to CycleEntry
  factory CycleEntry.fromMap(String id, Map<String, dynamic> map) {
    return CycleEntry(
      id: id,
      startDate: DateTime.parse(map['startDate']),
      flow: map['flow'],
      cycleLength: map['cycleLength'],
      periodDuration: map['periodDuration'],
      symptoms: List<String>.from(map['symptoms']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}