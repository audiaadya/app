import 'package:flutter/material.dart';

import 'spaced_repitition.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const backgroundColor = Color(0xFFF8E99A);
  static const cardColor = Color(0xFF5B2845);
  static const inkColor = Color(0xFF3B2930);

  static const bookmarkCardColors = [Color(0xFF7D2B2F)];

  static const categories = <_Category>[
    _Category(title: 'School & Access', items: ['♡ classlink']),
    _Category(
      title: 'General Physics Resources',
      items: [
        '♡ Physics Packet Unit 5',
        '♡ Physics Olympiad',
        '♡ Physics Olympiad Resources - Google Drive',
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
      title: 'AP Study Materials',
      items: ['♡ AP Biology Penguins - Home'],
    ),
  ];

  void _showCACPopup(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss notification',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 380,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: HomeScreen.cardColor, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFF7D2B2F),
                              child: Icon(
                                Icons.smart_toy_outlined,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Activity Reminder',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Dismiss',
                              onPressed: () => Navigator.pop(dialogContext),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '''Your spaced repition session for Physics is scheduled for today!''',
                          style: TextStyle(height: 1.35),
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const SpacedRepetitionScreen(),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF5B2845),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Test your knowledge!'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(0, -0.15),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Scrollbar(
              thumbVisibility: true,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 76, 16, 24),
                children: [
                  _HomeHero(onSparkleTap: () => _showCACPopup(context)),
                  const SizedBox(height: 14),
                  const _HomeStats(),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF2),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your week in color',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: inkColor,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Where your curiosity wandered',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: inkColor.withValues(alpha: 0.68),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: _BookmarkPieChartPainter(),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const _PieChartLegend(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth >= 620
                          ? (constraints.maxWidth - 10) / 2
                          : constraints.maxWidth;
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ...categories.asMap().entries.map(
                            (entry) => SizedBox(
                              width: cardWidth,
                              child: _CategoryCard(
                                category: entry.value,
                                color: entry.key.isEven
                                    ? cardColor
                                    : cardColor.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const _WeeklySummaryCard(),
                ],
              ),
            ),
          ],
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

class _HomeHero extends StatelessWidget {
  final VoidCallback onSparkleTap;

  const _HomeHero({required this.onSparkleTap});

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
            color: HomeScreen.cardColor.withValues(alpha: 0.2),
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
                const Text(
                  'Good morning, curious mind',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here is your week at a glance — gentle progress is still progress.',
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
          Semantics(
            button: true,
            label: 'Open activity reminder',
            child: InkWell(
              onTap: onSparkleTap,
              borderRadius: BorderRadius.circular(34),
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFFFD58A),
                  size: 36,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeStats extends StatelessWidget {
  const _HomeStats();

  @override
  Widget build(BuildContext context) {
    final bookmarkCount = HomeScreen.categories.fold<int>(
      0,
      (total, category) => total + category.items.length,
    );
    return Row(
      children: [
        Expanded(
          child: _HomeStat(
            icon: Icons.favorite_rounded,
            value: '$bookmarkCount',
            label: 'saved gems',
            color: const Color(0xFFF0D2BD),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: _HomeStat(
            icon: Icons.local_fire_department_rounded,
            value: '4',
            label: 'active interests',
            color: Color(0xFFD7E3D2),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: _HomeStat(
            icon: Icons.star_rounded,
            value: '78%',
            label: 'weekly rhythm',
            color: Color(0xFFE5DDD3),
          ),
        ),
      ],
    );
  }
}

class _HomeStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _HomeStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: HomeScreen.inkColor, size: 21),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: HomeScreen.inkColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: HomeScreen.inkColor.withValues(alpha: 0.62),
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
                    color: HomeScreen.inkColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${category.items.length}',
                style: TextStyle(color: color, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...category.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    size: 13,
                    color: color.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item.replaceFirst('♡ ', ''),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: HomeScreen.inkColor.withValues(alpha: 0.72),
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
    if (lowerTitle.contains('ap ')) return Icons.menu_book_rounded;
    return Icons.auto_stories_rounded;
  }
}

class _BookmarkPieChartPainter extends CustomPainter {
  const _BookmarkPieChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final values = [40.0, 20.0, 30.0, 10.0];
    final colors = [
      const Color(0xFF7D2B2F),
      const Color(0xFF9B6A9E),
      const Color(0xFFE0A458),
      const Color(0xFF7BAE7F),
    ];
    final total = values.reduce((a, b) => a + b);
    var startAngle = -3.141592653589793 / 2;

    for (var i = 0; i < values.length; i++) {
      final sweepAngle = values[i] / total * 2 * 3.141592653589793;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PieChartLegend extends StatelessWidget {
  const _PieChartLegend();

  static const entries = [
    ('Mathematics Competitions', '40%', Color(0xFF7D2B2F)),
    ('AP Study Materials', '20%', Color(0xFF9B6A9E)),
    ('General Physics Resources', '30%', Color(0xFFE09A45)),
    ('School & Access', '10%', Color(0xFF7A8B57)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: entry.$3,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.$1,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                  ),
                ),
                Text(
                  entry.$2,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WeeklySummaryCard extends StatelessWidget {
  const _WeeklySummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: HomeScreen.cardColor.withValues(alpha: 0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: HomeScreen.cardColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: HomeScreen.cardColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Text(
                  'A tiny note from your week',
                  style: TextStyle(
                    color: HomeScreen.inkColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _showPodcastGenerator(context),
                icon: const Icon(Icons.headphones_rounded, size: 17),
                label: const Text('Generate a Podcast'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: HomeScreen.cardColor,
                  side: BorderSide(
                    color: HomeScreen.cardColor.withValues(alpha: 0.35),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Your distribution shows an intense, high-impact academic sprint geared squarely toward competitive math and physics. Because you are heavily indexing on rigorous problem-solving blocks, balance these sessions with adequate cognitive rest to prevent burnout. For more practice, focus on physics problems and reviewing AP Biology concepts using your saved resources.',
            style: TextStyle(
              color: Color(0xFF302F3D),
              fontSize: 15,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8B6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                'Best next step: one focused physics block, then a real break.',
                style: TextStyle(
                  color: HomeScreen.inkColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPodcastGenerator(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const _PodcastGeneratorDialog(),
    );
  }
}

class _PodcastGeneratorDialog extends StatefulWidget {
  const _PodcastGeneratorDialog();

  @override
  State<_PodcastGeneratorDialog> createState() =>
      _PodcastGeneratorDialogState();
}

class _PodcastGeneratorDialogState extends State<_PodcastGeneratorDialog> {
  String _category = HomeScreen.categories.first.title;
  String _style = 'Monologue';
  String _length = '10 minutes';
  String _tone = 'Warm & encouraging';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HomeScreen.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
      contentPadding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
      title: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFE9E3FF),
            child: Icon(Icons.headphones_rounded, color: HomeScreen.cardColor),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Make your weekly podcast',
              style: TextStyle(
                color: HomeScreen.inkColor,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Turn your AI summary into a tiny show made just for you.',
              style: TextStyle(
                color: HomeScreen.inkColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            _PodcastDropdown(
              label: 'What should we focus on?',
              value: _category,
              icon: Icons.track_changes_rounded,
              items: HomeScreen.categories.map((category) => category.title),
              onChanged: (value) => setState(() => _category = value),
            ),
            const SizedBox(height: 12),
            _PodcastDropdown(
              label: 'Podcast style',
              value: _style,
              icon: Icons.mic_rounded,
              items: const ['Debate', 'Monologue', 'Reality show'],
              onChanged: (value) => setState(() => _style = value),
            ),
            const SizedBox(height: 12),
            _PodcastDropdown(
              label: 'Episode length',
              value: _length,
              icon: Icons.timelapse_rounded,
              items: const ['5 minutes', '10 minutes', '20 minutes'],
              onChanged: (value) => setState(() => _length = value),
            ),
            const SizedBox(height: 12),
            _PodcastDropdown(
              label: 'Vibe',
              value: _tone,
              icon: Icons.mood_rounded,
              items: const [
                'Warm & encouraging',
                'Playful & energetic',
                'Calm & reflective',
              ],
              onChanged: (value) => setState(() => _tone = value),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE2D5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Preview: a $_length $_style about $_category, '
                'with a $_tone feel.',
                style: const TextStyle(
                  color: HomeScreen.inkColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Not now'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Your $_style podcast is being prepared'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Generate'),
          style: FilledButton.styleFrom(
            backgroundColor: HomeScreen.cardColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _PodcastDropdown extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Iterable<String> items;
  final ValueChanged<String> onChanged;

  const _PodcastDropdown({
    required this.label,
    required this.value,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: HomeScreen.inkColor.withValues(alpha: 0.65),
          fontSize: 12,
        ),
        prefixIcon: Icon(icon, color: HomeScreen.cardColor, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (nextValue) {
        if (nextValue != null) onChanged(nextValue);
      },
    );
  }
}
