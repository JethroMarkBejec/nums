import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/cookie_catalog.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/daily_batch_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/requests_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../repositories/points_repository.dart';
import '../../../services/chat_repository.dart';
import '../../../services/assistant_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_screen_scaffold.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final ChatRepository _assistant = LocalChatRepository();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Hi! Kumusta! I can help you choose cookies or find a screen. '
          'Choose a labeled destination or ask me where to go.',
      fromAssistant: true,
      actions: AssistantService.destinations,
    ),
  ];
  bool _isReplying = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? suggestedMessage]) async {
    final text = (suggestedMessage ?? _messageController.text).trim();
    if (text.isEmpty || _isReplying) return;

    _messageController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _messages.add(_ChatMessage(text: text, fromAssistant: false));
      _isReplying = true;
    });
    _scrollToBottom();

    try {
      final normalized = text.toLowerCase();
      final auth = context.read<AuthProvider>();
      final email = auth.email ?? '';
      if (normalized.contains('talk to staff') ||
          normalized.contains('human') ||
          normalized.contains('contact admin') ||
          normalized.contains('kausap')) {
        context.read<RequestsProvider>().create(email: email, message: text);
        _appendAssistant(
            'I sent this to the local staff Requests inbox. Staff can open Dashboard → Customer requests to reply.',
            'Ipinadala ko ito sa local Requests inbox ng staff. Makikita nila ito sa Dashboard → Customer requests.');
        return;
      }
      if (normalized.contains('redeem') && normalized.contains('cookie')) {
        final repository = context.read<PointsRepository>();
        final redeemed =
            repository.redeemPoints(auth, email: email, points: 20);
        if (redeemed) {
          final flavor = CookieCatalog.flavors.first;
          context.read<CartProvider>().addItem({
            'id': 'reward-${DateTime.now().microsecondsSinceEpoch}',
            'name': 'Points reward · ${flavor.name}',
            'price': 0,
            'quantity': 1,
            'boxSize': 1,
            'items_summary': '1x ${flavor.name} (20-point reward)',
          });
          _appendAssistant(
              'Done! I used 20 points and added one Butter Cookie reward to your cart. Your balance is now ${repository.balance(auth, email)} points.',
              'Nagamit ko ang 20 points at idinagdag ang Butter Cookie reward sa cart mo. May ${repository.balance(auth, email)} points ka na.');
        } else {
          _appendAssistant(
              'A free cookie costs 20 points. Your current balance is ${repository.balance(auth, email)} points, so I have not changed it.',
              'Kailangan ng 20 points para sa libreng cookie. May ${repository.balance(auth, email)} points ka, kaya walang binago sa balance mo.');
        }
        return;
      }
      final cookie = CookieCatalog.find(text);
      final quantity = int.tryParse(RegExp(r'\b(\d+)\s*(?:boxes?|box|kahon)')
                  .firstMatch(normalized)
                  ?.group(1) ??
              '') ??
          0;
      if (quantity > 0 &&
          cookie != null &&
          cookie.isAvailable &&
          (normalized.contains('box') || normalized.contains('kahon'))) {
        final requestedSize = int.tryParse(RegExp(r'box\s+of\s+(4|6|12)')
                    .firstMatch(normalized)
                    ?.group(1) ??
                '') ??
            6;
        final size = [4, 6, 12].contains(requestedSize) ? requestedSize : 6;
        context.read<CartProvider>().addItem({
          'id': 'assistant-${DateTime.now().microsecondsSinceEpoch}',
          'name': cookie.name,
          'price': cookie.pricePerCookie * size,
          'quantity': quantity,
          'boxSize': size,
          'items_summary':
              '$quantity box${quantity == 1 ? '' : 'es'} of $size · ${cookie.name}',
        });
        final day = RegExp(
                r'\b(on|for)\s+(monday|tuesday|wednesday|thursday|friday|saturday|sunday)\b')
            .firstMatch(normalized)
            ?.group(2);
        _appendAssistant(
            'Added $quantity box${quantity == 1 ? '' : 'es'} of ${cookie.name} to your cart. The local demo checkout currently uses tomorrow’s pickup/delivery date${day == null ? '' : ', so “$day” is noted here but cannot be scheduled in this demo'}.',
            'Idinagdag ko sa cart ang $quantity kahon ng ${cookie.name}. Bukas lang ang petsa sa checkout ng demo na ito${day == null ? '' : ', kaya hindi ma-iiskedyul ang “$day”'}.');
        return;
      }
      if (normalized.contains('batch') ||
          normalized.contains('cookies left') ||
          normalized.contains('remaining')) {
        final batch = context.read<DailyBatchProvider>();
        _appendAssistant(
            'Today’s local demo batch has ${batch.remaining} cookies remaining out of ${batch.dailyLimit}.',
            'May ${batch.remaining} cookies pang kapasidad ang batch ngayon sa local demo.');
        return;
      }
      if (normalized.contains('balance') ||
          normalized.contains('how many points')) {
        final balance = context.read<PointsRepository>().balance(auth, email);
        _appendAssistant(
            'You have $balance points. A free cookie reward costs 20 points; say “redeem free cookie” to use it.',
            'May $balance points ka. Kailangan ng 20 points para sa libreng cookie; sabihin ang “redeem free cookie” para gamitin ito.');
        return;
      }
      if (normalized.contains('allerg') ||
          normalized.contains('ingredient') ||
          normalized.contains('gluten') ||
          normalized.contains('nut')) {
        final flavor = CookieCatalog.find(text);
        final listed = flavor?.listedIngredients.join(', ');
        _appendAssistant(
            flavor == null || listed == null || listed.isEmpty
                ? 'I do not have verified ingredient details for that item. Please confirm directly with bakery staff before ordering if you have an allergy.'
                : '${flavor.name} lists these ingredients: $listed. This demo cannot verify preparation or cross-contact, so please confirm with bakery staff before ordering if you have an allergy.',
            'Wala akong beripikadong impormasyon tungkol sa sangkap o cross-contact. Kumpirmahin muna sa staff bago umorder kung may allergy ka.');
        return;
      }
      if (normalized.contains('my orders') ||
          normalized.contains('order status') ||
          normalized.contains('track my') ||
          normalized.contains('status')) {
        final orders = context.read<OrderProvider>().ordersFor(email);
        if (orders.isNotEmpty) {
          _appendAssistant(
              'Your latest order ${orders.first['id']} is ${orders.first['status']}. Open Orders for its full progress.',
              'Ang pinakabagong order mo na ${orders.first['id']} ay ${orders.first['status']}. Buksan ang Orders para makita ang buong progress.');
          return;
        }
      }
      final reply = await _assistant.replyTo(text,
          preferTagalog: context.read<LanguageProvider>().isTagalog);
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          text: reply.text,
          fromAssistant: true,
          actions: reply.actions,
        ));
        _isReplying = false;
      });
      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(const _ChatMessage(
          text: 'Sorry, I could not prepare a reply. Please try asking in a '
              'different way.',
          fromAssistant: true,
        ));
        _isReplying = false;
      });
      _scrollToBottom();
    }
  }

  void _appendAssistant(String text, [String? filipino]) {
    if (!mounted) return;
    final localized =
        context.read<LanguageProvider>().isTagalog ? (filipino ?? text) : text;
    setState(() {
      _messages.add(_ChatMessage(text: localized, fromAssistant: true));
      _isReplying = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _openAction(AssistantAction action) {
    if (action.route == '/home') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/customer-shell',
        (route) => false,
      );
      return;
    }
    Navigator.pushNamed(context, action.route);
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenScaffold(
      title: 'Cookie Assistant',
      body: Column(
        children: [
          const _LocalAssistantBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Wrap(spacing: 7, runSpacing: 3, children: [
              _QuickPrompt(
                  label: 'Build a box',
                  onTap: () => _sendMessage('Build a box')),
              _QuickPrompt(
                  label: 'My points',
                  onTap: () => _sendMessage('How many points do I have?')),
              _QuickPrompt(
                  label: 'Talk to staff',
                  onTap: () => _sendMessage('I want to talk to staff')),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              itemCount: _messages.length + (_isReplying ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const _TypingIndicator();
                }
                final message = _messages[index];
                return _MessageBubble(
                  key: ValueKey('message-$index'),
                  message: message,
                  onAction: _openAction,
                );
              },
            ),
          ),
          _MessageComposer(
            controller: _messageController,
            isReplying: _isReplying,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _QuickPrompt extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickPrompt({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) =>
      ActionChip(label: Text(label), onPressed: onTap);
}

class _LocalAssistantBanner extends StatelessWidget {
  const _LocalAssistantBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const ExcludeSemantics(
            child: Icon(Icons.offline_bolt_rounded,
                color: AppColors.primary, size: 19),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Semantics(
              label: 'Local Cookie Assistant. Screen-reader-friendly guided '
                  'navigation. Type in English or Tagalog. Replies stay on '
                  'this device.',
              child: ExcludeSemantics(
                child: Text(
                  'Screen-reader guide · English and Tagalog',
                  style: AppTextStyles.q(12,
                      weight: FontWeight.w600, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  final TextEditingController controller;
  final bool isReplying;
  final VoidCallback onSend;

  const _MessageComposer({
    required this.controller,
    required this.isReplying,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        border: const Border(top: BorderSide(color: AppColors.cardBorder)),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              style: AppTextStyles.q(14),
              decoration: InputDecoration(
                labelText: 'Message the Cookie Assistant',
                hintText: 'Ask in English or Tagalog…',
                hintStyle: AppTextStyles.q(13, color: AppColors.textSecondary),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.88),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          SizedBox(
            width: 46,
            height: 46,
            child: Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              elevation: 3,
              shadowColor: AppColors.primary.withValues(alpha: 0.28),
              child: IconButton(
                tooltip: 'Send message',
                onPressed: isReplying ? null : onSend,
                color: Colors.white,
                icon: isReplying
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.arrow_upward_rounded, size: 23),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  final ValueChanged<AssistantAction> onAction;

  const _MessageBubble({
    super.key,
    required this.message,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isAssistant = message.fromAssistant;
    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.76,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isAssistant
            ? Colors.white.withValues(alpha: 0.92)
            : AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isAssistant ? 5 : 18),
          bottomRight: Radius.circular(isAssistant ? 18 : 5),
        ),
        border: isAssistant ? Border.all(color: AppColors.cardBorder) : null,
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Semantics(
        liveRegion: isAssistant,
        label: '${isAssistant ? 'Cookie Assistant' : 'You'}: ${message.text}',
        child: ExcludeSemantics(
          child: Text(
            message.text,
            style: AppTextStyles.q(13,
                color: isAssistant ? AppColors.textPrimary : Colors.white,
                height: 1.35),
          ),
        ),
      ),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 8),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment:
              isAssistant ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment:
                  isAssistant ? MainAxisAlignment.start : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isAssistant) ...[
                  const ExcludeSemantics(
                    child: Padding(
                      padding: EdgeInsets.only(right: 7),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.accentSoft,
                        child: Icon(Icons.cookie_rounded,
                            color: AppColors.primary, size: 16),
                      ),
                    ),
                  ),
                  Flexible(child: bubble),
                ] else
                  Flexible(child: bubble),
              ],
            ),
            if (isAssistant && message.actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 35, top: 7),
                child: Wrap(
                  spacing: 7,
                  runSpacing: 6,
                  children: [
                    for (final action in message.actions)
                      ActionChip(
                        label: Text(action.label),
                        labelStyle: AppTextStyles.q(11,
                            weight: FontWeight.w700,
                            color: AppColors.textPrimary),
                        avatar: Icon(_routeIcon(action.route), size: 15),
                        backgroundColor: AppColors.accentSoft,
                        side: const BorderSide(color: AppColors.cardBorder),
                        onPressed: () => onAction(action),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 35),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const SizedBox(
            width: 36,
            height: 12,
            child: _TypingDots(),
          ),
        ),
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
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          final phase = (_controller.value - index * 0.18) % 1.0;
          final opacity = 0.35 + (0.65 * (1 - (phase - 0.5).abs() * 2));
          return Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: opacity),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool fromAssistant;
  final List<AssistantAction> actions;

  const _ChatMessage({
    required this.text,
    required this.fromAssistant,
    this.actions = const [],
  });
}

IconData _routeIcon(String route) => switch (route) {
      '/home' => Icons.home_rounded,
      '/menu' => Icons.menu_book_rounded,
      '/customization' => Icons.tune_rounded,
      '/cart' => Icons.shopping_cart_rounded,
      '/orders' => Icons.receipt_long_rounded,
      '/notifications' => Icons.notifications_rounded,
      _ => Icons.person_rounded,
    };
