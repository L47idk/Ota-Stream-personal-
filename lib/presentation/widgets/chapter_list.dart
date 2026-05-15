import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'download_button.dart';

class EpisodeList extends StatelessWidget {
  final List<dynamic> episodes; // Replace dynamic with actual Episode model
  final String animeTitle;

  const EpisodeList({
    Key? key,
    required this.episodes,
    required this.animeTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const Center(child: Text('No episodes available.'));
    }

    return ListView.builder(
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];
        final title = episode['title'] ?? 'Episode ${index + 1}';
        final episodeId = episode['id'];

        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.videoPlayer, arguments: episodeId);
          },
          leading: const Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 36),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          subtitle: Text('Episode ${index + 1}', style: const TextStyle(color: Colors.grey)),
          trailing: DownloadButton(
            isVideo: true,
            videoUrl: 'https://archive.org/download/BigBuckBunny_124/Content/big_buck_bunny_720p_surround.mp4', // Real app would resolve stream URL
            videoFileName: '${animeTitle.replaceAll(' ', '_')}_ep${index + 1}.mp4',
          ),
        );
      },
    );
  }
}
