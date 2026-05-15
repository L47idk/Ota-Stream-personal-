import 'package:flutter/material.dart';
import '../../services/download_service.dart';

class DownloadButton extends StatefulWidget {
  final bool isVideo; // true = anime video, false = manga chapter
  final String videoUrl; // Used if isVideo = true
  final String videoFileName;
  final List<String> chapterUrls; // Used if isVideo = false
  final String chapterFolderName;

  const DownloadButton({
    Key? key,
    this.isVideo = false,
    this.videoUrl = '',
    this.videoFileName = 'episode.mp4',
    this.chapterUrls = const [],
    this.chapterFolderName = 'chapter',
  }) : super(key: key);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool _isDownloading = false;
  double _progress = 0.0;
  bool _isDownloaded = false;

  void _startDownload() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    final downloadService = DownloadService(
      onProgress: (progress) {
        setState(() {
          _progress = progress;
        });
      },
    );

    try {
      if (widget.isVideo) {
        await downloadService.downloadVideo(widget.videoUrl, widget.videoFileName);
      } else {
        await downloadService.downloadChapter(widget.chapterUrls, widget.chapterFolderName);
      }

      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download completed successfully!')),
      );
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _progress = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDownloaded) {
      return const IconButton(
        icon: Icon(Icons.check_circle, color: Colors.green),
        onPressed: null,
      );
    }

    if (_isDownloading) {
      return SizedBox(
        width: 36,
        height: 36,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircularProgressIndicator(
            value: _progress,
            strokeWidth: 3.0,
            color: Colors.blueAccent,
            backgroundColor: Colors.grey[800],
          ),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.download, color: Colors.white),
      onPressed: _startDownload,
    );
  }
}
