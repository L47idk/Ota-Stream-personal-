// lib/domain/repositories/media_repository.dart

import '../entities/media_item.dart';

abstract class MediaRepository {
  /// Fetches the current trending or popular media items.
  Future<List<MediaItem>> getTrendingItems();

  /// Searches for media items based on a query.
  Future<List<MediaItem>> searchItems(String query);

  /// Fetches detailed information for a specific media item.
  Future<MediaItem> getMediaDetails(String id, String sourceId);
}