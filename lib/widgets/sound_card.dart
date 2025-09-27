import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/sound_item.dart';
import '../providers/sound_provider.dart';
import '../services/ad_service.dart';

class SoundCard extends StatelessWidget {
  final SoundItem sound;

  const SoundCard({super.key, required this.sound});

  @override
  Widget build(BuildContext context) {
    return Consumer<SoundProvider>(
      builder: (context, provider, child) {
        final isPlaying = provider.currentlyPlayingId == sound.id;
        final isDownloaded = provider.isSoundDownloaded(sound);
        final isDownloading = provider.downloadingId == sound.id;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: sound.thumbnailUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.music_note, size: 30),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.music_note, size: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Title and duration info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sound.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${sound.duration}s',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.download,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${sound.downloadCount}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action buttons - only icons (bigger)
                Row(
                  children: [
                    // Play/Stop button
                    IconButton(
                      onPressed: () => provider.playSound(sound),
                      icon: Icon(
                        isPlaying ? Icons.stop_circle : Icons.play_circle,
                        size: 48,
                        color: isPlaying ? Colors.red : Colors.blue,
                      ),
                      iconSize: 48,
                      padding: const EdgeInsets.all(8),
                    ),
                    const SizedBox(width: 12),
                    
                    // Download button
                    if (isDownloading)
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: provider.downloadProgress,
                              strokeWidth: 4,
                            ),
                            Text(
                              '${(provider.downloadProgress * 100).toInt()}%',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    else
                      IconButton(
                        onPressed: isDownloaded
                            ? null
                            : () async {
                                final success = await provider.downloadSound(sound);
                                if (!success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Download failed'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else if (success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Download completed!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // Show interstitial ad after download
                                  AdService.instance.showInterstitialAd();
                                }
                              },
                        icon: Icon(
                          isDownloaded ? Icons.check_circle : Icons.download_for_offline,
                          size: 48,
                          color: isDownloaded ? Colors.green : Colors.orange,
                        ),
                        iconSize: 48,
                        padding: const EdgeInsets.all(8),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
