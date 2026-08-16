import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

const _items = [
  {'title': 'article on pandas', 'h': 150.0, 'color': Color(0xFF6672AA)},
  {'title': 'docs page on chemistry', 'h': 100.0, 'color': Color(0xFF6672AA)},
  {'title': 'youtube video on baby penguins', 'h': 92.0, 'color': Color(0xFF6672AA)},
  {'title': 'article on how to fix your phone', 'h': 92.0, 'color': Color(0xFF6672AA)},
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bookmarks Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
      ),
      home: const HomeScaffold(),
    );
  }
}

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final accent = const Color.fromARGB(255, 77, 67, 162);

    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = const MasonryGrid();
        break;
      case 1:
        body = const Center(child: Text('Likes'));
        break;
      case 2:
        body = const Center(child: Text('Search'));
        break;
      default:
        body = const Center(child: Text('Profile'));
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: const Color.fromARGB(255, 104, 14, 92),
        unselectedItemColor: const Color.fromARGB(179, 122, 114, 158),
        // use a container to give the bar a background matching the design
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            selectedColor: accent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text('Likes'),
            selectedColor: accent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.grid_view),
            title: const Text('Explore'),
            selectedColor: accent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
            selectedColor: accent,
          ),
        ],
      ),
    );
  }
}

class MasonryGrid extends StatelessWidget {
  const MasonryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const spacing = 16.0;
    final bg = const Color(0xFFF9EAF0);
    final cardColor = const Color(0xFF6672AA);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weekly Bookmarks',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white)),
                            const SizedBox(height: 12),
                            for (var t in _items)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text('• ${t['title']}',
                                    style: const TextStyle(
                                        color: Colors.white, height: 1.4)),
                              ),
                            const SizedBox(height: 8),
                            Text('see more on analytics',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: spacing),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          // Circular progress
                          Container(
                            height: 140,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: CircularProgressIndicator(
                                    value: 0.67,
                                    strokeWidth: 14,
                                    backgroundColor: cardColor.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation(const Color(0xFFE996C8)),
                                  ),
                                ),
                                Text('67%', style: Theme.of(context).textTheme.headlineSmall),
                              ],
                            ),
                          ),
                          const SizedBox(height: spacing),
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacing),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                      child: Text('Weekly Bookmarks',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white))),
                ),
                const SizedBox(height: spacing * 1.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
