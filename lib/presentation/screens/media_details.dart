// lib/presentation/media_details.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/models/media_item.dart';
import '../providers/media_provider.dart';
import '../routes/app_routes.dart';
import 'widgets/loading_indicator.dart';

class MediaDetailsScreen extends StatefulWidget {
  final MediaItem mediaItem;

  const MediaDetailsScreen({Key? key, required this.mediaItem}) : super(key: key);

  @override
  _MediaDetailsScreenState createState() => _MediaDetailsScreenState();
}

class _MediaDetailsScreenState extends State<MediaDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the list of chapters/episodes for this specific item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MediaProvider>().fetchMediaDetails(widget.mediaItem.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MediaProvider>();
    final media = widget.mediaItem;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      // CustomScrollView allows us to have a scrolling image that shrinks into a toolbar
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                media.coverUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: provider.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: LoadingIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          media.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          media.description ?? 'No description available for this item.',
                          style: const TextStyle(color: Colors.grey, height: 1.5),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Chapters / Episodes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // List of episodes
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = provider.chapters[index];
                            return ListTile(
                              title: Text(
                                chapter.title ?? 'Chapter/Episode ${chapter.number}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              tileColor: const Color(0xFF1E1E24),
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              trailing: const Icon(Icons.play_arrow, color: Colors.purpleAccent),
                              onTap: () {
                                if (media.type == 'manga') {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.reader,
                                    arguments: chapter.id,
                                  );
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.player,
                                    arguments: 'https://www.w3schools.com/html/mov_bbb.mp4', // demo URL
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}