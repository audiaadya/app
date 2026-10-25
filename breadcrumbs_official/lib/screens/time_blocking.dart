import 'package:flutter/material.dart';

class TimeBlockingScreen extends StatefulWidget {
  const TimeBlockingScreen({super.key});

  @override
  State<TimeBlockingScreen> createState() => _TimeBlockingScreenState();
}

class _TimeBlock {
  final String category;
  final Color color;
  double start;
  double duration;

  _TimeBlock({
    required this.category,
    required this.color,
    required this.start,
    required this.duration,
  });
}

class _TimeBlockingScreenState extends State<TimeBlockingScreen> {
  static const _ink = Color(0xFF4A2022);
  static const _purple = Color(0xFF5B2845);
  static const _background = Color(0xFFF8E99A);

  final _categories = const [
    ('Math', Color(0xFF5B2845), Icons.calculate_rounded),
    ('Physics', Color(0xFFE09A45), Icons.science_rounded),
    ('Programming', Color(0xFF7A8B57), Icons.code_rounded),
    ('Reading', Color(0xFFD77A3D), Icons.menu_book_rounded),
    ('Rest', Color(0xFFB85C51), Icons.self_improvement_rounded),
  ];

  final _blocks = <_TimeBlock>[
    _TimeBlock(
      category: 'Math',
      color: Color(0xFF7D2B2F),
      start: 9,
      duration: 2,
    ),
    _TimeBlock(
      category: 'Physics',
      color: Color(0xFFE09A45),
      start: 13,
      duration: 1.5,
    ),
    _TimeBlock(
      category: 'Rest',
      color: Color(0xFFB85C51),
      start: 15,
      duration: 1,
    ),
  ];

  double get _allocatedHours =>
      _blocks.fold(0, (total, block) => total + block.duration);

  void _addBlock(String category, Color color) {
    final start = _blocks.isEmpty
        ? 8.0
        : (_blocks.last.start + _blocks.last.duration + 0.5).clamp(7.0, 22.0);
    setState(() {
      _blocks.add(
        _TimeBlock(category: category, color: color, start: start, duration: 1),
      );
    });
  }

  void _compressDay() {
    var cursor = 8.0;
    setState(() {
      for (final block in _blocks) {
        block.start = cursor;
        block.duration = block.duration.clamp(0.5, 1.5).toDouble();
        cursor += block.duration + 0.25;
      }
    });
  }

  void _removeBlock(_TimeBlock block) {
    setState(() => _blocks.remove(block));
  }

  String _formatHour(double hour) {
    final rounded = hour.round() % 24;
    final suffix = rounded >= 12 ? 'PM' : 'AM';
    final display = rounded == 0
        ? 12
        : rounded > 12
        ? rounded - 12
        : rounded;
    return '$display $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final isOverflowing = _allocatedHours > 24;
    final percent = (_allocatedHours / 24 * 100).round();
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        foregroundColor: _ink,
        elevation: 0,
        title: const Text(
          'Daily time planner',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Compress schedule',
            onPressed: _compressDay,
            icon: const Icon(Icons.auto_fix_high_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
          children: [
            _PlannerHero(
              allocatedHours: _allocatedHours,
              percent: percent,
              isOverflowing: isOverflowing,
            ),
            const SizedBox(height: 18),
            const Text(
              'Tap a category to add a block',
              style: TextStyle(
                color: _ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = _categories[index];
                  return ActionChip(
                    onPressed: () => _addBlock(item.$1, item.$2),
                    avatar: Icon(item.$3, size: 17, color: item.$2),
                    label: Text(item.$1),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: item.$2.withValues(alpha: 0.25)),
                    labelStyle: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _Timeline(
              blocks: _blocks,
              formatHour: _formatHour,
              onMove: (block, delta) {
                setState(() {
                  block.start = (block.start + delta).clamp(
                    0.0,
                    24 - block.duration,
                  );
                });
              },
              onRemove: _removeBlock,
            ),
            if (isOverflowing) ...[
              const SizedBox(height: 14),
              _OverflowNotice(hours: _allocatedHours, onCompress: _compressDay),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addBlock('Reading', const Color(0xFFD77A3D)),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add block'),
      ),
    );
  }
}

class _PlannerHero extends StatelessWidget {
  final double allocatedHours;
  final int percent;
  final bool isOverflowing;

  const _PlannerHero({
    required this.allocatedHours,
    required this.percent,
    required this.isOverflowing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7D2B2F), Color(0xFFB85C51)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7D2B2F).withValues(alpha: 0.2),
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
                  'Shape a day that fits you',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  isOverflowing
                      ? 'Your day is feeling a little full.'
                      : '$percent% of your day has a gentle plan.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: (allocatedHours / 24).clamp(0.0, 1.0).toDouble(),
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOverflowing
                        ? const Color(0xFFFFB38A)
                        : const Color(0xFFFFD58A),
                  ),
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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

class _Timeline extends StatelessWidget {
  final List<_TimeBlock> blocks;
  final String Function(double) formatHour;
  final void Function(_TimeBlock, double) onMove;
  final void Function(_TimeBlock) onRemove;

  const _Timeline({
    required this.blocks,
    required this.formatHour,
    required this.onMove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.drag_indicator_rounded,
                color: _TimeBlockingScreenState._purple,
              ),
              SizedBox(width: 5),
              Text(
                '24-hour timeline',
                style: TextStyle(
                  color: _TimeBlockingScreenState._ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacer(),
              Text(
                'drag to slide',
                style: TextStyle(color: Colors.black45, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 290,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Row(
                        children: List.generate(
                          24,
                          (index) => Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: const Color(0xFFE9E3FF),
                                    width: index == 0 ? 1.5 : 0.7,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    for (final block in blocks)
                      Positioned(
                        left: block.start / 24 * width,
                        top: 28,
                        width: (block.duration / 24 * width)
                            .clamp(52.0, width)
                            .toDouble(),
                        height: 88,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) =>
                              onMove(block, details.delta.dx / width * 24),
                          onLongPress: () => onRemove(block),
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: block.color,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: block.color.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  block.category,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${block.duration.toStringAsFixed(1)} h',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.86),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 134,
                      child: Container(
                        height: 1,
                        color: const Color(0xFF4A2022).withValues(alpha: 0.12),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatHour(0), style: _labelStyle),
                          Text(formatHour(6), style: _labelStyle),
                          Text(formatHour(12), style: _labelStyle),
                          Text(formatHour(18), style: _labelStyle),
                          Text(formatHour(24), style: _labelStyle),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tip: long-press a block to remove it.',
            style: TextStyle(color: Colors.black45, fontSize: 11),
          ),
        ],
      ),
    );
  }

  static const _labelStyle = TextStyle(
    color: Colors.black54,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );
}

class _OverflowNotice extends StatelessWidget {
  final double hours;
  final VoidCallback onCompress;

  const _OverflowNotice({required this.hours, required this.onCompress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2D5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFB38A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFF9B5A3C)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${hours.toStringAsFixed(1)} hours planned — that is over your 24-hour capacity.',
              style: const TextStyle(
                color: Color(0xFF6D3A2B),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(onPressed: onCompress, child: const Text('Compress')),
        ],
      ),
    );
  }
}
