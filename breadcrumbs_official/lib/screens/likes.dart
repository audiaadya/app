import 'package:flutter/material.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});

  static const categories = <_Category>[
    _Category(title: 'School & Access', items: ['♡ classlink']),
    _Category(title: 'General Math Resources', items: ['♡ Calculus Primer']),
    _Category(title: 'Personal Websites / Blogs', items: ['♡ Kevin Zhou']),
    _Category(
      title: 'General Physics Resources',
      items: [
        '♡ Physics Packet Unit 5',
        '♡ Physics Olympiad',
        '♡ Kevin Zhou (2x IPHO gold from US) on JEE system',
      ],
    ),
    _Category(
      title: 'Mathematics Competitions',
      items: [
        '♡ 2025 AMC 12A Problems/Problem 5 - AoPS Wiki',
        '♡ How to Apply - Math Prize for Girls',
        '♡ Getting Started | USA Mathematical Talent Search',
      ],
    ),
    _Category(
      title: 'Other Academic Competitions',
      items: ['♡ International Mathematics Olympiad 2026'],
    ),
    _Category(
      title: 'Learning Platforms / EdTech',
      items: ['♡ Our Story | Stellar Learning'],
    ),
    _Category(
      title: 'Robotics & Programming',
      items: [
        '♡ PROS First Time Users Guide — PROS for V5 3.8.0 documentation',
        '♡ vex pros - YouTube',
      ],
    ),
    _Category(
      title: 'AP Study Materials',
      items: [
        '♡ AP Biology Penguins - Home',
        '♡ AP Statistics Exam Style Questions | IITian Academy',
        '♡ Science with Austin - NEW UPDATED AP BIO RESOURCES',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF9EAF0);
    const cardColor = Color(0xFF6672AA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Your Bookmarks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              ...categories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: _CategoryCard(
                        category: category,
                        color: cardColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Category {
  final String title;
  final List<String> items;

  const _Category({required this.title, required this.items});
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
        padding: const EdgeInsets.all(14),
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
            const SizedBox(height: 8),
            ...category.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
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
