import 'package:flutter/material.dart';

import 'spaced_repitition.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const bookmarkCardColors = [Color(0xFF6672AA)];

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
                    border: Border.all(
                      color: const Color(0xFF6672AA),
                      width: 2,
                    ),
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
                              backgroundColor: Color(0xFF6672AA),
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
                          '''Your spaced repition session for Robotics is scheduled for today!''',
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
                              backgroundColor: const Color(0xFF6672AA),
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
    const backgroundColor = Color(0xFFF9EAF0);
    const cardColor = Color(0xFF6672AA);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Scrollbar(
              thumbVisibility: true,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 76, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Week Analysis Summary',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...categories.asMap().entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _CategoryCard(
                                    category: entry.value,
                                    color: entry.key.isEven
                                        ? cardColor
                                        : cardColor.withValues(alpha: 0.85),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4D4E3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Week Analysis',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'A Breakdown of Your Bookmark Engagement',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.black87,
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _WeeklySummaryCard(),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 16,
              child: ElevatedButton.icon(
                onPressed: () => _showCACPopup(context),
                icon: const Icon(Icons.notifications_active_outlined),
                label: const Text('Push notification for CAC video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

class _BookmarkPieChartPainter extends CustomPainter {
  const _BookmarkPieChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final values = [40.0, 20.0, 30.0, 10.0];
    final colors = [
      const Color(0xFF6672AA),
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
    ('Mathematics Competitions', '40%', Color(0xFF6672AA)),
    ('AP Study Materials', '20%', Color(0xFF9B6A9E)),
    ('General Physics Resources', '30%', Color(0xFFE0A458)),
    ('School & Access', '10%', Color(0xFF7BAE7F)),
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
        border: Border.all(color: const Color(0xFF6672AA), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Summary of Your Week',
            style: TextStyle(
              color: Color(0xFF6672AA),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Your distribution shows an intense, high-impact academic sprint geared squarely toward competitive math and physics. Because you're heavily indexing on rigorous problem-solving blocks, ensure you're balancing these sessions with adequate cognitive rest to prevent burnout. If you want more practice, you should focus on practicing more physics problems and reviewing AP Biology concepts. I recommend checking out the Physics Olympiad resources you bookmarked and spending some time on the AP Biology Penguins website for additional practice.",
            style: TextStyle(
              color: Color(0xFF302F3D),
              fontSize: 15,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
