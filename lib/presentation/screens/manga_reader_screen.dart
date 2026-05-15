// lib/presentation/manga_reader_screen.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MangaReaderScreen extends StatelessWidget {
  final String chapterId;

  const MangaReaderScreen({Key? key, required this.chapterId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mockImages = List.generate(
      100,
      (index) => 'https://via.placeholder.com/800x1200.png?text=Page+${index + 1}'
    );

    // Calculate maximum image width based on the device screen width
    // This tells the image decoder to downscale images before loading them into RAM
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final screenWidth = MediaQuery.of(context).size.width;
    final cacheWidth = (screenWidth * devicePixelRatio).round();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Reading Chapter'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      // OPTIMIZATION: Isolate the scrollable reader from the AppBar
      body: RepaintBoundary(
        child: ListView.builder(
          itemCount: mockImages.length,
          // OPTIMIZATION: Throw away widget state for off-screen pages immediately
          addAutomaticKeepAlives: false,
          itemBuilder: (context, index) {

            // OPTIMIZATION: Use CachedNetworkImage to prevent redownloading pages and manage disk
            return CachedNetworkImage(
              imageUrl: mockImages[index],
              fit: BoxFit.contain,

              // CRITICAL RAM OPTIMIZATION: memCacheWidth
              // Downscales the native 4K web image into a 1080p memory texture preventing OOMs over 100 pages.
              memCacheWidth: cacheWidth,
              placeholder: (context, url) => const SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator(color: Colors.grey)),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.grey, size: 50),
                      SizedBox(height: 8),
                      Text("Failed to load page", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}