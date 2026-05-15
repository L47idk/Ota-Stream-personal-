// lib/domain/entities/media_item.dart

class MediaItem {
  final String id;
  final String title;
  final String coverUrl;
  final String type; // e.g., 'manga' or 'anime'
  final String sourceId;
  final String? description;
  final String? status;
  final double? rating;

  const MediaItem({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.type,
    required this.sourceId,
    this.description,
    this.status,
    this.rating,
  });

  // Basic copyWith method for immutability
  MediaItem copyWith({
    String? id,
    String? title,
    String? coverUrl,
    String? type,
    String? sourceId,
    String? description,
    String? status,
    double? rating,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      type: type ?? this.type,
      sourceId: sourceId ?? this.sourceId,
      description: description ?? this.description,
      status: status ?? this.status,
      rating: rating ?? this.rating,
    );
  }
}