// lib/presentation/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../routes/app_routes.dart';
import 'widgets/custom_search_bar.dart';
import 'widgets/loading_indicator.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MediaProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D12),
        elevation: 0,
        // Replace the usual title with our custom search bar
        title: CustomSearchBar(
          onSubmitted: (query) {
            // Trigger the search when the user hits Enter
            provider.searchMedia(query);
          },
        ),
      ),
      body: provider.isLoading
          ? const LoadingIndicator()
          : provider.searchResults.isEmpty
              ? const Center(
                  child: Text(
                    'Search for your favorite anime or manga!',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  // Grid setup: 3 items per row
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.65, // Adjusts height of items (width / height)
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, index) {
                    final media = provider.searchResults[index];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.details,
                        arguments: media,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          media.coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey[800]),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}