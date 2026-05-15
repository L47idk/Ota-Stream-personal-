import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AniListMedia {
  final int id;
  final String romajiTitle;
  final String englishTitle;
  final String coverImage;
  final String description;
  final String status;
  final double averageScore;
  final String type;

  AniListMedia({
    required this.id,
    required this.romajiTitle,
    required this.englishTitle,
    required this.coverImage,
    required this.description,
    required this.status,
    required this.averageScore,
    required this.type,
  });

  factory AniListMedia.fromJson(Map<String, dynamic> json) {
    return AniListMedia(
      id: json['id'],
      romajiTitle: json['title']?['romaji'] ?? '',
      englishTitle: json['title']?['english'] ?? '',
      coverImage: json['coverImage']?['large'] ?? json['coverImage']?['extraLarge'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'UNKNOWN',
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      type: json['type'] ?? 'ANIME',
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': {'romaji': romajiTitle, 'english': englishTitle},
    'coverImage': {'large': coverImage},
    'description': description,
    'status': status,
    'averageScore': averageScore,
    'type': type,
  };
}

class AniListService {
  static const String _cacheKey = 'anilist_trending_cache';
  static const int _cacheTimeMs = 1000 * 60 * 60; // 1 hour

  Future<List<AniListMedia>> fetchTrending() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check cache
    try {
      final cached = prefs.getString(_cacheKey);
      if (cached != null) {
        final decoded = jsonDecode(cached);
        final timestamp = decoded['timestamp'] as int;
        if (DateTime.now().millisecondsSinceEpoch - timestamp < _cacheTimeMs) {
          final dataList = decoded['data'] as List;
          return dataList.map((e) => AniListMedia.fromJson(e)).toList();
        }
      }
    } catch (_) {}

    const query = '''
      query {
        Page(page: 1, perPage: 20) {
          media(sort: TRENDING_DESC, isAdult: false) {
            id
            title { romaji english }
            coverImage { large extraLarge }
            description
            status
            averageScore
            type
          }
        }
      }
    ''';

    try {
      final response = await http.post(
        Uri.parse('https://graphql.anilist.co'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'query': query}),
      );

      if (response.statusCode != 200) throw Exception("GraphQL request failed");
      
      final json = jsonDecode(response.body);
      final mediaList = (json['data']['Page']['media'] as List)
          .map((item) => AniListMedia.fromJson(item))
          .toList();

      // Save to cache
      await prefs.setString(_cacheKey, jsonEncode({
        'data': mediaList.map((e) => e.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }));

      return mediaList;
    } catch (e) {
      print('Failed to fetch from AniList: $e');
      return [];
    }
  }
}

final aniListService = AniListService();