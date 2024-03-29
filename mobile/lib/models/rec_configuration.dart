class RecConfiguration {
  String combination;
  String accuracy;
  RecConfiguration({
    required this.combination,
    required this.accuracy,
  });

  RecConfiguration copyWith({
    String? combination,
    String? accuracy,
  }) {
    return RecConfiguration(
      combination: combination ?? this.combination,
      accuracy: accuracy ?? this.accuracy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'combination': combination,
      'accuracy': accuracy,
    };
  }

  factory RecConfiguration.fromMap(Map<String, dynamic> map) {
    return RecConfiguration(
      combination: map['combination'] as String,
      accuracy: map['accuracy'] as String,
    );
  }

  @override
  String toString() => 'RecConfiguration(combination: $combination, accuracy: $accuracy)';

  @override
  bool operator ==(covariant RecConfiguration other) {
    if (identical(this, other)) return true;

    return other.combination == combination && other.accuracy == accuracy;
  }

  @override
  int get hashCode => combination.hashCode ^ accuracy.hashCode;
}
