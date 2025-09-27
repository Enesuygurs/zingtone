import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound_item.dart';
import '../services/sound_data_service.dart';
import '../services/audio_service.dart';
import '../services/download_service.dart';

class SoundProvider with ChangeNotifier {
  final SoundDataService _soundDataService = SoundDataService.instance;
  final AudioService _audioService = AudioService.instance;
  final DownloadService _downloadService = DownloadService.instance;

  List<SoundItem> _sounds = [];
  List<SoundItem> _filteredSounds = [];
  List<String> _downloadedFiles = [];
  String _currentCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _currentlyPlayingId;
  double _downloadProgress = 0.0;
  String? _downloadingId;

  List<SoundItem> get sounds => _filteredSounds;
  List<String> get downloadedFiles => _downloadedFiles;
  String get currentCategory => _currentCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get currentlyPlayingId => _currentlyPlayingId;
  double get downloadProgress => _downloadProgress;
  String? get downloadingId => _downloadingId;

  SoundProvider() {
    _loadSounds();
    _loadDownloadedFiles();
    _setupAudioListener();
  }

  void _setupAudioListener() {
    _audioService.playerStateStream.listen((state) {
      if (state == PlayerState.stopped || state == PlayerState.completed) {
        _currentlyPlayingId = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadSounds() async {
    _isLoading = true;
    notifyListeners();

    try {
      _sounds = _soundDataService.getSampleSounds();
      _filterSounds();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDownloadedFiles() async {
    _downloadedFiles = await _downloadService.getDownloadedSounds();
    notifyListeners();
  }

  void _filterSounds() {
    List<SoundItem> filtered = _sounds;

    // Filter by category
    if (_currentCategory != 'all') {
      filtered = filtered.where((sound) => sound.category == _currentCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((sound) =>
          sound.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sound.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    _filteredSounds = filtered;
    notifyListeners();
  }

  void setCategory(String category) {
    _currentCategory = category;
    _filterSounds();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterSounds();
  }

  Future<void> playSound(SoundItem sound) async {
    if (_currentlyPlayingId == sound.id) {
      await _audioService.stopSound();
      _currentlyPlayingId = null;
    } else {
      await _audioService.playSound(sound.url, isUrl: true);
      _currentlyPlayingId = sound.id;
    }
    notifyListeners();
  }

  Future<void> stopSound() async {
    await _audioService.stopSound();
    _currentlyPlayingId = null;
    notifyListeners();
  }

  Future<bool> downloadSound(SoundItem sound) async {
    _downloadingId = sound.id;
    _downloadProgress = 0.0;
    notifyListeners();

    try {
      final filePath = await _downloadService.downloadSound(
        sound,
        (progress) {
          _downloadProgress = progress;
          notifyListeners();
        },
      );

      if (filePath != null) {
        await _loadDownloadedFiles();
        return true;
      }
      return false;
    } finally {
      _downloadingId = null;
      _downloadProgress = 0.0;
      notifyListeners();
    }
  }

  Future<bool> deleteDownloadedSound(String filePath) async {
    final success = await _downloadService.deleteSound(filePath);
    if (success) {
      await _loadDownloadedFiles();
    }
    return success;
  }

  Future<void> playDownloadedSound(String filePath) async {
    await _audioService.playSound(filePath, isUrl: false);
    _currentlyPlayingId = filePath;
    notifyListeners();
  }

  bool isSoundDownloaded(SoundItem sound) {
    return _downloadedFiles.any((file) => file.contains(sound.id));
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
