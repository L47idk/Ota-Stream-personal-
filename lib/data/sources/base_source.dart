class MediaDetails {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final String status;
  final String sourceId;
  final String type; // 'anime' | 'manga'
  final List<ChapterOrEpisode> chapters;

  MediaDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.status,
    required this.sourceId,
    required this.type,
    this.chapters = const [],
  });
}

class ChapterOrEpisode {
  final String id;
  final String title;
  final double chapterNumber;

  ChapterOrEpisode({
    required this.id,
    required this.title,
    required this.chapterNumber,
  });
}

abstract class BaseSource {
  String get sourceId;
  String get sourceName;
  String get type; // 'anime' or 'manga'

  Future<List<MediaDetails>> search(String query);
  Future<MediaDetails> fetchDetails(String mediaId);
  Future<List<ChapterOrEpisode>> fetchChapters(String mediaId);

  // Specific to Manga sources (returns List of image URLs)
  Future<List<String>> fetchImages(String chapterId) async => [];

  // Specific to Anime sources (returns the Video Stream URL m3u8/mp4)
  Future<String> fetchResource(String chapterOrEpisodeId) async => '';
}