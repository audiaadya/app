import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth_screen.dart';
import 'screens/home.dart';
import 'screens/likes.dart';
import 'screens/profile.dart';
import 'screens/search.dart';
import 'services/appwrite_service.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppwriteService.configureClient();

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
  bool _isCheckingAuth = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _showIntro = widget.initialFirstLaunch;
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      await AppwriteService.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _isAuthenticated = true;
        _isCheckingAuth = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isAuthenticated = false;
        _isCheckingAuth = false;
      });
    }
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
    if (_showIntro) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bookmarks Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: IntroScreen(onDonePress: _completeIntro),
      );
    }

    if (_isCheckingAuth) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bookmarks Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bookmarks Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _isAuthenticated
          ? const HomeScaffold()
          : AuthScreen(
              onAuthenticated: () {
                setState(() {
                  _isAuthenticated = true;
                  _isCheckingAuth = false;
                });
              },
            ),
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


final pages = [
  const PageData(
    icon: Icons.food_bank_outlined,
    title: "Compile your list of bookmarks through your browser",
    bgColor: Color(0xff3b1791),
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.shopping_bag_outlined,
    title: "Add it to cart",
    bgColor: Color(0xfffab800),
    textColor: Color(0xff3b1790),
  ),
  const PageData(
    icon: Icons.delivery_dining,
    title: "Order and wait",
    bgColor: Color(0xffffffff),
    textColor: Color(0xff3b1790),
  ),
];

class ConcentricAnimationOnboarding extends StatelessWidget {
  const ConcentricAnimationOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3), // visual center
          child: Icon(Icons.navigate_next, size: screenWidth * 0.08),
        ),
        // enable itemcount to disable infinite scroll
        // itemCount: pages.length,
        // opacityFactor: 2.0,
        scaleFactor: 2,
        // verticalPosition: 0.7,
        // direction: Axis.vertical,
        // itemCount: pages.length,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(child: _Page(page: page));
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: page.textColor,
          ),
          child: Icon(page.icon, size: screenHeight * 0.1, color: page.bgColor),
        ),
        Text(
          page.title ?? "",
          style: TextStyle(
            color: page.textColor,
            fontSize: screenHeight * 0.035,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/*

final pages = [
  const PageData(
    icon: Icons.food_bank_outlined,
    title: 'Compile your list of bookmarks through your browser',
    bgColor: Color.fromARGB(255, 96, 131, 185),
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.shopping_bag_outlined,
    title: 'Sync it to the app to see real time data about your interests',
    bgColor: Color.fromARGB(255, 71, 74, 109),
    textColor: Color(0xff3b1790),
  ),
  const PageData(
    icon: Icons.delivery_dining,
    title: 'Review and save your favorites',
    bgColor: Color.fromARGB(255, 92, 60, 115),
    textColor: Color.fromARGB(255, 255, 255, 255),
  ),
  const PageData(
    icon: Icons.check_circle_outline,
    title: 'Order and wait',
    bgColor: Color.fromARGB(255, 170, 103, 170),
    textColor: Color.fromARGB(255, 255, 255, 255),
  ),
];

class ConcentricAnimationOnboarding extends StatefulWidget {
  final VoidCallback onDonePress;

  const ConcentricAnimationOnboarding({super.key, required this.onDonePress});

  @override
  State<ConcentricAnimationOnboarding> createState() =>
      _ConcentricAnimationOnboardingState();
}

class _ConcentricAnimationOnboardingState
    extends State<ConcentricAnimationOnboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final nextIndex = _currentPage + 1;
    if (nextIndex < pages.length) {
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      return;
    }

    widget.onDonePress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final page = pages[index];
          return _Page(page: page);
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _currentPage == 0
                    ? null
                    : () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                child: const Text('Back'),
              ),
              Row(
                children: List.generate(pages.length, (index) {
                  final active = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: active ? 18 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: active ? Colors.deepPurple : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }),
              ),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text(_currentPage == pages.length - 1 ? 'Done' : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: page.bgColor,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: page.textColor,
            ),
            child: Icon(page.icon, size: screenHeight * 0.1, color: page.bgColor),
          ),
          const SizedBox(height: 24),
          Text(
            page.title ?? '',
            style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.035,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
