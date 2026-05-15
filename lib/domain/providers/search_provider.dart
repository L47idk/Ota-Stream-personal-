import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/extension_manager.dart';
import '../services/dynamic_scraper.dart';
import '../models/extension_model.dart';

// Provides the system-wide state of search UI
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref.read(extensionManagerProvider));
});

class SearchState {
  final bool isLoading;
  final List<ScrapedMedia> results;
  final String category; // 'manga' or 'anime'

  SearchState({
    this.isLoading = false,
    this.results = const [],
    this.category = 'manga'
  });

  SearchState copyWith({bool? isLoading, List<ScrapedMedia>? results, String? category}) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      category: category ?? this.category,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final ExtensionManager _manager;
  final DynamicScraper _scraper = DynamicScraper();

  SearchNotifier(this._manager) : super(SearchState());

  void setCategory(String category) {
    state = state.copyWith(category: category, results: []); // Clear results immediately on swap
  }

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    state = state.copyWith(isLoading: true, results: []);

    // Load only extensions that match the currently selected segment
    final relevantExtensions = _manager.installedExtensions
        .where((ext) => ext.type == state.category)
        .toList();

    List<Future<List<ScrapedMedia>>> scraperTasks = [];

    // Queue up the network/scraper requests
    for (var ext in relevantExtensions) {
      scraperTasks.add(_searchExtension(ext, query));
    }

    // Await all scrapers simultaneously - significantly faster than awaiting sequentially!
    final List<List<ScrapedMedia>> allResults = await Future.wait(scraperTasks);

    // Flatten 2-dimensional grid into a 1D mapping of combined search results
    final List<ScrapedMedia> flattenedResults = allResults.expand((e) => e).toList();

    state = state.copyWith(isLoading: false, results: flattenedResults);
  }

  Future<List<ScrapedMedia>> _searchExtension(ExtensionModel ext, String query) async {
    final script = await _manager.getExtensionScript(ext.pkgName);
    if (script != null) {
      return await _scraper.searchMedia(ext, script, query);
    }
    return [];
  }
}