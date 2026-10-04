import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/cookie_catalog.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/daily_batch_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/allergy_profile_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_screen_scaffold.dart';
import '../../../widgets/request_more_slots_dialog.dart';

class BuildBoxScreen extends StatefulWidget {
  const BuildBoxScreen({super.key});

  @override
  State<BuildBoxScreen> createState() => _BuildBoxScreenState();
}

class _BuildBoxScreenState extends State<BuildBoxScreen> {
  static const _sizes = [4, 6, 12];
  int _size = 6;
  late List<CookieFlavor?> _slots = List.filled(_size, null);
  bool _gift = false;
  final _note = TextEditingController();
  final _from = TextEditingController();
  final _to = TextEditingController();
  final _avoid = TextEditingController();
  final Set<String> _exclusions = {};

  @override
  void initState() {
    super.initState();
    _note.addListener(_refreshGiftPreview);
    _from.addListener(_refreshGiftPreview);
    _to.addListener(_refreshGiftPreview);
  }

  void _refreshGiftPreview() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _note.removeListener(_refreshGiftPreview);
    _from.removeListener(_refreshGiftPreview);
    _to.removeListener(_refreshGiftPreview);
    _note.dispose();
    _from.dispose();
    _to.dispose();
    _avoid.dispose();
    super.dispose();
  }

  int get _filled => _slots.whereType<CookieFlavor>().length;
  double get _price => _slots
      .whereType<CookieFlavor>()
      .fold<double>(0, (sum, flavor) => sum + flavor.pricePerCookie);

  void _changeSize(int size) {
    setState(() {
      final filled = _slots.whereType<CookieFlavor>().toList();
      _size = size;
      _slots = List<CookieFlavor?>.generate(
          size, (index) => index < filled.length ? filled[index] : null);
    });
  }

  void _putNext(CookieFlavor flavor) {
    if (!flavor.isAvailable) return;
    final index = _slots.indexWhere((slot) => slot == null);
    if (index < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('This box is full. Remove a cookie first.')));
      return;
    }
    setState(() => _slots[index] = flavor);
  }

  void _autoFill() {
    final available =
        CookieCatalog.flavors.where((flavor) => flavor.isAvailable).toList();
    if (available.isEmpty) return;
    setState(() {
      var nextFlavor = 0;
      _slots = _slots
          .map((slot) => slot ?? available[nextFlavor++ % available.length])
          .toList();
    });
  }

  Future<void> _addBox() async {
    if (_filled != _size) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fill all $_size slots before adding this box.')));
      return;
    }
    final capacity = context.read<DailyBatchProvider>();
    var size = _size;
    if (!capacity.canReserve(size)) {
      final available = _sizes
          .where((option) => option < size && capacity.canReserve(option))
          .toList();
      if (available.isEmpty) {
        await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Daily batch is full'),
                  content: Text(
                      'Only ${capacity.remaining} cookies remain, so this box cannot be added.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showRequestMoreSlotsDialog(
                              this.context,
                              this.context.read<AuthProvider>().email ?? '',
                              size);
                        },
                        child: const Text('Request more slots')),
                  ],
                ));
        return;
      }
      final selected = await showDialog<int>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Choose a smaller box'),
                content: Text(
                    'Only ${capacity.remaining} cookies remain in today’s demo batch. Choose a size that fits.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  for (final option in available)
                    TextButton(
                        onPressed: () => Navigator.pop(context, option),
                        child: Text('Reduce to $option')),
                ],
              ));
      if (selected == null || !mounted) return;
      size = selected;
    }

    final counts = <String, int>{};
    for (final flavor in _slots.take(size).whereType<CookieFlavor>()) {
      counts.update(flavor.name, (value) => value + 1, ifAbsent: () => 1);
    }
    final summary =
        'Box of $size: ${counts.entries.map((entry) => '${entry.value}x ${entry.key}').join(', ')}';
    final unitPrice = _slots
        .take(size)
        .whereType<CookieFlavor>()
        .fold<double>(0, (sum, flavor) => sum + flavor.pricePerCookie);
    final id = 'custom-${DateTime.now().microsecondsSinceEpoch}';
    context.read<CartProvider>().addItem({
      'id': id,
      'name': 'Build-a-Box',
      'price': unitPrice,
      'quantity': 1,
      'boxSize': size,
      'items_summary': summary,
      if (_exclusions.isNotEmpty || _avoid.text.trim().isNotEmpty)
        'exclusions': [
          ..._exclusions,
          if (_avoid.text.trim().isNotEmpty) _avoid.text.trim()
        ],
      if (_gift) 'gift_note': _note.text.trim(),
      if (_gift) 'gift_from': _from.text.trim(),
      if (_gift) 'gift_to': _to.text.trim(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Custom box added to cart.')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final capacity = context.watch<DailyBatchProvider>();
    return AppScreenScaffold(
      title: 'Build-a-Box',
      body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text('Make your own cookie mix', style: AppTextStyles.display1(24)),
            const SizedBox(height: 4),
            Text('Tap a flavor or drag it into a dotted slot.',
                style: AppTextStyles.q(14, color: AppColors.textSecondary)),
            const SizedBox(height: 14),
            Wrap(
                spacing: 8,
                children: _sizes
                    .map((size) => ChoiceChip(
                          label: Text('$size slots'),
                          selected: _size == size,
                          onSelected: (_) => _changeSize(size),
                        ))
                    .toList()),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: Text('$_filled of $_size filled',
                      style: AppTextStyles.q(15, weight: FontWeight.w700))),
              Text('₱${_price.toStringAsFixed(_price % 1 == 0 ? 0 : 2)}',
                  style: AppTextStyles.q(17, weight: FontWeight.w700)),
            ]),
            const SizedBox(height: 8),
            Wrap(
                spacing: 9,
                runSpacing: 9,
                children: List.generate(
                    _size,
                    (index) => DragTarget<CookieFlavor>(
                          onAcceptWithDetails: (details) {
                            if (details.data.isAvailable)
                              setState(() => _slots[index] = details.data);
                          },
                          builder: (context, candidates, rejected) => InkWell(
                            onTap: _slots[index] == null
                                ? null
                                : () => setState(() => _slots[index] = null),
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 58,
                              height: 58,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: candidates.isNotEmpty
                                      ? AppColors.accentSoft
                                      : Colors.white.withValues(alpha: .7),
                                  borderRadius: BorderRadius.circular(16)),
                              child: CustomPaint(
                                foregroundPainter: _DottedSlotBorder(
                                    color: AppColors.primary
                                        .withValues(alpha: .55)),
                                child: Center(
                                    child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 260),
                                  switchInCurve: Curves.elasticOut,
                                  transitionBuilder: (child, animation) =>
                                      ScaleTransition(
                                          scale: animation, child: child),
                                  child: _slots[index] == null
                                      ? const Icon(Icons.add_rounded,
                                          key: ValueKey('empty-slot'),
                                          color: AppColors.textSecondary)
                                      : Tooltip(
                                          key: ValueKey(_slots[index]!.id),
                                          message:
                                              '${_slots[index]!.name} — tap to remove',
                                          child: const Text('🍪',
                                              style: TextStyle(fontSize: 26))),
                                )),
                              ),
                            ),
                          ),
                        ))),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton.icon(
                  onPressed: _autoFill,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const Text('Auto-fill')),
              TextButton.icon(
                  onPressed: () =>
                      setState(() => _slots = List.filled(_size, null)),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear box')),
            ]),
            const SizedBox(height: 6),
            Text('Choose flavors', style: AppTextStyles.display1(19)),
            if (context
                .watch<AllergyProfileProvider>()
                .forEmail(context.watch<AuthProvider>().email ?? '')
                .isNotEmpty)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                      'Allergy profile saved: confirm this box with bakery staff before payment.',
                      style: AppTextStyles.q(13,
                          weight: FontWeight.w700, color: AppColors.error))),
            const SizedBox(height: 8),
            for (final flavor in CookieCatalog.flavors)
              Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Opacity(
                      opacity: flavor.isAvailable ? 1 : .45,
                      child: Draggable<CookieFlavor>(
                          data: flavor,
                          maxSimultaneousDrags: flavor.isAvailable ? 1 : 0,
                          feedback: Material(
                              color: Colors.transparent,
                              child: Chip(
                                  avatar: const Text('🍪'),
                                  label: Text(flavor.name))),
                          childWhenDragging: const SizedBox.shrink(),
                          child: ListTile(
                              tileColor: Colors.white.withValues(alpha: .55),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              enabled: flavor.isAvailable,
                              onTap: flavor.isAvailable
                                  ? () => _putNext(flavor)
                                  : null,
                              leading: const CircleAvatar(child: Text('🍪')),
                              title: Text(flavor.name),
                              subtitle: Text(flavor.isAvailable
                                  ? 'Tap to add · ₱${flavor.pricePerCookie.toStringAsFixed(2)} each'
                                  : 'Unavailable'),
                              trailing:
                                  const Icon(Icons.drag_indicator_rounded))))),
            const SizedBox(height: 4),
            SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Add a gift note'),
                value: _gift,
                onChanged: (value) => setState(() => _gift = value)),
            const SizedBox(height: 6),
            Text('Allergy exclusions (staff review required)',
                style: AppTextStyles.q(16, weight: FontWeight.w700)),
            Wrap(
              spacing: 4,
              children: ['Nuts', 'Dairy', 'Gluten', 'Eggs']
                  .map((name) => FilterChip(
                        label: Text(name),
                        selected: _exclusions.contains(name),
                        onSelected: (selected) => setState(() => selected
                            ? _exclusions.add(name)
                            : _exclusions.remove(name)),
                      ))
                  .toList(),
            ),
            TextField(
                controller: _avoid,
                maxLength: 160,
                decoration: const InputDecoration(
                    labelText: 'Other ingredients to avoid')),
            if (_gift) ...[
              TextField(
                  controller: _note,
                  maxLength: 120,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      labelText: 'Gift message',
                      hintText: 'Write a short note')),
              Row(children: [
                Expanded(
                    child: TextField(
                        controller: _from,
                        decoration: const InputDecoration(labelText: 'From'))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        controller: _to,
                        decoration: const InputDecoration(labelText: 'To')))
              ]),
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('A little note for you'),
                            Text(_note.text.isEmpty
                                ? 'Your message will appear here.'
                                : _note.text),
                            if (_from.text.isNotEmpty || _to.text.isNotEmpty)
                              Text('From ${_from.text} · To ${_to.text}')
                          ]))),
            ],
            const SizedBox(height: 8),
            if (_size > capacity.remaining)
              Text(
                  'Today’s demo batch has ${capacity.remaining} cookies left. A smaller size may be needed.',
                  style: AppTextStyles.q(13, color: AppColors.error)),
            FilledButton.icon(
                onPressed: _addBox,
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text('Add box · ₱${_price.toStringAsFixed(2)}')),
            Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/custom-request'),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Send a different custom request'))),
          ]),
    );
  }
}

class _DottedSlotBorder extends CustomPainter {
  final Color color;
  const _DottedSlotBorder({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(16)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    for (final metric in path.computeMetrics()) {
      for (double distance = 2; distance < metric.length; distance += 8) {
        canvas.drawCircle(
            metric.getTangentForOffset(distance)!.position, 1.15, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedSlotBorder oldDelegate) =>
      color != oldDelegate.color;
}
