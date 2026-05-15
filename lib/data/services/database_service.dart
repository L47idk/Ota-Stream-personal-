import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryItem {
  final String id;
  final String title;
  final String coverUrl;
  final String source;
  String lastReadChapter;
  double progress;
  final String status;
  final String type;
  int updatedAt;

  LibraryItem({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.source,
    required this.lastReadChapter,
    required this.progress,
    required this.status,
    required this.type,
    required this.updatedAt,
  });

  factory LibraryItem.fromJson(Map<String, dynamic> json) => LibraryItem(
        id: json['id'],
        title: json['title'],
        coverUrl: json['coverUrl'],
        source: json['source'],
        lastReadChapter: json['lastReadChapter'] ?? '',
        progress: (json['progress'] ?? 0).toDouble(),
        status: json['status'],
        type: json['type'],
        updatedAt: json['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'coverUrl': coverUrl,
        'source': source,
        'lastReadChapter': lastReadChapter,
        'progress': progress,
        'status': status,
        'type': type,
        'updatedAt': updatedAt,
      };
}

class DatabaseService {
  static const String _libraryKey = 'otastream_library';
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<LibraryItem> getLibrary() {
    final data = _prefs?.getString(_libraryKey);
    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded.map((e) => LibraryItem.fromJson(e)).toList();
  }

  LibraryItem? getLibraryItem(String id) {
    try {
      return getLibrary().firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addToLibrary(LibraryItem item) async {
    final library = getLibrary();
    final index = library.indexWhere((i) => i.id == item.id);

    item.updatedAt = DateTime.now().millisecondsSinceEpoch;

    if (index >= 0) {
      library[index] = item;
    } else {
      library.add(item);
    }

    await _prefs?.setString(
        _libraryKey, jsonEncode(library.map((e) => e.toJson()).toList()));
  }

  Future<void> removeFromLibrary(String id) async {
    final library = getLibrary().where((item) => item.id != id).toList();
    await _prefs?.setString(
        _libraryKey, jsonEncode(library.map((e) => e.toJson()).toList()));
  }

  Future<void> updateProgress(String id, double progress, String lastReadChapter) async {
    final library = getLibrary();
    final itemIndex = library.indexWhere((i) => i.id == id);
    if (itemIndex >= 0) {
      library[itemIndex].progress = progress;
      library[itemIndex].lastReadChapter = lastReadChapter;
      library[itemIndex].updatedAt = DateTime.now().millisecondsSinceEpoch;
      await _prefs?.setString(
          _libraryKey, jsonEncode(library.map((e) => e.toJson()).toList()));
    }
  }
}

final dbService = DatabaseService();