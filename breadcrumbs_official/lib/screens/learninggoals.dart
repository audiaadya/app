import 'package:flutter/material.dart';

class LearningGoalsScreen extends StatefulWidget {
  const LearningGoalsScreen({super.key});

  @override
  State<LearningGoalsScreen> createState() => _LearningGoalsScreenState();
}

class _LearningGoalsScreenState extends State<LearningGoalsScreen> {
  final _goals = <_LearningGoal>[
    _LearningGoal('Review one math resource', 'Mathematics'),
    _LearningGoal('Complete a physics practice problem', 'Physics'),
    _LearningGoal('Study an AP topic', 'AP Study'),
    _LearningGoal('Explore one competition opportunity', 'Competitions'),
  ];

  int get _completedGoals => _goals.where((goal) => goal.isComplete).length;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF9EAF0);
    const cardColor = Color(0xFF6672AA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Your Learning Goals',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: cardColor,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Checklist',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_completedGoals of ${_goals.length} goals completed',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: _goals.isEmpty
                            ? 0
                            : _completedGoals / _goals.length,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ..._goals.map(
                (goal) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: CheckboxListTile(
                    value: goal.isComplete,
                    onChanged: (value) {
                      setState(() {
                        goal.isComplete = value ?? false;
                      });
                    },
                    title: Text(
                      goal.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: goal.isComplete
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(goal.category),
                    activeColor: cardColor,
                    controlAffinity: ListTileControlAffinity.leading,
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

class _LearningGoal {
  final String title;
  final String category;
  bool isComplete = false;

  _LearningGoal(this.title, this.category);
}
