import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 800;
                final leftPanel = _BookmarksPanel(
                  categories: categories,
                  headerColor: headerColor,
                );
                final rightPanel = _AnalyticsPanel(
                  categories: categories,
                  cardColor: headerColor,
                );

                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: leftPanel),
                          const SizedBox(width: 16),
                          Expanded(flex: 6, child: rightPanel),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          leftPanel,
                          const SizedBox(height: 16),
                          rightPanel,
                        ],
                      );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Your generated goals can now be found in your goals page!',
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
    );
  }
}

class _BookmarksPanel extends StatelessWidget {
  final List<_Category> categories;
  final Color headerColor;

  const _BookmarksPanel({required this.categories, required this.headerColor});

  static const alternateCardColor = Color(0xFFB872A5);

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
              color: entry.key.isEven ? headerColor : alternateCardColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _AnalyticsPanel extends StatelessWidget {
  final List<_Category> categories;
  final Color cardColor;

  const _AnalyticsPanel({required this.categories, required this.cardColor});

  static const analyticsCardColor = Color(0xFFE4D4E3);

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
            _PanelHeader(title: 'Your Month At A Glance', color: cardColor),
            const SizedBox(height: 8),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: categories
                  .map(
                    (category) => SizedBox(
                      width: cardWidth,
                      child: _AnalyticsCard(
                        category: category,
                        color: analyticsCardColor,
                      ),
                    ),
                  )
                  .toList(),
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

class _AnalyticsCard extends StatelessWidget {
  final _Category category;
  final Color color;

  const _AnalyticsCard({required this.category, required this.color});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.35,
      child: Card(
        color: color,
        margin: EdgeInsets.zero,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category.minutesSpent,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'minutes',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                category.title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
