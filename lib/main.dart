import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home.dart';
import 'screens/auth_screen.dart';
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
  bool _isAuthenticated = false;

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

  void _handleAuthenticated() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  void _handleSignOut() {
    setState(() {
      _isAuthenticated = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bookmarks Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _showIntro
          ? IntroScreen(onDonePress: _completeIntro)
          : _isAuthenticated
              ? HomeScaffold(onSignOut: _handleSignOut)
              : AuthScreen(onAuthenticated: _handleAuthenticated),
    );
  }
}

class IntroScreen extends StatelessWidget {
  final VoidCallback onDonePress;

  const IntroScreen({super.key, required this.onDonePress});

  @override
  Widget build(BuildContext context) {
    return ConcentricAnimationOnboarding(onDonePress: onDonePress);
  }
}

class ConcentricAnimationOnboarding extends StatelessWidget {
  final VoidCallback onDonePress;

  const ConcentricAnimationOnboarding({super.key, required this.onDonePress});

  static const List<PageData> pages = [
    PageData(
      icon: Icons.bookmark_add_outlined,
      title: 'Save the links you care about',
      subtitle: 'Tap the circle to move into the next slide.',
      bgColor: Color(0xFF3B1791),
      textColor: Colors.white,
    ),
    PageData(
      icon: Icons.account_tree_outlined,
      title: 'See them organized by topic',
      subtitle: 'Your bookmarks become a visual map of interests.',
      bgColor: Color(0xFFFAB800),
      textColor: Color(0xFF3B1790),
    ),
    PageData(
      icon: Icons.auto_awesome,
      title: 'Explore with AI insights',
      subtitle: 'Finish onboarding to open your dashboard.',
      bgColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF3B1790),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((page) => page.bgColor).toList(),
        itemCount: pages.length,
        onFinish: onDonePress,
        radius: screenWidth * 0.11,
        scaleFactor: 2,
        verticalPosition: 0.84,
        nextButtonBuilder: (context) => Container(
          width: screenWidth * 0.16,
          height: screenWidth * 0.16,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Icon(Icons.navigate_next, color: Color(0xFF3B1791)),
        ),
        itemBuilder: (index) {
          final page = pages[index];
          return SafeArea(
            child: _ConcentricPage(page: page),
          );
        },
      ),
    );
  }
}

class PageData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });
}

class _ConcentricPage extends StatelessWidget {
  final PageData page;

  const _ConcentricPage({required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final circleColor = page.textColor == Colors.white ? Colors.white : Colors.black;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
          ),
          child: Icon(
            page.icon,
            size: screenHeight * 0.11,
            color: page.bgColor,
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.035,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: page.textColor.withValues(alpha: 0.84),
              fontSize: screenHeight * 0.018,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeScaffold extends StatefulWidget {
  final VoidCallback onSignOut;

  const HomeScaffold({super.key, required this.onSignOut});

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
        body = ProfileScreen(onSignOut: widget.onSignOut);
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
