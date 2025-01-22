class MetricRecord {
  final DateTime timestamp;
  final double value;

  MetricRecord({
    required this.timestamp,
    required this.value,
  });
}

class MetricModel {
  final String name;
  double lastValue;
  double? previousValue;
  List<MetricRecord> history;

  MetricModel({
    required this.name,
    this.lastValue = 0.0,
    this.previousValue,
    List<MetricRecord>? history,
  }) : history = history ?? [];

  void updateValue(double newValue) {
    previousValue = lastValue;
    lastValue = newValue;
    history.add(MetricRecord(
      timestamp: DateTime.now(),
      value: newValue,
    ));
  }
}
