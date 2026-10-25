import 'dart:async';

import 'package:flutter/material.dart';

class SpacedRepetitionScreen extends StatefulWidget {
  const SpacedRepetitionScreen({super.key});

  @override
  State<SpacedRepetitionScreen> createState() => _SpacedRepetitionScreenState();
}

class _SpacedRepetitionScreenState extends State<SpacedRepetitionScreen> {
  static const questions = <_QuizQuestion>[
    _QuizQuestion(
      question:
          'How is acceleration related to mass and force according to Newton\'s second law of motion?',
      options: [
        'Acceleration is directly proportional to mass and inversely proportional to force',
        'Acceleration is directly proportional to force and inversy proportional to mass',
        'Acceleration is inversely proportional to mass and force',
        'Acceleration is inversely proportional to force and directly proportional to mass',
      ],
      correctAnswerIndex: 1,
    ),
    _QuizQuestion(
      question:
          'What is the gravitational constant (G) value in the universal law of gravitation?',
      options: [
        '6.674 × 10⁻¹¹ N⋅m²/kg²',
        '9.81 m/s²',
        '3.00 × 10⁸ m/s',
        '1.602 × 10⁻¹⁹ C',
      ],
      correctAnswerIndex: 0,
    ),
    _QuizQuestion(
      question:
          'If a car travels a total distance of 120 miles in 2 hours, what is its average speed?',
      options: ['60 mph', '120 mph', '240 mph', '30 mph'],
      correctAnswerIndex: 0,
    ),
  ];

  Timer? _timer;
  int _currentQuestion = 0;
  int _secondsRemaining = 30;
  int? _selectedAnswer;
  int _score = 0;
  bool _isFinished = false;

  _QuizQuestion get _question => questions[_currentQuestion];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _isFinished) return;
      if (_secondsRemaining <= 1) {
        _finishQuiz();
        return;
      }
      setState(() => _secondsRemaining--);
    });
  }

  void _selectAnswer(int index) {
    if (_selectedAnswer != null || _isFinished) return;
    setState(() => _selectedAnswer = index);
  }

  void _nextQuestion() {
    if (_selectedAnswer == null) return;

    if (_selectedAnswer == _question.correctAnswerIndex) {
      _score++;
    }

    if (_currentQuestion == questions.length - 1) {
      _finishQuiz();
      return;
    }

    setState(() {
      _currentQuestion++;
      _selectedAnswer = null;
    });
  }

  void _finishQuiz() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() => _isFinished = true);
  }

  void _restartQuiz() {
    _timer?.cancel();
    setState(() {
      _currentQuestion = 0;
      _secondsRemaining = 30;
      _selectedAnswer = null;
      _score = 0;
      _isFinished = false;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF8E99A);
    const cardColor = Color(0xFF7D2B2F);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: _isFinished
            ? _QuizResult(
                score: _score,
                total: questions.length,
                onRestart: _restartQuiz,
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestion + 1} of ${questions.length}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Chip(
                        avatar: const Icon(Icons.timer_outlined, size: 18),
                        label: Text('$_secondsRemaining s'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (_currentQuestion + 1) / questions.length,
                    color: cardColor,
                    backgroundColor: cardColor.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _question.question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  ..._question.options.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AnswerOption(
                        index: entry.key,
                        text: entry.value,
                        selectedIndex: _selectedAnswer,
                        correctIndex: _question.correctAnswerIndex,
                        onTap: () => _selectAnswer(entry.key),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _selectedAnswer == null ? null : _nextQuestion,
                    style: FilledButton.styleFrom(
                      backgroundColor: cardColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      _currentQuestion == questions.length - 1
                          ? 'Finish Quiz'
                          : 'Next Question',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final int index;
  final String text;
  final int? selectedIndex;
  final int correctIndex;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.index,
    required this.text,
    required this.selectedIndex,
    required this.correctIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final isCorrect = selectedIndex != null && index == correctIndex;
    final isIncorrect = isSelected && !isCorrect;
    final color = isCorrect
        ? const Color(0xFF7A8B57)
        : isIncorrect
        ? const Color(0xFF9B3D35)
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: EdgeInsets.zero,
        color: color?.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color ?? Colors.black12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: color ?? const Color(0xFF7D2B2F),
                child: Text(
                  String.fromCharCode(65 + index),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text)),
              if (isCorrect)
                const Icon(Icons.check_circle, color: Color(0xFF7A8B57)),
              if (isIncorrect)
                const Icon(Icons.cancel, color: Color(0xFF9B3D35)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizResult extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const _QuizResult({
    required this.score,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_outlined,
              size: 72,
              color: Color(0xFF7D2B2F),
            ),
            const SizedBox(height: 16),
            Text(
              'Quiz complete!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('You scored $score out of $total.'),
            const SizedBox(height: 24),
            FilledButton(onPressed: onRestart, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const _QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}
