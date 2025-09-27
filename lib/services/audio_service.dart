import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioService? _instance;
  static AudioService get instance => _instance ??= AudioService._();
  
  AudioService._();

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlaying;
  bool _isPlaying = false;

  AudioPlayer get audioPlayer => _audioPlayer;
  String? get currentlyPlaying => _currentlyPlaying;
  bool get isPlaying => _isPlaying;

  Future<void> playSound(String soundPath, {bool isUrl = false}) async {
    try {
      await _audioPlayer.stop();
      
      if (isUrl) {
        await _audioPlayer.play(UrlSource(soundPath));
      } else {
        await _audioPlayer.play(DeviceFileSource(soundPath));
      }
      
      _currentlyPlaying = soundPath;
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> pauseSound() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error pausing sound: $e');
    }
  }

  Future<void> resumeSound() async {
    try {
      await _audioPlayer.resume();
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error resuming sound: $e');
    }
  }

  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
      _currentlyPlaying = null;
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error stopping sound: $e');
    }
  }

  Future<Duration?> getDuration() async {
    try {
      return await _audioPlayer.getDuration();
    } catch (e) {
      debugPrint('Error getting duration: $e');
      return null;
    }
  }

  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;
  Stream<PlayerState> get playerStateStream => _audioPlayer.onPlayerStateChanged;

  void dispose() {
    _audioPlayer.dispose();
  }
}
