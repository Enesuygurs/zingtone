import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';
import '../services/download_service.dart';
import '../widgets/banner_ad_widget.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Downloads',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Banner ad
          const BannerAdWidget(),
          
          // Content
          Expanded(
            child: Consumer<SoundProvider>(
              builder: (context, provider, child) {
                if (provider.downloadedFiles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No downloads yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Download some sounds to see them here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.explore),
                          label: const Text('Explore Sounds'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.downloadedFiles.length,
                  itemBuilder: (context, index) {
                    final filePath = provider.downloadedFiles[index];
                    final fileName = DownloadService.instance.getFileNameFromPath(filePath);
                    final isCurrentlyPlaying = provider.currentlyPlayingId == filePath;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            isCurrentlyPlaying ? Icons.pause : Icons.music_note,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          fileName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Tap to play • Long press for options',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                isCurrentlyPlaying ? Icons.stop : Icons.play_arrow,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () {
                                if (isCurrentlyPlaying) {
                                  provider.stopSound();
                                } else {
                                  provider.playDownloadedSound(filePath);
                                }
                              },
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                switch (value) {
                                  case 'delete':
                                    final shouldDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Sound'),
                                        content: Text(
                                          'Are you sure you want to delete "$fileName"?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (shouldDelete == true) {
                                      final success = await provider.deleteDownloadedSound(filePath);
                                      if (success && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Sound deleted'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    }
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          if (isCurrentlyPlaying) {
                            provider.stopSound();
                          } else {
                            provider.playDownloadedSound(filePath);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
