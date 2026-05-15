import 'dart:convert';
import 'base_source.dart';
import '../services/scraper_service.dart';

class MangaDexSource extends BaseSource {
  @override
  String get sourceId => 'mangadex_api';

  @override
  String get sourceName => 'MangaDex';

  @override
  String get type => 'manga';

  @override
  Future<List<MediaDetails>> search(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final json = await scraperService.fetchJson(
          'https://api.mangadex.org/manga?title=$encodedQuery&limit=10&includes[]=cover_art');

      return (json['data'] as List).map((manga) {
        final titleMap = manga['attributes']['title'] as Map<String, dynamic>;
        final title = titleMap['en'] ?? titleMap.values.first ?? '';

        final descMap = manga['attributes']['description'] as Map<String, dynamic>?;
        final desc = descMap?['en'] ?? '';

        final relationships = manga['relationships'] as List;
        final coverRel = relationships.cast<Map<String,dynamic>?>().firstWhere(
          (r) => r?['type'] == 'cover_art', orElse: () => null
        );
        final coverFileName = coverRel?['attributes']?['fileName'];

        final coverUrl = coverFileName != null
            ? 'https://uploads.mangadex.org/covers/${manga['id']}/$coverFileName.256.jpg'
            : 'https://images.unsplash.com/photo-1541562232516-fd72ce304c1c?w=400';

        final tags = (manga['attributes']['tags'] as List).where((t) {
          final group = t['attributes']['group'];
          return group == 'genre' || group == 'theme';
        }).map((t) => t['attributes']['name']['en'].toString()).toList();

        return MediaDetails(
          id: manga['id'],
          title: title,
          description: desc,
          coverUrl: coverUrl,
          status: manga['attributes']['status'] ?? '',
          tags: tags,
        );
      }).toList();
    } catch (e) {
      print('MangaDex Search Error: $e');
      return [];
    }
  }

  @override
  Future<MediaDetails> fetchDetails(String mediaId) async {
    try {
      final json = await scraperService.fetchJson(
          'https://api.mangadex.org/manga/$mediaId?includes[]=cover_art');
      final manga = json['data'];

      final titleMap = manga['attributes']['title'] as Map<String, dynamic>;
      final title = titleMap['en'] ?? titleMap.values.first ?? '';

      final relationships = manga['relationships'] as List;
      final coverRel = relationships.cast<Map<String,dynamic>?>().firstWhere(
        (r) => r?['type'] == 'cover_art', orElse: () => null
      );
      final coverFileName = coverRel?['attributes']?['fileName'];

      final coverUrl = coverFileName != null
          ? 'https://uploads.mangadex.org/covers/${manga['id']}/$coverFileName.512.jpg'
          : 'https://images.unsplash.com/photo-1541562232516-fd72ce304c1c?w=400';

      final chapters = await fetchChapters(mediaId);

      return MediaDetails(
        id: manga['id'],
        title: title,
        description: '',
        coverUrl: coverUrl,
        status: manga['attributes']['status'],
        chapters: chapters,
      );
    } catch (e) {
      throw Exception('Failed to fetch MangaDex details: $e');
    }
  }

  @override
  Future<List<ChapterOrEpisode>> fetchChapters(String mediaId) async {
    try {
      final json = await scraperService.fetchJson(
          'https://api.mangadex.org/manga/$mediaId/feed?translatedLanguage[]=en&order[chapter]=desc&limit=100');

      return (json['data'] as List).map((chap) => ChapterOrEpisode(
        id: chap['id'],
        title: chap['attributes']['title'] ?? 'Chapter ${chap['attributes']['chapter']}',
        chapterNumber: double.tryParse(chap['attributes']['chapter']?.toString() ?? '0') ?? 0.0,
      )).toList();
    } catch (e) {
      print('MangaDex Chapter Error: $e');
      return [];
    }
  }

  @override
  Future<dynamic> fetchResource(String chapterOrEpisodeId) async {
    try {
      final json = await scraperService.fetchJson(
          'https://api.mangadex.org/at-home/server/$chapterOrEpisodeId');

      final baseUrl = json['baseUrl'];
      final hash = json['chapter']['hash'];
      final chapterData = json['chapter']['data'] as List;

      return chapterData.map((filename) => '$baseUrl/data/$hash/$filename').toList().cast<String>();
    } catch (e) {
      print('MangaDex Resource Error: $e');
      return <String>[];
    }
  }
}