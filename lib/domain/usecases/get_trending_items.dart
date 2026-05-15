// lib/domain/usecases/get_trending_items.dart

import '../entities/media_item.dart';
import '../repositories/media_repository.dart';

class GetTrendingItems {
  final MediaRepository repository;

  GetTrendingItems(this.repository);

  Future<List<MediaItem>> execute() async {
    try {
      return await repository.getTrendingItems();
    } catch (e) {
      // You can add custom error wrapping/handling here if needed
      rethrow;
    }
  }
}