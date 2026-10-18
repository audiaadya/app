import 'package:flutter/material.dart';

class GoalVelocityTrackerScreen extends StatelessWidget {
  static const cardColor = Color(0xFF6672AA);

  final int completedGoals;
  final int totalGoals;

  const GoalVelocityTrackerScreen({
    super.key,
    required this.completedGoals,
    required this.totalGoals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EAF0),
      appBar: AppBar(
        backgroundColor: cardColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Goal Velocity Tracker',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 700;
            final content = isCompact ? _CompactLayout() : _WideLayout();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 24 : 52,
                vertical: isCompact ? 28 : 42,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Spot what is slowing your progress and choose your next step.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.62),
                      fontSize: 17,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: isCompact ? 34 : 48),
                  content,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 5, child: _ProgressPanel()),
        const SizedBox(width: 64),
        const Expanded(flex: 5, child: _FrictionCard()),
      ],
    );
  }
}

class _CompactLayout extends StatelessWidget {
  const _CompactLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ProgressPanel(),
        const SizedBox(height: 28),
        const _FrictionCard(),
      ],
    );
  }
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 30, 26, 32),
      decoration: BoxDecoration(
        color: GoalVelocityTrackerScreen.cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B6680).withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  height: 266,
                  child: CustomPaint(painter: _EfficiencyChartPainter()),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Current Efficiency: 78%',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          _ActionButton(
            icon: Icons.local_fire_department_outlined,
            label: 'Burnout Risk Tracker',
            onPressed: () {},
          ),
          const SizedBox(height: 16),
          _ActionButton(
            icon: Icons.lightbulb_outline,
            label: 'Your What-If Sandbox',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 72,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 34, color: Colors.white),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: GoalVelocityTrackerScreen.cardColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
      ),
    );
  }
}

class _FrictionCard extends StatelessWidget {
  const _FrictionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD582BC),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B6680).withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(0, 42, 0, 52),
      child: Column(
        children: [
          const Text(
            'Friction Point Detected!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: const Text(
              "You spent 150 minutes reading kinematics physics resources, but your physics goals of getting above an 85% correct rate on a kinematics practice test haven't budged at all.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF302239),
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 52),
          const Text(
            'Pick your next action!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 44),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              children: [
                Expanded(
                  child: _FrictionAction(
                    icon: Icons.category_outlined,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _FrictionAction(icon: Icons.tune, onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FrictionAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _FrictionAction({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: GoalVelocityTrackerScreen.cardColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(icon, size: 64),
      ),
    );
  }
}

class _EfficiencyChartPainter extends CustomPainter {
  const _EfficiencyChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = const Color(0xFF151515)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final pointPaint = Paint()
      ..color = const Color(0xFF151515)
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final left = size.width * .08;
    final right = left + (size.width * .68).clamp(230.0, 290.0).toDouble();
    final top = 12.0;
    final bottom = size.height - 34;
    final axis = Path()
      ..moveTo(left, bottom)
      ..lineTo(left, top)
      ..moveTo(left, bottom)
      ..lineTo(right, bottom);
    canvas.drawPath(axis, axisPaint);

    final arrow = Path()
      ..moveTo(left - 8, top + 11)
      ..lineTo(left, top)
      ..lineTo(left + 8, top + 11)
      ..moveTo(right - 11, bottom - 8)
      ..lineTo(right, bottom)
      ..lineTo(right - 11, bottom + 8);
    canvas.drawPath(arrow, axisPaint);

    for (var index = 1; index < 8; index++) {
      final x = left + (right - left) * index / 8;
      canvas.drawLine(Offset(x, bottom), Offset(x, bottom + 8), axisPaint);
    }
    for (var index = 1; index < 7; index++) {
      final y = bottom - (bottom - top) * index / 7;
      canvas.drawLine(Offset(left - 8, y), Offset(left, y), axisPaint);
    }

    final points = [
      Offset(left + 12, bottom - 17),
      Offset(left + 34, bottom - 42),
      Offset(left + 60, bottom - 73),
      Offset(left + 91, bottom - 73),
      Offset(left + 118, bottom - 111),
      Offset(left + 153, bottom - 111),
      Offset(left + 179, bottom - 143),
      Offset(left + 204, bottom - 143),
      Offset(right - 10, bottom - 178),
    ];
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      line.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(line, axisPaint);
    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
      canvas.drawCircle(point, 2.3, innerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
