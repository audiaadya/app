import 'package:flutter/material.dart';

import 'focus_sprint.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});

  static const categories = <_Category>[
    _Category(
      title: 'School & Access',
      items: ['♡ classlink'],
      minutesSpent: '42',
    ),
    _Category(
      title: 'General Math Resources',
      items: ['♡ Calculus Primer'],
      minutesSpent: '85',
    ),
    _Category(
      title: 'Personal Websites / Blogs',
      items: ['♡ Kevin Zhou'],
      minutesSpent: '31',
    ),
    _Category(
      title: 'General Physics Resources',
      items: [
        '♡ Physics Packet Unit 5',
        '♡ Physics Olympiad',
        '♡ Kevin Zhou (2x IPHO gold from US) on JEE system',
      ],
      minutesSpent: '127',
    ),
    _Category(
      title: 'Mathematics Competitions',
      items: [
        '♡ 2025 AMC 12A Problems/Problem 5 - AoPS Wiki',
        '♡ How to Apply - Math Prize for Girls',
        '♡ Getting Started | USA Mathematical Talent Search',
      ],
      minutesSpent: '96',
    ),
    _Category(
      title: 'Other Academic Competitions',
      items: ['♡ International Mathematics Olympiad 2026'],
      minutesSpent: '54',
    ),
    _Category(
      title: 'Learning Platforms / EdTech',
      items: ['♡ Our Story | Stellar Learning'],
      minutesSpent: '73',
    ),
    _Category(
      title: 'Robotics & Programming',
      items: [
        '♡ PROS First Time Users Guide — PROS for V5 3.8.0 documentation',
        '♡ vex pros - YouTube',
      ],
      minutesSpent: '112',
    ),
    _Category(
      title: 'AP Study Materials',
      items: [
        '♡ AP Biology Penguins - Home',
        '♡ AP Statistics Exam Style Questions | IITian Academy',
        '♡ Science with Austin - NEW UPDATED AP BIO RESOURCES',
      ],
      minutesSpent: '68',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF9EAF0);
    const headerColor = Color(0xFF6672AA);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '''You've already added your generated goals to your goals page!''',
              ),
            ),
          );
        },
        backgroundColor: headerColor,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text(
          'Export AI Generated Goals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final leftPanel = _BookmarksPanel(
                  categories: categories,
                  headerColor: headerColor,
                );
                final rightPanel = _AnalyticsPanel(
                  categories: categories,
                  cardColor: headerColor,
                );

                if (constraints.maxWidth >= 800) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: leftPanel),
                        const SizedBox(width: 16),
                        Expanded(child: rightPanel),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      leftPanel,
                      const SizedBox(height: 24),
                      rightPanel,
                    ],
                  ),
                );
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: const _InsightsSuggestionButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarksPanel extends StatelessWidget {
  final List<_Category> categories;
  final Color headerColor;

  const _BookmarksPanel({required this.categories, required this.headerColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PanelHeader(title: 'Your Saved Bookmarks', color: headerColor),
        const SizedBox(height: 16),
        ...categories.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _CategoryCard(
              category: entry.value,
              color: entry.key.isEven
                  ? headerColor
                  : headerColor.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightsSuggestionButton extends StatefulWidget {
  const _InsightsSuggestionButton();

  @override
  State<_InsightsSuggestionButton> createState() =>
      _InsightsSuggestionButtonState();
}

class _InsightsSuggestionButtonState extends State<_InsightsSuggestionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: _isHovered ? 330 : 50,
        constraints: const BoxConstraints(minHeight: 50),
        padding: EdgeInsets.symmetric(
          horizontal: _isHovered ? 16 : 0,
          vertical: _isHovered ? 12 : 0,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 130, 75, 120),
          borderRadius: BorderRadius.circular(_isHovered ? 16 : 25),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: _isHovered
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Based off the physics resources you saved last week, you should check out:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.45,
                      ),
                      children: const [
                        TextSpan(text: '• '),
                        TextSpan(
                          text: 'this physics article from Kevin Zhou',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(text: '\n• '),
                        TextSpan(
                          text: 'this kinematics packet',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
                size: 24,
              ),
      ),
    );
  }
}

class _AnalyticsPanel extends StatefulWidget {
  final List<_Category> categories;
  final Color cardColor;

  const _AnalyticsPanel({required this.categories, required this.cardColor});

  @override
  State<_AnalyticsPanel> createState() => _AnalyticsPanelState();
}

class _AnalyticsPanelState extends State<_AnalyticsPanel> {
  int _expandedIndex = -1;

  static const analyticsCardColor = Color(0xFFE4D4E3);

  // Function to trigger Focus Sprint Mode when the arrow is clicked
  void _startFocusSprint(BuildContext context, String categoryTitle) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFE8E1EC),
        title: Text(
          'Focus Sprint: $categoryTitle',
          style: TextStyle(
            color: widget.cardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Launching active session timer, ambient background frequencies, and distraction lock-out for "$categoryTitle". Ready to start your deep work session?',
          style: const TextStyle(color: Colors.black87, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.cardColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      FocusSprintScreen(categoryTitle: categoryTitle),
                ),
              );
            },
            child: const Text('Start Sprint'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final columns = constraints.maxWidth >= 520
            ? 3
            : constraints.maxWidth >= 320
            ? 2
            : 1;
        final cardWidth =
            (constraints.maxWidth - (columns - 1) * spacing) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PanelHeader(
              title: 'Your Month At A Glance',
              color: widget.cardColor,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: widget.categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final isExpanded = _expandedIndex == index;

                return SizedBox(
                  width: isExpanded ? constraints.maxWidth : cardWidth,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? -1 : index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Card(
                        color: analyticsCardColor,
                        margin: EdgeInsets.zero,
                        elevation: isExpanded ? 4 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Top row: Category title + Arrow button for Focus Sprint
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      category.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: widget.cardColor.withValues(
                                          alpha: 0.85,
                                        ),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  // The arrow button to launch Focus Sprint Mode
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _startFocusSprint(
                                      context,
                                      category.title,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 13,
                                        color: widget.cardColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category.minutesSpent,
                                style: TextStyle(
                                  color: widget.cardColor,
                                  fontSize: isExpanded ? 36 : 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'minutes',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 11,
                                ),
                              ),
                              if (isExpanded) ...[
                                const SizedBox(height: 12),
                                const Divider(color: Colors.black26),
                                const SizedBox(height: 8),
                                Text(
                                  'Detailed AI Breakdown:\nYou spent a significant amount of time focusing on ${category.title} this month. This accounts for a high percentage of your overall productivity goal progress. Tap again to collapse.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _PanelHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _PanelHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Category {
  final String title;
  final List<String> items;
  final String minutesSpent;

  const _Category({
    required this.title,
    required this.items,
    required this.minutesSpent,
  });
}

class _CategoryCard extends StatelessWidget {
  final _Category category;
  final Color color;

  const _CategoryCard({required this.category, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            ...category.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
