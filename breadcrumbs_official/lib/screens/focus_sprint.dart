import 'package:flutter/material.dart';

import 'timer.dart';

class FocusSprintScreen extends StatefulWidget {
  final String categoryTitle;

  const FocusSprintScreen({super.key, required this.categoryTitle});

  @override
  State<FocusSprintScreen> createState() => _FocusSprintScreenState();
}

class _FocusSprintScreenState extends State<FocusSprintScreen> {
  double _duration = 25;
  String _sound = 'Rain';
  bool _distractionLock = true;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF9EAF0);
    const cardColor = Color(0xFF6672AA);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Your Spaced Repition has been scheduled for next time!',
              ),
            ),
          );
        },
        backgroundColor: cardColor,
        icon: const Icon(Icons.schedule, color: Colors.white),
        label: const Text(
          'Schedule Spaced Repition',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Focus Sprint',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.categoryTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Customize your deep-work session before you begin.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sprint duration',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_duration.round()} minutes'),
                        const Icon(Icons.schedule_outlined),
                      ],
                    ),
                    Slider(
                      value: _duration,
                      min: 5,
                      max: 120,
                      divisions: 23,
                      label: '${_duration.round()} minutes',
                      activeColor: cardColor,
                      onChanged: (value) => setState(() => _duration = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _sound,
                    decoration: const InputDecoration(
                      labelText: 'Ambient background',
                      prefixIcon: Icon(Icons.graphic_eq),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Rain', child: Text('Rain')),
                      DropdownMenuItem(value: 'Forest', child: Text('Forest')),
                      DropdownMenuItem(value: 'Café', child: Text('Café')),
                      DropdownMenuItem(value: 'None', child: Text('None')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sound = value);
                      }
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _distractionLock,
                    title: const Text('Distraction lock-out'),
                    subtitle: const Text(
                      'Stay focused while the sprint is running',
                    ),
                    secondary: const Icon(Icons.lock_outline),
                    activeThumbColor: cardColor,
                    onChanged: (value) =>
                        setState(() => _distractionLock = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TimerScreen(
                      categoryTitle: widget.categoryTitle,
                      durationMinutes: _duration.round(),
                      sound: _sound,
                      distractionLock: _distractionLock,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Begin Sprint'),
              style: FilledButton.styleFrom(
                backgroundColor: cardColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
