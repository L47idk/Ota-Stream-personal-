// lib/sources/animepahe_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class AnimePaheSource {
  static const String baseUrl = 'https://animepahe.pw';

  Map<String, String> get _headers => {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)',
        'Referer': '$baseUrl/',
      };

  /// 1. Searches AnimePahe using the internal API endpoint
  Future<List<Map<String, dynamic>>> search(String query) async {
    final searchUrl = '$baseUrl/api?m=search&q=${Uri.encodeQueryComponent(query)}';

    try {
      final response = await http.get(Uri.parse(searchUrl), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data'] as List<dynamic>? ?? [];

        return results.map((item) => {
              'id': item['session']?.toString() ?? item['id']?.toString() ?? '',
              'title': item['title']?.toString() ?? '',
              'poster': item['poster']?.toString() ?? '',
              'type': item['type']?.toString() ?? '',
              'status': item['status']?.toString() ?? '',
              'year': item['year']?.toString() ?? '',
            }).toList();
      } else {
        throw Exception('Failed to search AnimePahe: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('AnimePahe Search Error: $e');
      return [];
    }
  }

  /// 2. Get Anime Details
  Future<Map<String, dynamic>?> getDetails(String session) async {
    final url = '$baseUrl/anime/$session';
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        final document = BeautifulSoup(response.body);

        final title = document.find('div', class_: 'title-wrapper')?.find('h1')?.text.trim();
        final description = document.find('div', class_: 'anime-synopsis')?.text.trim();
        final poster = document.find('a', class_: 'youtube-preview')?.find('img')?.attributes['src'] ?? '';

        // Extract status
        String statusText = 'Unknown';
        try {
          final infoDiv = document.find('div', class_: 'anime-info');
          if (infoDiv != null) {
            final paragraphs = infoDiv.findAll('p');
            for (var p in paragraphs) {
              if (p.text.contains('Status:')) {
                statusText = p.text.replaceFirst('Status:', '').trim();
                break;
              }
            }
          }
        } catch (_) {}

        return {
          'id': session,
          'title': title ?? '',
          'description': description ?? 'No description available.',
          'poster': poster,
          'status': statusText,
        };
      }
      return null;
    } catch (e) {
      print('AnimePahe Get Details Error: $e');
      return null;
    }
  }

  /// 3. Get Episodes via API
  Future<List<Map<String, dynamic>>> getEpisodes(String session, {int page = 1}) async {
    final url = '$baseUrl/api?m=release&id=$session&sort=episode_asc&page=$page';
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data'] as List<dynamic>? ?? [];

        return results.map((item) => {
              'id': item['session']?.toString() ?? '',
              'episode_number': item['episode'],
              'title': item['title']?.toString() ?? 'Episode ${item['episode']}',
              'snapshot': item['snapshot']?.toString() ?? '',
            }).toList();
      } else {
        throw Exception('Failed to fetch episodes: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('AnimePahe Episodes Error: $e');
      return [];
    }
  }

  /// 4. Fetches the Episode Page and Finds the Video Iframe Src
  Future<String?> getVideoIframeSrc(String animeSession, String episodeSession) async {
    final episodeUrl = '$baseUrl/play/$animeSession/$episodeSession';
    try {
      final response = await http.get(Uri.parse(episodeUrl), headers: _headers);

      if (response.statusCode == 200) {
        final document = BeautifulSoup(response.body);
        final iframe = document.find('iframe', id: 'videoPlayer');

        if (iframe != null) {
          final src = iframe.attributes['src'];
          if (src != null) {
            if (src.startsWith('//')) return 'https:$src';
            if (src.startsWith('/')) return '$baseUrl$src';
            return src;
          }
        }
      }
      return null;
    } catch (e) {
      print('AnimePahe Video Iframe Error: $e');
      return null;
    }
  }

  /// 5. Extracts the .m3u8 stream link from the Kwik.cx script tags
  Future<String?> extractKwikUrl(String kwikIframeUrl) async {
    try {
      final response = await http.get(Uri.parse(kwikIframeUrl), headers: {
        'Referer': '$baseUrl/',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)',
      });

      if (response.statusCode == 200) {
        final body = response.body;

        final doc = BeautifulSoup(body);
        final scripts = doc.findAll('script');

        for (var script in scripts) {
          final text = script.text;

          // Pattern 1: Direct extraction if visible
          if (text.contains('.m3u8')) {
            final directMatch = RegExp(r"(https?://[^\s'\"<>]*?\.m3u8[^\s'\"<>]*)").firstMatch(text);
            if (directMatch != null) return directMatch.group(1);
          }

          // Pattern 2: Packed JS extraction (Eval unpacker)
          if (text.contains('eval(function(p,a,c,k,e,d)')) {
            final kSegmentRegex = RegExp(r"return p}\('(.*?)',(\d+),(\d+),'(.*?)'\.split\('\|'\)");
            final m = kSegmentRegex.firstMatch(text);

            if (m != null) {
              final payload = m.group(1) ?? '';
              final pLine = m.group(4) ?? '';
              final p = pLine.split('|');

              // Basic unpacker for Kwik structure
              var unpacked = payload.replaceAllMapped(RegExp(r'\b\w+\b'), (match) {
                final token = match.group(0)!;
                int decToken = int.tryParse(token, radix: 36) ?? 0;

                // Keep the original token if lookup fails or resolves to empty
                if (decToken < p.length && p[decToken].isNotEmpty) {
                  return p[decToken];
                }
                return token;
              });

              final embeddedMatch = RegExp(r"(https?://[^\s'\"<>]*?\.m3u8[^\s'\"<>]*)").firstMatch(unpacked);
              if (embeddedMatch != null) return embeddedMatch.group(1);
            }
          }
        }
      }
      return null;
    } catch (e) {
      print('Kwik Extraction Error: $e');
      return null;
    }
  }

  /// 6. Complete utility to fetch Stream URL directly from Anime/Episode IDs
  Future<String?> getStreamUrl(String animeSession, String episodeSession) async {
    final iframeSrc = await getVideoIframeSrc(animeSession, episodeSession);
    if (iframeSrc == null) return null;

    final kwikStreamUrl = await extractKwikUrl(iframeSrc);
    return kwikStreamUrl;
  }
}
