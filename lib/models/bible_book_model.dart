class BibleBookModel {
  final String id;
  final String name;
  final String testament; // 'old' or 'new'
  final int order;

  BibleBookModel({
    required this.id,
    required this.name,
    required this.testament,
    required this.order,
  });

  factory BibleBookModel.fromJson(Map<String, dynamic> json) {
    return BibleBookModel(
      id: json['id'] as String,
      name: json['name'] as String,
      testament: json['testament'] as String,
      order: json['order'] as int,
    );
  }
}
