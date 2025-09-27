import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static AdService? _instance;
  static AdService get instance => _instance ??= AdService._();
  
  AdService._();

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoaded = false;
  
  // Test Ad Unit IDs - Replace with your own
  static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint('AdMob is not supported on web platform');
      return;
    }
    
    try {
      await MobileAds.instance.initialize();
      _loadBannerAd();
      _loadInterstitialAd();
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => debugPrint('Banner ad loaded'),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
          
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd(); // Load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _isInterstitialLoaded = false;
        },
      ),
    );
  }

  BannerAd? get bannerAd => _bannerAd;

  void showInterstitialAd() {
    if (_isInterstitialLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      _isInterstitialLoaded = false;
    }
  }

  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}
