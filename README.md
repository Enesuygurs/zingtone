# ZingTone - Ringtones & Notification Sounds App

A beautiful Flutter mobile application for downloading and playing ringtones and notification sounds with AdMob integration.

## Features

🎵 **Sound Categories**
- Ringtones collection
- Notification sounds collection
- Search functionality
- Category filtering

🎧 **Audio Features**
- High-quality audio playback
- Play/pause controls
- Audio progress tracking
- Background audio support

📱 **Download & Storage**
- Download sounds to device
- Offline playback
- Manage downloaded files
- Delete unwanted sounds

💰 **Monetization**
- AdMob banner ads
- Interstitial ads after downloads
- Test ads implementation (ready for production IDs)

🎨 **User Interface**
- Modern Material Design
- Dark/Light theme support
- Smooth animations
- Responsive layout

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Android Studio / VS Code
- Android SDK for Android development
- Xcode for iOS development (Mac only)

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure AdMob**
   - Replace test AdMob IDs with your production IDs in:
     - `lib/services/ad_service.dart`
     - `android/app/src/main/AndroidManifest.xml`
     - `ios/Runner/Info.plist`

3. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### AdMob Setup

Replace test IDs with your production IDs before publishing:

In `lib/services/ad_service.dart`:
```dart
// Replace these test IDs with your production IDs
static const String _bannerAdUnitId = 'YOUR_BANNER_AD_UNIT_ID';
static const String _interstitialAdUnitId = 'YOUR_INTERSTITIAL_AD_UNIT_ID';
```

## Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Dependencies

- **audioplayers**: Audio playback functionality
- **http**: Network requests for downloading
- **path_provider**: File system access
- **permission_handler**: Runtime permissions
- **google_mobile_ads**: AdMob integration
- **cached_network_image**: Image caching
- **provider**: State management

**Note**: This app uses AdMob test IDs by default. Remember to replace them with your production IDs before publishing to app stores.
