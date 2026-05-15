import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';

class GlobalSearchScreen extends ConsumerWidget {
  final TextEditingController _searchController = TextEditingController();

  GlobalSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Allows us to passively read state for rendering
    final searchState = ref.watch(searchProvider);
    // Provides access to mutating commands inside provider
    final searchNotifier = ref.read(searchProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'manga', label: Text('Manga & Manhwa')),
                ButtonSegment(value: 'anime', label: Text('Anime')),
              ],
              selected: {searchState.category},
              onSelectionChanged: (Set<String> newSelection) {
                // Segment boundary change triggers re-search of existing query but on new app scripts
                searchNotifier.setCategory(newSelection.first);
                if (_searchController.text.isNotEmpty) {
                  searchNotifier.search(_searchController.text);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search across 100+ sources...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) => searchNotifier.search(value),
              textInputAction: TextInputAction.search,
            ),
          ),
          const SizedBox(height: 8),

          // Render Results or States
          Expanded(
            child: searchState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchState.results.isEmpty && _searchController.text.isNotEmpty
                    ? const Center(child: Text('No results found across installed sources.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Desktop can change this parameter
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: searchState.results.length,
                        itemBuilder: (context, index) {
                          final item = searchState.results[index];

                          return Card(
                            elevation: 4,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Media Cover
                                if (item.imageUrl.isNotEmpty)
                                  Image.network(
                                    item.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade900, child: const Icon(Icons.broken_image)),
                                  )
                                else
                                  Container(color: Colors.grey.shade900, child: const Icon(Icons.image, size: 50)),

                                // Elegant gradient overlay
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black87],
                                      stops: [0.5, 1.0],
                                    ),
                                  ),
                                ),

                                // Information overlay
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  right: 8,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          item.sourceName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}