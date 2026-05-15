class MediaItemModel {
  final String id;
  final String title;
  final String coverUrl;
  final String description;
  final String type; // 'ANIME' or 'MANGA'
  final String sourceId;
  final String? status;
  final List<String>? genres;

  MediaItemModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.description,
    required this.type,
    required this.sourceId,
    this.status,
    this.genres,
  });

  factory MediaItemModel.fromJson(Map<String, dynamic> json) {
    return MediaItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      coverUrl: json['coverUrl'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      sourceId: json['sourceId'] as String,
      status: json['status'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coverUrl': coverUrl,
      'description': description,
      'type': type,
      'sourceId': sourceId,
      'status': status,
      'genres': genres,
    };
  }
}