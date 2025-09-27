class SoundItem {
  final String id;
  final String title;
  final String description;
  final String category; // 'ringtone' or 'notification'
  final String url;
  final String thumbnailUrl;
  final int duration; // in seconds
  final int downloadCount;
  final double rating;

  SoundItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.url,
    required this.thumbnailUrl,
    required this.duration,
    this.downloadCount = 0,
    this.rating = 0.0,
  });

  factory SoundItem.fromJson(Map<String, dynamic> json) {
    return SoundItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'ringtone',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      duration: json['duration'] ?? 0,
      downloadCount: json['downloadCount'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'downloadCount': downloadCount,
      'rating': rating,
    };
  }
}
