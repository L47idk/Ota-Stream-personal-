import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/media_item_model.dart';

class DatabaseService {
  static const String _libraryKey = 'user_library';
  static const String _historyKeyPrefix = 'user_history_';

  final SharedPreferences _prefs;

  DatabaseService._(this._prefs);

  static Future<DatabaseService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return DatabaseService._(prefs);
  }

  // --- Library / Bookmarks ---

  Future<List<MediaItemModel>> getLibrary() async {
    final libraryString = _prefs.getString(_libraryKey);
    if (libraryString == null) return [];

    final List<dynamic> jsonList = jsonDecode(libraryString);
    return jsonList.map((e) => MediaItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> addToLibrary(MediaItemModel item) async {
    final library = await getLibrary();
    // Avoid adding duplicates
    if (!library.any((element) => element.id == item.id && element.sourceId == item.sourceId)) {
      library.add(item);
      final jsonList = library.map((e) => e.toJson()).toList();
      await _prefs.setString(_libraryKey, jsonEncode(jsonList));
    }
  }

  Future<void> removeFromLibrary(String id, String sourceId) async {
    final library = await getLibrary();
    library.removeWhere((element) => element.id == id && element.sourceId == sourceId);
    final jsonList = library.map((e) => e.toJson()).toList();
    await _prefs.setString(_libraryKey, jsonEncode(jsonList));
  }

  Future<bool> isInLibrary(String id, String sourceId) async {
    final library = await getLibrary();
    return library.any((element) => element.id == id && element.sourceId == sourceId);
  }

  // --- Reading / Watch History ---

  Future<Map<String, dynamic>> getHistory(String mediaId) async {
    final historyString = _prefs.getString('$_historyKeyPrefix$mediaId');
    if (historyString == null) return {};
    return jsonDecode(historyString);
  }

  Future<void> saveHistory(String mediaId, Map<String, dynamic> progressData) async {
    await _prefs.setString('$_historyKeyPrefix$mediaId', jsonEncode(progressData));
  }
}