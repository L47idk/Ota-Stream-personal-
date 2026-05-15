// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../presentation/home_screen.dart';
import '../presentation/search_screen.dart';
import '../presentation/media_details.dart';
import '../presentation/manga_reader_screen.dart';
import '../presentation/video_player_screen.dart';
import '../domain/models/media_item.dart';

class AppRoutes {
  // Define route name constants
  static const String home = '/';
  static const String search = '/search';
  static const String details = '/details';
  static const String reader = '/reader';
  static const String player = '/player';

  // Generate routes based on the requested route name
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case details:
        // Extract the MediaItem argument passed when navigating
        final mediaItem = settings.arguments as MediaItem;
        return MaterialPageRoute(
          builder: (_) => MediaDetailsScreen(mediaItem: mediaItem),
        );

      case reader:
        // Extract the chapter ID
        final chapterId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MangaReaderScreen(chapterId: chapterId),
        );

      case player:
        // Extract the video URL
        final videoUrl = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(videoUrl: videoUrl),
        );

      default:
        // Fallback route if something goes wrong
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}