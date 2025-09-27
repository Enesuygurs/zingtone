import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/sound_provider.dart';
import 'services/ad_service.dart';
import 'screens/home_screen.dart';
import 'screens/downloads_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AdMob only on mobile platforms (not web)
  if (!kIsWeb) {
    try {
      await AdService.instance.initialize();
    } catch (e) {
      debugPrint('AdMob initialization failed: $e');
    }
  }
  
  runApp(const ZingToneApp());
}

class ZingToneApp extends StatelessWidget {
  const ZingToneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SoundProvider()),
      ],
      child: MaterialApp(
        title: 'ZingTone - Ringtones & Notifications',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
        routes: {
          '/downloads': (context) => const DownloadsScreen(),
        },
      ),
    );
  }
}
