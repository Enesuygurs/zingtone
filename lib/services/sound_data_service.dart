import '../models/sound_item.dart';

class SoundDataService {
  static SoundDataService? _instance;
  static SoundDataService get instance => _instance ??= SoundDataService._();
  
  SoundDataService._();

  // Sample data - In a real app, this would come from an API
  List<SoundItem> getSampleSounds() {
    return [
      // Ringtones
      SoundItem(
        id: '1',
        title: 'Classic Ring',
        description: 'Traditional phone ring sound',
        category: 'ringtone',
        url: 'https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand3.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/0066CC/FFFFFF?text=Ring',
        duration: 15,
        downloadCount: 1250,
        rating: 4.5,
      ),
      SoundItem(
        id: '2',
        title: 'Digital Beep',
        description: 'Modern digital beeping sound',
        category: 'ringtone',
        url: 'https://www.soundjay.com/misc/sounds/beep-07a.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/FF6600/FFFFFF?text=Beep',
        duration: 8,
        downloadCount: 890,
        rating: 4.2,
      ),
      SoundItem(
        id: '3',
        title: 'Nature Bell',
        description: 'Peaceful bell with nature sounds',
        category: 'ringtone',
        url: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/009900/FFFFFF?text=Bell',
        duration: 20,
        downloadCount: 1456,
        rating: 4.8,
      ),
      SoundItem(
        id: '4',
        title: 'Guitar Melody',
        description: 'Gentle acoustic guitar melody',
        category: 'ringtone',
        url: 'https://www.soundjay.com/misc/sounds/acoustic-guitar-1.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/CC6600/FFFFFF?text=Guitar',
        duration: 25,
        downloadCount: 2100,
        rating: 4.7,
      ),
      SoundItem(
        id: '5',
        title: 'Electronic Beat',
        description: 'Modern electronic beat',
        category: 'ringtone',
        url: 'https://www.soundjay.com/misc/sounds/electronic-1.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/9900CC/FFFFFF?text=Beat',
        duration: 18,
        downloadCount: 756,
        rating: 4.1,
      ),
      
      // Notifications
      SoundItem(
        id: '6',
        title: 'Gentle Chime',
        description: 'Soft notification chime',
        category: 'notification',
        url: 'https://www.soundjay.com/misc/sounds/chime-1.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/0099CC/FFFFFF?text=Chime',
        duration: 3,
        downloadCount: 3200,
        rating: 4.6,
      ),
      SoundItem(
        id: '7',
        title: 'Pop Sound',
        description: 'Quick pop notification',
        category: 'notification',
        url: 'https://www.soundjay.com/misc/sounds/pop-2.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/FF3366/FFFFFF?text=Pop',
        duration: 1,
        downloadCount: 1890,
        rating: 4.3,
      ),
      SoundItem(
        id: '8',
        title: 'Ding',
        description: 'Classic ding sound',
        category: 'notification',
        url: 'https://www.soundjay.com/misc/sounds/ding-1.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/FFCC00/FFFFFF?text=Ding',
        duration: 2,
        downloadCount: 2456,
        rating: 4.4,
      ),
      SoundItem(
        id: '9',
        title: 'Whistle',
        description: 'Short whistle notification',
        category: 'notification',
        url: 'https://www.soundjay.com/misc/sounds/whistle-1.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/33CC99/FFFFFF?text=Whistle',
        duration: 2,
        downloadCount: 1123,
        rating: 4.0,
      ),
      SoundItem(
        id: '10',
        title: 'Message Tone',
        description: 'Pleasant message notification',
        category: 'notification',
        url: 'https://www.soundjay.com/misc/sounds/message-1.wav',
        thumbnailUrl: 'https://via.placeholder.com/150/6699FF/FFFFFF?text=Message',
        duration: 4,
        downloadCount: 2890,
        rating: 4.5,
      ),
      
      // ✅ YENİ SES EKLEMESİ ÖRNEĞİ
      SoundItem(
        id: '11',
        title: 'Epic Beat',
        description: 'Powerful epic beat',
        category: 'ringtone', // 'ringtone' veya 'notification'
        url: 'https://your-audio-file-url.mp3', // Ses dosyası URL'i
        thumbnailUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?text=Epic',
        duration: 30, // Saniye cinsinden süre
        downloadCount: 0, // Başlangıç indirme sayısı
        rating: 5.0, // 0.0 - 5.0 arası puan
      ),
      SoundItem(
        id: '12',
        title: 'Soft Ding',
        description: 'Gentle notification sound',
        category: 'notification',
        url: 'https://your-notification-url.mp3',
        thumbnailUrl: 'https://via.placeholder.com/150/00FF00/FFFFFF?text=Soft',
        duration: 2,
        downloadCount: 0,
        rating: 4.8,
      ),
    ];
  }

  List<SoundItem> getRingtones() {
    return getSampleSounds().where((sound) => sound.category == 'ringtone').toList();
  }

  List<SoundItem> getNotifications() {
    return getSampleSounds().where((sound) => sound.category == 'notification').toList();
  }

  List<SoundItem> searchSounds(String query) {
    final allSounds = getSampleSounds();
    if (query.isEmpty) return allSounds;
    
    return allSounds.where((sound) =>
        sound.title.toLowerCase().contains(query.toLowerCase()) ||
        sound.description.toLowerCase().contains(query.toLowerCase()) ||
        sound.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
