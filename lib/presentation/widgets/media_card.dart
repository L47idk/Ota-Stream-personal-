// lib/presentation/widgets/media_card.dart

import 'package:flutter/material.dart';
import '../../domain/models/media_item.dart';

class MediaCard extends StatelessWidget {
  final MediaItem media;
  final VoidCallback onTap;

  const MediaCard({
    Key? key,
    required this.media,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Executes when the user taps the card
      child: Container(
        width: 120, // Fixed width for horizontal scrolling
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // Load the image from the network
                child: Image.network(
                  media.coverUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // Fallback if the image fails to load
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              media.title,
              maxLines: 2, // Limit to 2 lines
              overflow: TextOverflow.ellipsis, // Add '...' if text is too long
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}