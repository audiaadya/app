import 'package:flutter/material.dart';

class GoalVelocityTrackerScreen extends StatelessWidget {
  final int completedGoals;
  final int totalGoals;

  const GoalVelocityTrackerScreen({
    super.key,
    required this.completedGoals,
    required this.totalGoals,
  });

  @override
  Widget build(BuildContext context) {
    final double velocity = totalGoals == 0 ? 0.0 : completedGoals / totalGoals;

    return Scaffold(
      appBar: AppBar(title: const Text('Goal Velocity Tracker')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$completedGoals of $totalGoals goals completed'),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: velocity),
                  const SizedBox(height: 12),
                  Text(
                    velocity == 1
                        ? 'All goals completed!'
                        : 'Keep going to increase your goal velocity.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
