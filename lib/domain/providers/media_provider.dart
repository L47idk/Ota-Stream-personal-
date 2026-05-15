// lib/presentation/providers/media_provider.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/usecases/get_trending_items.dart';

class MediaProvider with ChangeNotifier {
  final GetTrendingItems getTrendingItemsUseCase;

  List<MediaItem> _trendingItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  MediaProvider({required this.getTrendingItemsUseCase});

  // Getters
  List<MediaItem> get trendingItems => _trendingItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch trending items and update the UI state
  Future<void> fetchTrendingItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trendingItems = await getTrendingItemsUseCase.execute();
    } catch (e) {
      _errorMessage = "Failed to load trending items: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}