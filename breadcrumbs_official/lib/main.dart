import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home.dart';
import 'screens/likes.dart';
import 'screens/profile.dart';
import 'screens/search.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  runApp(MyApp(initialFirstLaunch: isFirstLaunch));
}

class MyApp extends StatefulWidget {
  final bool initialFirstLaunch;

  const MyApp({super.key, this.initialFirstLaunch = true});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _showIntro;

  @override
  void initState() {
    super.initState();
    _showIntro = widget.initialFirstLaunch;
  }

  Future<void> _completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    if (!mounted) {
      return;
    }
    setState(() {
      _showIntro = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bookmarks Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _showIntro
          ? IntroScreen(onDonePress: _completeIntro)
          : const HomeScaffold(),
    );
  }
}

class IntroScreen extends StatelessWidget {
  final VoidCallback onDonePress;

  const IntroScreen({super.key, required this.onDonePress});

  @override
  Widget build(BuildContext context) {
    final slides = [
      ContentConfig(
        title: 'Welcome to Breadcrumbs',
        description: 'Save links and ideas so they are always easy to find.',
        backgroundColor: const Color(0xFF4C5BA6),
        styleTitle: const TextStyle(color: Colors.white, fontSize: 30),
        styleDescription: const TextStyle(color: Colors.white70, fontSize: 18),
      ),
      ContentConfig(
        title: 'Organize Faster',
        description: 'Group bookmarks by interest and discover them instantly.',
        backgroundColor: const Color(0xFF8A4AA8),
        styleTitle: const TextStyle(color: Colors.white, fontSize: 30),
        styleDescription: const TextStyle(color: Colors.white70, fontSize: 18),
      ),
      ContentConfig(
        title: 'Ready to Explore?',
        description: 'Tap DONE to open your dashboard.',
        backgroundColor: const Color(0xFFCE5D8D),
        styleTitle: const TextStyle(color: Colors.white, fontSize: 30),
        styleDescription: const TextStyle(color: Colors.white70, fontSize: 18),
      ),
    ];

    return IntroSlider(
      key: const ValueKey('intro_slider'),
      listContentConfig: slides,
      renderNextBtn: const Text('NEXT'),
      renderDoneBtn: const Text('DONE'),
      renderSkipBtn: const Text('SKIP'),
      onDonePress: onDonePress,
      onSkipPress: onDonePress,
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
    const accent = Color.fromARGB(255, 77, 67, 162);

    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = const HomeScreen();
        break;
      case 1:
        body = const LikesScreen();
        break;
      case 2:
        body = const SearchScreen();
        break;
      default:
        body = const ProfileScreen();
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color.fromARGB(255, 104, 14, 92),
        unselectedItemColor: const Color.fromARGB(179, 122, 114, 158),
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
