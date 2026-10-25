import 'package:flutter/material.dart';

class GoalVelocityTrackerScreen extends StatelessWidget {
  static const cardColor = Color(0xFF5B2845);
  static const inkColor = Color(0xFF3B2930);
  static const backgroundColor = Color(0xFFF8E99A);
  static const mintColor = Color(0xFFC9D9B8);
  static const peachColor = Color(0xFFFFB09F);

  final int completedGoals;
  final int totalGoals;

  const GoalVelocityTrackerScreen({
    super.key,
    required this.completedGoals,
    required this.totalGoals,
  });

  @override
  Widget build(BuildContext context) {
    final completion = totalGoals == 0
        ? 0.0
        : (completedGoals / totalGoals).clamp(0.0, 1.0).toDouble();
    final completionPercent = (completion * 100).round();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: inkColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Goal Velocity Tracker',
          style: TextStyle(
            color: inkColor,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                tooltip: 'How this works',
                onPressed: () => _showHowItWorks(context),
                icon: const Icon(Icons.question_mark_rounded, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 700;
            final content = _CompactLayout(
              completedGoals: completedGoals,
              totalGoals: totalGoals,
              completion: completion,
              onShowSandbox: () => _showWhatIfSandbox(context),
              onShowAction: (title, message, icon) =>
                  _showActionDialog(context, title, message, icon),
            );

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 18 : 42,
                vertical: isCompact ? 18 : 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _WelcomeBanner(
                    completedGoals: completedGoals,
                    totalGoals: totalGoals,
                    completionPercent: completionPercent,
                    completion: completion,
                  ),
                  SizedBox(height: isCompact ? 20 : 28),
                  _StatsRow(
                    completedGoals: completedGoals,
                    totalGoals: totalGoals,
                    completionPercent: completionPercent,
                  ),
                  const SizedBox(height: 16),
                  const _EnergyPeakCard(),
                  SizedBox(height: isCompact ? 24 : 34),
                  content,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showHowItWorks(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _InfoDialog(
        title: 'Your tiny progress coach',
        icon: Icons.auto_awesome_rounded,
        message:
            'Goal velocity looks at how steadily you are moving, not just how much you have finished. Use the chart to spot patterns, then pick one small action to keep your momentum going.',
        actionLabel: 'Got it!',
        onAction: () => Navigator.pop(dialogContext),
      ),
    );
  }

  void _showActionDialog(
    BuildContext context,
    String title,
    String message,
    IconData icon,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _InfoDialog(
        title: title,
        icon: icon,
        message: message,
        actionLabel: 'I can do this',
        onAction: () => Navigator.pop(dialogContext),
      ),
    );
  }

  void _showWhatIfSandbox(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => const _WhatIfSandboxDialog(),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  final int completedGoals;
  final int totalGoals;
  final int completionPercent;
  final double completion;

  const _WelcomeBanner({
    required this.completedGoals,
    required this.totalGoals,
    required this.completionPercent,
    required this.completion,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = totalGoals > 0 && completedGoals >= totalGoals;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 18, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B2845), Color(0xFFD96C5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: GoalVelocityTrackerScreen.cardColor.withValues(alpha: 0.2),
            blurRadius: 22,
            offset: const Offset(0, 10),
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
                  isComplete ? 'You did it!' : 'Keep your momentum going',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isComplete
                      ? 'Every goal is checked off. Celebrate your progress and set a new goal!'
                      : '$completedGoals of $totalGoals goals are complete. Small steps still count!',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: completion,
                    minHeight: 9,
                    backgroundColor: Colors.white.withValues(alpha: 0.22),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFF0D2BD),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 82,
            height: 82,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: completion,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFF0D2BD),
                  ),
                ),
                Text(
                  '$completionPercent%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
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

class _StatsRow extends StatelessWidget {
  final int completedGoals;
  final int totalGoals;
  final int completionPercent;

  const _StatsRow({
    required this.completedGoals,
    required this.totalGoals,
    required this.completionPercent,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (totalGoals - completedGoals).clamp(0, totalGoals);
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline_rounded,
            value: '$completedGoals',
            label: 'completed',
            color: GoalVelocityTrackerScreen.mintColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.flag_outlined,
            value: '$remaining',
            label: 'to go',
            color: GoalVelocityTrackerScreen.peachColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up_rounded,
            value: '$completionPercent%',
            label: 'momentum',
            color: const Color(0xFFFFFBF2),
          ),
        ),
      ],
    );
  }
}

class _EnergyPeakCard extends StatelessWidget {
  const _EnergyPeakCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0D2BD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.wb_sunny_rounded,
                  color: GoalVelocityTrackerScreen.inkColor,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Text(
                  'Your focus peak map',
                  style: TextStyle(
                    color: GoalVelocityTrackerScreen.inkColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (_) => const _FocusCurveDialog(),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    child: Text(
                      'new',
                      style: TextStyle(
                        color: GoalVelocityTrackerScreen.inkColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'We are learning when your brain feels brightest from your completed focus sprints.',
            style: TextStyle(
              color: GoalVelocityTrackerScreen.inkColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _EnergyTime(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Peak focus',
                  time: '10:00 AM',
                  color: GoalVelocityTrackerScreen.mintColor,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _EnergyTime(
                  icon: Icons.nightlight_outlined,
                  label: 'Gentle slump',
                  time: '2:00 PM',
                  color: const Color(0xFFE5DDD3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Try high-friction tasks near your peak; save lighter review for your softer hours.',
            style: TextStyle(
              color: GoalVelocityTrackerScreen.inkColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusCurveDialog extends StatefulWidget {
  const _FocusCurveDialog();

  @override
  State<_FocusCurveDialog> createState() => _FocusCurveDialogState();
}

class _FocusCurveDialogState extends State<_FocusCurveDialog> {
  double _selectedHour = 10;

  String get _selectedTime {
    final hour = _selectedHour.round();
    if (hour == 0) return '12:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour > 12 ? hour - 12 : hour}:00 ${hour < 12 ? 'AM' : 'PM'}';
  }

  double get _energy {
    final distanceFromPeak = (_selectedHour - 10).abs();
    return (100 - distanceFromPeak * 10).clamp(35, 100).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: GoalVelocityTrackerScreen.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      title: const Row(
        children: [
          Icon(
            Icons.wb_sunny_rounded,
            color: GoalVelocityTrackerScreen.inkColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your cognitive energy curve',
              style: TextStyle(
                color: GoalVelocityTrackerScreen.inkColor,
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
              'Drag the little sun to explore how your focus rises, peaks, and gently slopes down.',
              style: TextStyle(
                color: GoalVelocityTrackerScreen.inkColor,
                height: 1.4,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: CustomPaint(
                painter: _FocusCurvePainter(selectedHour: _selectedHour),
              ),
            ),
            const SizedBox(height: 14),
            Slider(
              value: _selectedHour,
              min: 7,
              max: 19,
              divisions: 12,
              activeColor: GoalVelocityTrackerScreen.cardColor,
              onChanged: (value) => setState(() => _selectedHour = value),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('7 AM', style: TextStyle(fontSize: 11)),
                Text('1 PM', style: TextStyle(fontSize: 11)),
                Text('7 PM', style: TextStyle(fontSize: 11)),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFF0D2BD),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'At $_selectedTime, your estimated focus is ${_energy.round()}%. '
                '${_energy >= 85 ? 'Perfect for a high-friction task!' : 'Try a lighter review or planning task.'}',
                style: const TextStyle(
                  color: GoalVelocityTrackerScreen.inkColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(
            backgroundColor: GoalVelocityTrackerScreen.cardColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Lovely, got it'),
        ),
      ],
    );
  }
}

class _FocusCurvePainter extends CustomPainter {
  final double selectedHour;

  const _FocusCurvePainter({required this.selectedHour});

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(16, 12, size.width - 28, size.height - 34);
    final gridPaint = Paint()
      ..color = const Color(0xFFE5DDD3)
      ..strokeWidth = 1;
    final curvePaint = Paint()
      ..color = GoalVelocityTrackerScreen.cardColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()
      ..color = const Color(0xFF5B2845).withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    for (var index = 1; index < 4; index++) {
      final y = chart.top + chart.height * index / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    double energyAt(double hour) {
      final distance = (hour - 10).abs();
      return (100 - distance * 10).clamp(35, 100).toDouble();
    }

    final curve = Path();
    final fill = Path()..moveTo(chart.left, chart.bottom);
    for (var index = 0; index <= 48; index++) {
      final hour = 7 + index * 12 / 48;
      final x = chart.left + index / 48 * chart.width;
      final y = chart.bottom - energyAt(hour) / 100 * chart.height;
      if (index == 0) {
        curve.moveTo(x, y);
        fill.lineTo(x, y);
      } else {
        curve.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill
      ..lineTo(chart.right, chart.bottom)
      ..close();
    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(curve, curvePaint);

    final markerX = chart.left + (selectedHour - 7) / 12 * chart.width;
    final markerY = chart.bottom - energyAt(selectedHour) / 100 * chart.height;
    canvas.drawLine(
      Offset(markerX, chart.top),
      Offset(markerX, chart.bottom),
      Paint()
        ..color = const Color(0xFFD96C5F)
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      Offset(markerX, markerY),
      8,
      Paint()..color = const Color(0xFFD96C5F),
    );
    canvas.drawCircle(
      Offset(markerX, markerY),
      3,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _FocusCurvePainter oldDelegate) =>
      oldDelegate.selectedHour != selectedHour;
}

class _EnergyTime extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color color;

  const _EnergyTime({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: GoalVelocityTrackerScreen.inkColor, size: 19),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: GoalVelocityTrackerScreen.inkColor.withValues(
                      alpha: 0.65,
                    ),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: GoalVelocityTrackerScreen.inkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: GoalVelocityTrackerScreen.inkColor, size: 23),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: GoalVelocityTrackerScreen.inkColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: GoalVelocityTrackerScreen.inkColor.withValues(
                      alpha: 0.65,
                    ),
                    fontSize: 11,
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

class _InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final IconData icon;
  final VoidCallback onAction;

  const _InfoDialog({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.icon,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: GoalVelocityTrackerScreen.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      contentPadding: const EdgeInsets.fromLTRB(24, 26, 24, 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: GoalVelocityTrackerScreen.peachColor,
            child: Icon(
              icon,
              color: GoalVelocityTrackerScreen.inkColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: GoalVelocityTrackerScreen.inkColor,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: GoalVelocityTrackerScreen.inkColor.withValues(alpha: 0.72),
              height: 1.45,
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: onAction,
          style: FilledButton.styleFrom(
            backgroundColor: GoalVelocityTrackerScreen.cardColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _WhatIfSandboxDialog extends StatefulWidget {
  const _WhatIfSandboxDialog();

  @override
  State<_WhatIfSandboxDialog> createState() => _WhatIfSandboxDialogState();
}

class _WhatIfSandboxDialogState extends State<_WhatIfSandboxDialog> {
  static const _targets = [
    ('Math problem-solving', Icons.calculate_rounded),
    ('Programming practice', Icons.code_rounded),
    ('Physics study', Icons.science_rounded),
    ('Reading and review', Icons.menu_book_rounded),
  ];

  double _extraHours = 5;
  String _selectedTarget = 'Math problem-solving';

  @override
  Widget build(BuildContext context) {
    final addedHours = _extraHours.round();
    final readingReduction = (addedHours * 0.6).round();
    final browsingReduction = (addedHours * 0.4).round();
    final primaryLift = (addedHours * 2.4).round();
    final secondaryLift = (addedHours * 1.8).round();
    final targetIcon = _targets
        .firstWhere((target) => target.$1 == _selectedTarget)
        .$2;

    return AlertDialog(
      backgroundColor: GoalVelocityTrackerScreen.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      title: const Text(
        'What-if sandbox',
        style: TextStyle(
          color: GoalVelocityTrackerScreen.inkColor,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Forecast a schedule change before you commit to it.',
              style: TextStyle(
                color: GoalVelocityTrackerScreen.inkColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'What would you like to increase?',
              style: TextStyle(
                color: GoalVelocityTrackerScreen.inkColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedTarget,
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  targetIcon,
                  color: GoalVelocityTrackerScreen.cardColor,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _targets
                  .map(
                    (target) => DropdownMenuItem<String>(
                      value: target.$1,
                      child: Text(target.$1),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedTarget = value);
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Extra $_selectedTarget time each week',
              style: const TextStyle(
                color: GoalVelocityTrackerScreen.inkColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _extraHours,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: GoalVelocityTrackerScreen.cardColor,
                    onChanged: (value) => setState(() => _extraHours = value),
                  ),
                ),
                Text(
                  '+$addedHours h',
                  style: const TextStyle(
                    color: GoalVelocityTrackerScreen.cardColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Based on your historical velocity, this adjustment would likely come from:',
              style: TextStyle(
                color: GoalVelocityTrackerScreen.inkColor,
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            _ForecastRow(
              icon: Icons.menu_book_rounded,
              label: 'General reading',
              value: '-$readingReduction h / week',
              color: GoalVelocityTrackerScreen.mintColor,
            ),
            const SizedBox(height: 8),
            _ForecastRow(
              icon: Icons.language_rounded,
              label: 'Casual browsing',
              value: '-$browsingReduction h / week',
              color: GoalVelocityTrackerScreen.peachColor,
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFE5DDD3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Projected lift: $_selectedTarget +$primaryLift% • '
                'related goals +$secondaryLift%\n'
                'This keeps the plan ambitious, but still realistic.',
                style: const TextStyle(
                  color: GoalVelocityTrackerScreen.inkColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(
            backgroundColor: GoalVelocityTrackerScreen.cardColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save forecast'),
        ),
      ],
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ForecastRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: GoalVelocityTrackerScreen.inkColor, size: 19),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: GoalVelocityTrackerScreen.inkColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: GoalVelocityTrackerScreen.inkColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactLayout extends StatelessWidget {
  final int completedGoals;
  final int totalGoals;
  final double completion;
  final VoidCallback onShowSandbox;
  final void Function(String, String, IconData) onShowAction;

  const _CompactLayout({
    required this.completedGoals,
    required this.totalGoals,
    required this.completion,
    required this.onShowSandbox,
    required this.onShowAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProgressPanel(
          completedGoals: completedGoals,
          totalGoals: totalGoals,
          onShowSandbox: onShowSandbox,
          onShowAction: onShowAction,
        ),
        const SizedBox(height: 28),
        _FrictionCard(completion: completion, onShowAction: onShowAction),
      ],
    );
  }
}

class _ProgressPanel extends StatelessWidget {
  final int completedGoals;
  final int totalGoals;
  final VoidCallback onShowSandbox;
  final void Function(String, String, IconData) onShowAction;

  const _ProgressPanel({
    required this.completedGoals,
    required this.totalGoals,
    required this.onShowSandbox,
    required this.onShowAction,
  });

  @override
  Widget build(BuildContext context) {
    final efficiency = totalGoals == 0
        ? 0
        : ((completedGoals / totalGoals) * 100).round();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your momentum',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  child: Text(
                    'this week',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          Text(
            'Current efficiency: $efficiency%',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            efficiency >= 70
                ? 'You are building a lovely rhythm.'
                : 'One gentle step at a time is enough.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 22),
          _ActionButton(
            icon: Icons.local_fire_department_outlined,
            label: 'Burnout Risk Tracker',
            onPressed: () => onShowAction(
              'Burnout risk check',
              'Your current pace looks manageable. Try planning a soft reset after one focused session: hydrate, stretch, and celebrate the progress you already made.',
              Icons.local_fire_department_outlined,
            ),
          ),
          const SizedBox(height: 10),
          _ActionButton(
            icon: Icons.lightbulb_outline,
            label: 'Your What-If Sandbox',
            onPressed: onShowSandbox,
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
    const cardColor = Color(0xFF5B2845);
    return SizedBox(
      width: double.infinity,
      height: 72,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 34, color: cardColor),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(
              color: cardColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: cardColor,
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
  final double completion;
  final void Function(String, String, IconData) onShowAction;

  const _FrictionCard({required this.completion, required this.onShowAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC49A9D),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B2845).withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      child: Column(
        children: [
          const Icon(
            Icons.self_improvement_rounded,
            color: GoalVelocityTrackerScreen.inkColor,
            size: 42,
          ),
          const SizedBox(height: 10),
          const Text(
            'Let’s make it feel easier',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: GoalVelocityTrackerScreen.inkColor,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              completion < 0.5
                  ? 'Your progress is still warming up. Pick a small, clear next step and let the momentum follow.'
                  : 'You have momentum! A little structure can help turn your effort into even more visible progress.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GoalVelocityTrackerScreen.inkColor,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Pick a tiny next action',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: GoalVelocityTrackerScreen.inkColor,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _FrictionAction(
                  icon: Icons.category_outlined,
                  label: 'Simplify',
                  onPressed: () => onShowAction(
                    'Simplify the goal',
                    'Break your next goal into a single 15-minute action. Clear and cozy beats perfect every time.',
                    Icons.category_outlined,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FrictionAction(
                  icon: Icons.tune,
                  label: 'Adjust',
                  onPressed: () => onShowAction(
                    'Adjust your plan',
                    'Move one task to a friendlier day or shorten the session. Your plan should support you, not boss you around.',
                    Icons.tune,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FrictionAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _FrictionAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.75),
          foregroundColor: GoalVelocityTrackerScreen.inkColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
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
