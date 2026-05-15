import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import '../models/extension_model.dart';

class DynamicScraper {
  final Dio _dio = Dio();

  Future<List<ScrapedMedia>> searchMedia(
    ExtensionModel ext,
    String scriptJson,
    String query
  ) async {
    try {
      final Map<String, dynamic> script = json.decode(scriptJson);

      // Assume the extension script injects a target query format constraint
      final String searchUrl = (script['search_url'] as String)
          .replaceAll('{query}', Uri.encodeComponent(query));

      final String itemSelector = script['selectors']['search_item'];
      final String titleSelector = script['selectors']['search_title'];
      final String urlSelector = script['selectors']['search_url'];
      final String imageSelector = script['selectors']['search_image'];

      final response = await _dio.get(searchUrl);
      if (response.statusCode == 200) {
        BeautifulSoup bs = BeautifulSoup(response.data as String);
        final items = bs.findAll('', selector: itemSelector);

        List<ScrapedMedia> results = [];

        for (var item in items) {
          final titleEl = item.find('', selector: titleSelector);
          final urlEl = item.find('', selector: urlSelector);
          final imgEl = item.find('', selector: imageSelector);

          if (titleEl != null && urlEl != null) {
             String title = titleEl.text.trim();
             // Some sites put the title in a 'title' tag attribute rather than innerText
             if (title.isEmpty && titleEl.attributes.containsKey('title')) {
                 title = titleEl.attributes['title']!;
             }

             String url = urlEl.attributes['href'] ?? '';

             // Extract images (fallback check: data-src is used extensively in lazy-load sites)
             String imageUrl = '';
             if (imgEl != null) {
                imageUrl = imgEl.attributes['src'] ?? imgEl.attributes['data-src'] ?? '';
             }

             results.add(ScrapedMedia(
               title: title,
               url: url,
               imageUrl: imageUrl,
               sourceName: ext.name,
             ));
          }
        }
        return results;
      }
    } catch (e) {
      print('Scraping error for ${ext.pkgName}: $e');
    }
    return []; // Return empty instead of erroring out to un-block other sources.
  }
}