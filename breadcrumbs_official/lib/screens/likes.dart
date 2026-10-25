import 'package:flutter/material.dart';

import 'focus_sprint.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});

  static const backgroundColor = Color(0xFFF8E99A);
  static const headerColor = Color(0xFF5B2845);
  static const inkColor = Color(0xFF3B2930);

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

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    constraints.maxWidth >= 800 ? 20 : 16,
                    constraints.maxWidth >= 800 ? 20 : 16,
                    constraints.maxWidth >= 800 ? 20 : 16,
                    100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _LikesHero(),
                      const SizedBox(height: 16),
                      const _CollectionStats(),
                      const SizedBox(height: 24),
                      rightPanel,
                      const SizedBox(height: 24),
                      leftPanel,
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

class _LikesHero extends StatelessWidget {
  const _LikesHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 18, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B2845), Color(0xFFD96C5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: LikesScreen.headerColor.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your little inspiration shelf',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keep the ideas that make you curious close by.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFFF0D2BD),
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionStats extends StatelessWidget {
  const _CollectionStats();

  @override
  Widget build(BuildContext context) {
    final resourceCount = LikesScreen.categories.fold<int>(
      0,
      (total, category) => total + category.items.length,
    );
    final minutes = LikesScreen.categories.fold<int>(
      0,
      (total, category) => total + int.parse(category.minutesSpent),
    );

    return Row(
      children: [
        Expanded(
          child: _MiniStat(
            icon: Icons.favorite_rounded,
            value: '$resourceCount',
            label: 'saved gems',
            color: const Color(0xFFF0D2BD),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniStat(
            icon: Icons.category_rounded,
            value: '${LikesScreen.categories.length}',
            label: 'little worlds',
            color: const Color(0xFFD7E3D2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniStat(
            icon: Icons.schedule_rounded,
            value: '$minutes',
            label: 'minutes explored',
            color: const Color(0xFFFFFBF2),
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: LikesScreen.inkColor, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: LikesScreen.inkColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: LikesScreen.inkColor.withValues(alpha: 0.65),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        _PanelHeader(
          title: 'Your saved bookmarks',
          subtitle: 'A cozy place for future-you',
          icon: Icons.favorite_rounded,
          color: headerColor,
        ),
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

class _InsightsSuggestionButton extends StatelessWidget {
  const _InsightsSuggestionButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showSuggestion(context),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: const Color(0xFF5B2845),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.lightbulb_outline,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  void _showSuggestion(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFFF9D8),
        title: const Text('Hidden intersections'),
        content: const Text(
          'On weeks when you spend more time '
          'on Python and programming bookmarks, your robotics and physics '
          'output spikes.\n\n'
          '“You perform best on math goals during weeks when you balance coding '
          'sessions.”\n\n'
          'Some recommended physics readings have been added to your bookmarks for you to explore, based off your activity recently.',
          style: TextStyle(height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Love this insight'),
          ),
        ],
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

  static const analyticsCardColor = Color(0xFFD96C5F);

  // Function to trigger Focus Sprint Mode when the arrow is clicked
  void _startFocusSprint(BuildContext context, String categoryTitle) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFFF9D8),
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
              title: 'Your month at a glance',
              subtitle: 'Tap a bubble to see the story',
              icon: Icons.insights_rounded,
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
                        color: isExpanded
                            ? const Color(0xFFFFF4C6)
                            : analyticsCardColor,
                        margin: EdgeInsets.zero,
                        elevation: isExpanded ? 4 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
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
                                        color: LikesScreen.inkColor.withValues(
                                          alpha: 0.72,
                                        ),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
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
                                        Icons.bolt_rounded,
                                        size: 18,
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
                                'minutes explored',
                                style: TextStyle(
                                  color: LikesScreen.inkColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isExpanded) ...[
                                const SizedBox(height: 12),
                                const Divider(color: Colors.black26),
                                const SizedBox(height: 8),
                                Text(
                                  'Detailed AI Breakdown:\nYou spent a significant amount of time focusing on ${category.title} this month. This accounts for a high percentage of your overall productivity goal progress. Tap again to collapse.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: LikesScreen.inkColor.withValues(
                                      alpha: 0.72,
                                    ),
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
  final String? subtitle;
  final IconData? icon;
  final Color color;

  const _PanelHeader({
    required this.title,
    required this.color,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          if (icon != null)
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: Colors.white, size: 21),
            ),
          if (icon != null) const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: LikesScreen.inkColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: LikesScreen.inkColor.withValues(alpha: 0.58),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _categoryIcon(category.title),
                  color: color,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: LikesScreen.inkColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  child: Text(
                    '${category.items.length}',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...category.items.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    size: 14,
                    color: color.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      entry.value.replaceFirst('♡ ', ''),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: LikesScreen.inkColor.withValues(alpha: 0.72),
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('physics')) return Icons.science_rounded;
    if (lowerTitle.contains('math')) return Icons.calculate_rounded;
    if (lowerTitle.contains('robot')) return Icons.smart_toy_rounded;
    if (lowerTitle.contains('competition')) return Icons.emoji_events_rounded;
    if (lowerTitle.contains('platform')) return Icons.school_rounded;
    if (lowerTitle.contains('ap ')) return Icons.menu_book_rounded;
    if (lowerTitle.contains('website')) return Icons.language_rounded;
    return Icons.auto_stories_rounded;
  }
}
