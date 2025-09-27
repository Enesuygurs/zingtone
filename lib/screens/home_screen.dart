import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';
import '../widgets/sound_card.dart';
import '../widgets/banner_ad_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    final provider = Provider.of<SoundProvider>(context, listen: false);
    switch (_tabController.index) {
      case 0:
        provider.setCategory('all');
        break;
      case 1:
        provider.setCategory('ringtone');
        break;
      case 2:
        provider.setCategory('notification');
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: const Text(
            'ZingTone',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.2,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search sounds...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              Provider.of<SoundProvider>(context, listen: false)
                                  .setSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    Provider.of<SoundProvider>(context, listen: false)
                        .setSearchQuery(value);
                  },
                ),
              ),
              // Tab bar
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'All Sounds'),
                  Tab(text: 'Ringtones'),
                  Tab(text: 'Notifications'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Banner ad
          const BannerAdWidget(),
          
          // Content
          Expanded(
            child: Consumer<SoundProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.sounds.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No sounds found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    // Refresh sounds (in a real app, this would fetch from API)
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.sounds.length,
                    itemBuilder: (context, index) {
                      return SoundCard(sound: provider.sounds[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/downloads');
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.download, color: Colors.white),
      ),
    );
  }
}
