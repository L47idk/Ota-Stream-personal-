import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

// Assuming an Isar DB service or similar is injected/used here
class DownloadService {
  final Dio _dio = Dio();

  // Example callbacks for UI updates
  Function(double)? onProgress;

  DownloadService({this.onProgress});

  /// Downloads a list of images (Manga Chapter) into a specific local folder
  Future<void> downloadChapter(List<String> imageUrls, String folderName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final chapterDir = Directory('${dir.path}/downloads/manga/$folderName');

      if (!await chapterDir.exists()) {
        await chapterDir.create(recursive: true);
      }

      int downloadedCount = 0;
      int totalImages = imageUrls.length;

      for (int i = 0; i < totalImages; i++) {
        final url = imageUrls[i];
        // Create a basic filename like 001.jpg
        final fileName = '${(i + 1).toString().padLeft(3, '0')}.jpg';
        final savePath = '${chapterDir.path}/$fileName';

        await _dio.download(url, savePath);

        downloadedCount++;
        if (onProgress != null) {
          onProgress!(downloadedCount / totalImages);
        }
      }

      // TODO: Save the local path (chapterDir.path) to Isar database
      // e.g. await isarDb.saveChapterDownload(folderName, chapterDir.path);
      print('Chapter Downloaded to: ${chapterDir.path}');

    } catch (e) {
      print('Error downloading chapter: $e');
      rethrow;
    }
  }

  /// Downloads an Anime Video (mp4) into the documents directory
  Future<void> downloadVideo(String videoUrl, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final videoDir = Directory('${dir.path}/downloads/anime');

      if (!await videoDir.exists()) {
        await videoDir.create(recursive: true);
      }

      final savePath = '${videoDir.path}/$fileName';

      await _dio.download(
        videoUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress!(received / total);
          }
        },
      );

      // TODO: Save the local path (savePath) to Isar database
      // e.g. await isarDb.saveVideoDownload(fileName, savePath);
      print('Video Downloaded to: $savePath');

    } catch (e) {
      print('Error downloading video: $e');
      rethrow;
    }
  }
}
