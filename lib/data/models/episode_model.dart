class EpisodeModel {
  final String id;
  final String title;
  final int episodeNumber;
  final String? thumbnailUrl;
  final bool? isFiller;

  EpisodeModel({
    required this.id,
    required this.title,
    required this.episodeNumber,
    this.thumbnailUrl,
    this.isFiller,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      episodeNumber: json['episodeNumber'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isFiller: json['isFiller'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'episodeNumber': episodeNumber,
      'thumbnailUrl': thumbnailUrl,
      'isFiller': isFiller,
    };
  }
}