import '../models/media_item_model.dart';
import '../models/chapter_model.dart';
import '../models/episode_model.dart';
import '../sources/base_source.dart';

class MediaRepositoryImpl {
  final Map<String, BaseSource> _sources;

  MediaRepositoryImpl(this._sources);

  Future<List<MediaItemModel>> searchMedia(String query, String sourceId) async {
    final source = _sources[sourceId];
    if (source == null) throw Exception('Source not found: $sourceId');
    return source.search(query);
  }

  Future<MediaItemModel> getMediaDetails(String id, String sourceId) async {
    final source = _sources[sourceId];
    if (source == null) throw Exception('Source not found: $sourceId');
    return source.getDetails(id);
  }

  Future<List<ChapterModel>> getChapters(String mediaId, String sourceId) async {
    final source = _sources[sourceId];
    if (source == null) throw Exception('Source not found: $sourceId');
    return source.getChapters(mediaId);
  }

  Future<List<EpisodeModel>> getEpisodes(String mediaId, String sourceId) async {
    final source = _sources[sourceId];
    if (source == null) throw Exception('Source not found: $sourceId');
    return source.getEpisodes(mediaId);
  }

  Future<List<String>> getChapterPages(String chapterId, String sourceId) async {
    final source = _sources[sourceId];
    if (source == null) throw Exception('Source not found: $sourceId');
    return source.getChapterPages(chapterId);
  }

  Future<String> getVideoUrl(String episodeId, String sourceId) async {
    final source = _sources[sourceId];
    if (source == null) throw Exception('Source not found: $sourceId');
    return source.getVideoUrl(episodeId);
  }
}