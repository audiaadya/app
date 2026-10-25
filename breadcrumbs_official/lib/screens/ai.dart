import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: _AiChatState.backgroundColor,
      body: AiChat(),
    );
  }
}

class _Msg {
  final String text;
  final bool fromUser;
  const _Msg(this.text, this.fromUser);
}

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  static const backgroundColor = Color(0xFFF8E99A);
  static const inkColor = Color(0xFF3B2930);
  static const lavender = Color(0xFF5B2845);

  final _controller = TextEditingController();
  final _messages = <_Msg>[
    const _Msg('Explain my activity for this week.', true),
    const _Msg(
      'Sure! You spent 3 hours on Physics Olympiad prep, 2 hours on AMC practice, and 1 hour on AP Biology review. You also bookmarked several resources on robotics for future reference. Would you like me to recommend activities and resources for next week based on your interests?',
      false,
    ),
  ];
  bool _typing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Msg(text, true));
      _controller.clear();
      _typing = true;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        _messages.add(
          const _Msg(
            'Based off what you engaged with last week, you should focus on practicing more physics problems and reviewing AP Biology concepts. I recommend checking out the Physics Olympiad resources you bookmarked and spending some time on the AP Biology Penguins website for additional practice.',
            false,
          ),
        );
      });
    });
  }

  void _sendPrompt(String prompt) {
    _controller.text = prompt;
    _send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: inkColor,
        elevation: 0,
        titleSpacing: 18,
        title: const Row(
          children: [
            _AssistantAvatar(size: 38),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study buddy',
                  style: TextStyle(
                    color: inkColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'always rooting for you',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: 'Clear conversation',
              onPressed: () => setState(() {
                _messages
                  ..clear()
                  ..add(
                    const _Msg(
                      'Hi! I’m ready to help you make sense of your learning week.',
                      false,
                    ),
                  );
                _typing = false;
              }),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const _WelcomeCard(),
          _PromptChips(onPromptSelected: _sendPrompt),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (context, i) {
                if (_typing && i == _messages.length) {
                  return const _Bubble(fromUser: false, child: _TypingDots());
                }
                final m = _messages[i];
                return _Bubble(
                  fromUser: m.fromUser,
                  child: Text(
                    m.text,
                    style: TextStyle(
                      color: m.fromUser ? Colors.white : inkColor,
                      height: 1.4,
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Ask your study buddy…',
                        hintStyle: TextStyle(
                          color: inkColor.withValues(alpha: 0.45),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(
                            color: lavender.withValues(alpha: 0.12),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(
                            color: lavender.withValues(alpha: 0.12),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(
                            color: lavender,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _send,
                    style: IconButton.styleFrom(
                      backgroundColor: lavender,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(48, 48),
                    ),
                    icon: const Icon(Icons.arrow_upward_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssistantAvatar extends StatelessWidget {
  final double size;

  const _AssistantAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5B2845), Color(0xFFD96C5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        color: Colors.white,
        size: size * .5,
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFBF2), Color(0xFFF0D2BD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'What are we figuring out today?',
                  style: TextStyle(
                    color: _AiChatState.inkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'I can spot patterns, make a plan, or cheer you on.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    height: 1.3,
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

class _PromptChips extends StatelessWidget {
  final ValueChanged<String> onPromptSelected;

  const _PromptChips({required this.onPromptSelected});

  @override
  Widget build(BuildContext context) {
    const prompts = [
      ('Weekly recap', Icons.auto_graph_rounded),
      ('Make me a plan', Icons.calendar_month_rounded),
      ('Find my pattern', Icons.insights_rounded),
    ];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: prompts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final prompt = prompts[index];
          return ActionChip(
            onPressed: () => onPromptSelected(prompt.$1),
            avatar: Icon(prompt.$2, size: 16, color: _AiChatState.lavender),
            label: Text(prompt.$1),
            labelStyle: const TextStyle(
              color: _AiChatState.inkColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: _AiChatState.lavender.withValues(alpha: 0.15),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          );
        },
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final bool fromUser;
  final Widget child;
  const _Bubble({required this.fromUser, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: fromUser ? _AiChatState.lavender : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(19),
                topRight: const Radius.circular(19),
                bottomLeft: Radius.circular(fromUser ? 19 : 5),
                bottomRight: Radius.circular(fromUser ? 5 : 19),
              ),
              boxShadow: [
                BoxShadow(
                  color: _AiChatState.inkColor.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_c.value + i * 0.2) % 1.0;
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(
                  alpha: 0.4 + 0.6 * (1 - (t - 0.5).abs() * 2),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
