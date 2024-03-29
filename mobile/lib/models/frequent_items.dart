import 'package:collection/collection.dart';

class FrequentItems {
  Map<String, List<String>> dataset;
  double support;
  int itemCount;
  FrequentItems({
    required this.dataset,
    required this.support,
    required this.itemCount,
  });

  FrequentItems copyWith({
    Map<String, List<String>>? dataset,
    double? support,
    int? itemCount,
  }) {
    return FrequentItems(
      dataset: dataset ?? this.dataset,
      support: support ?? this.support,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dataset': dataset,
      'support': support,
      'item_count': itemCount,
    };
  }

  factory FrequentItems.fromMap(Map<String, dynamic> map) {
    return FrequentItems(
      dataset: Map<String, List<String>>.from((map['dataset'] as Map<String, List<String>>)),
      support: map['support'] as double,
      itemCount: map['itemCount'] as int,
    );
  }

  @override
  String toString() => 'FrequentItems(dataset: $dataset, support: $support, itemCount: $itemCount)';

  @override
  bool operator ==(covariant FrequentItems other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return mapEquals(other.dataset, dataset) && other.support == support && other.itemCount == itemCount;
  }

  @override
  int get hashCode => dataset.hashCode ^ support.hashCode ^ itemCount.hashCode;
}
