class ChapterModel {
  final String id;
  final String title;
  final double chapterNumber;
  final DateTime? releaseDate;
  final String? volume;

  ChapterModel({
    required this.id,
    required this.title,
    required this.chapterNumber,
    this.releaseDate,
    this.volume,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'] as String,
      title: json['title'] as String,
      chapterNumber: (json['chapterNumber'] as num).toDouble(),
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'] as String)
          : null,
      volume: json['volume'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'chapterNumber': chapterNumber,
      'releaseDate': releaseDate?.toIso8601String(),
      'volume': volume,
    };
  }
}