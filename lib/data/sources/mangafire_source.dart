import 'package:html/parser.dart' as html;
import '../../network/http_client.dart';
import '../../utils/html_parser_helpers.dart';
import '../../utils/logger.dart';
import 'base_source.dart';

class MangaFireSource extends BaseSource {
  @override
  String get sourceId => 'mangafire_web';

  @override
  String get sourceName => 'MangaFire';

  @override
  String get type => 'manga';

  @override
  Future<List<MediaDetails>> search(String query) async {
    try {
      final response = await HttpClient.get('https://mangafire.to/filter?keyword=${Uri.encodeComponent(query)}');
      final document = html.parse(response);
      final items = document.querySelectorAll('.item');

      return items.map((element) {
        final id = HtmlParserHelpers.getAttribute(element, 'a', 'href') ?? '';
        final title = HtmlParserHelpers.getText(element, '.info .name') ?? 'Unknown Title';
        final coverUrl = HtmlParserHelpers.getAttribute(element, '.poster img', 'src') ?? '';

        return MediaDetails(
          id: id.replaceFirst('/manga/', ''),
          title: title,
          description: '',
          coverUrl: coverUrl,
          status: 'Unknown',
          sourceId: sourceId,
          type: type,
        );
      }).toList();
    } catch (e) {
      Logger.e('MangaFire search error: $e', tag: 'MangaFireSource');
      return [];
    }
  }

  @override
  Future<MediaDetails> fetchDetails(String mediaId) async {
    try {
      final url = 'https://mangafire.to/manga/$mediaId';
      final response = await HttpClient.get(url);
      final document = html.parse(response);

      final title = HtmlParserHelpers.getText(document, '.info .name') ?? 'Unknown Title';
      final description = HtmlParserHelpers.getText(document, '.info .description') ?? 'No description available.';
      final coverUrl = HtmlParserHelpers.getAttribute(document, '.poster img', 'src') ?? '';

      final chapters = await fetchChapters(mediaId);

      return MediaDetails(
        id: mediaId,
        title: title,
        description: description,
        coverUrl: coverUrl,
        status: 'Ongoing',
        sourceId: sourceId,
        type: type,
        chapters: chapters,
      );
    } catch (e) {
      Logger.e('MangaFire fetchDetails error: $e', tag: 'MangaFireSource');
      throw Exception('Failed to load MangaFire details');
    }
  }

  @override
  Future<List<ChapterOrEpisode>> fetchChapters(String mediaId) async {
    try {
      final url = 'https://mangafire.to/manga/$mediaId';
      final response = await HttpClient.get(url);
      final document = html.parse(response);

      final chapterElements = document.querySelectorAll('.list-item.chapter li');

      return chapterElements.map((element) {
        final chapterUrl = HtmlParserHelpers.getAttribute(element, 'a', 'href') ?? '';
        final title = HtmlParserHelpers.getText(element, 'a') ?? 'Unknown Chapter';
        final chapterId = chapterUrl.split('/').last;

        double chapterNumber = 0.0;
        final match = RegExp(r'chapter-(\d+\.?\d*)').firstMatch(chapterUrl);
        if (match != null) {
          chapterNumber = double.tryParse(match.group(1) ?? '0') ?? 0.0;
        }

        return ChapterOrEpisode(
          id: chapterId,
          title: title,
          chapterNumber: chapterNumber,
        );
      }).toList();
    } catch (e) {
      Logger.e('MangaFire fetchChapters error: $e', tag: 'MangaFireSource');
      return [];
    }
  }

  @override
  Future<List<String>> fetchImages(String chapterId) async {
    try {
      // MangaFire's image decoder requires a reverse challenge extraction!
      // For testing your UI pipeline, this returns basic placeholder images.
      // To build the real stream pipeline you'd add JS injection in flutter_inappwebview.
      Logger.i('Resolving images for $chapterId', tag: 'MangaFireSource');
      return [
        'https://images.unsplash.com/photo-1618331835717-801e976710b2?auto=format&fit=crop&w=400&q=80',
        'https://images.unsplash.com/photo-1541562232579-515a21318f2d?auto=format&fit=crop&w=400&q=80',
      ];
    } catch (e) {
      Logger.e('MangaFire fetchImages error: $e', tag: 'MangaFireSource');
      return [];
    }
  }
}