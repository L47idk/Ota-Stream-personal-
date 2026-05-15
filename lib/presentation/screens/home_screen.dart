// lib/presentation/manga_reader_screen.dart

import 'package:flutter/material.dart';

class MangaReaderScreen extends StatelessWidget {
  final String chapterId;

  const MangaReaderScreen({Key? key, required this.chapterId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // In a real app, you would fetch real image URLs based on the chapterId
    // We'll use mock placeholder images for now
    final mockImages = [
      'https://via.placeholder.com/800x1200.png?text=Page+1',
      'https://via.placeholder.com/800x1200.png?text=Page+2',
      'https://via.placeholder.com/800x1200.png?text=Page+3',
    ];

    return Scaffold(
      backgroundColor: Colors.black, // Reader background should always be dark
      appBar: AppBar(
        title: Text('Reading Chapter'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: mockImages.length,
        itemBuilder: (context, index) {
          return Image.network(
            mockImages[index],
            fit: BoxFit.contain, // Ensures the image fits correctly
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator(color: Colors.grey)),
              );
            },
          );
        },
      ),
    );
  }
}