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
            Text('Tap a flavor or drag it into your cookie box.',
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
            _buildBoxPreview(),
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

  Widget _buildBoxPreview() {
    final columns = _size == 4 ? 2 : (_size == 6 ? 3 : 4);
    final rows = (_size / columns).ceil();
    final height = rows * 64.0 + 128;
    return LayoutBuilder(builder: (context, constraints) {
      final cellWidth =
          (constraints.maxWidth - 36 - (columns - 1) * 4) / columns;
      return SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _BakeryBoxPainter())),
            Positioned(
              left: 17,
              right: 17,
              top: 12,
              height: rows * 64.0,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _size,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: cellWidth / 60,
                ),
                itemBuilder: (context, index) => _boxSlot(index),
              ),
            ),
            Positioned(
              left: 28,
              right: 42,
              bottom: 20,
              height: 38,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFD6B785)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33263B4F),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: _gift
                    ? Row(children: [
                        const Icon(Icons.favorite_rounded,
                            size: 15, color: AppColors.primary),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            _note.text.trim().isEmpty
                                ? 'Your gift note goes here'
                                : _note.text.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.q(11,
                                weight: FontWeight.w700,
                                color: AppColors.primary),
                          ),
                        ),
                      ])
                    : Row(children: [
                        const Icon(Icons.cookie_rounded,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 7),
                        Text('NUMS · FRESHLY BAKED',
                            style: AppTextStyles.q(10,
                                weight: FontWeight.w700,
                                color: AppColors.primary)),
                      ]),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _boxSlot(int index) => DragTarget<CookieFlavor>(
        onAcceptWithDetails: (details) {
          if (details.data.isAvailable) {
            setState(() => _slots[index] = details.data);
          }
        },
        builder: (context, candidates, rejected) {
          final flavor = _slots[index];
          return InkWell(
            onTap: flavor == null
                ? null
                : () => setState(() => _slots[index] = null),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: candidates.isNotEmpty
                    ? AppColors.accentSoft
                    : const Color(0xFFE8D4B5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFB79769), width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x35263B4F),
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                  BoxShadow(
                    color: Color(0xAAFFF9ED),
                    blurRadius: 1,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  switchInCurve: Curves.easeOutBack,
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: flavor == null
                      ? Container(
                          key: const ValueKey('empty-cookie-well'),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFC8AC83),
                            border: Border.all(
                                color: const Color(0xFFB79769), width: 1),
                          ),
                          child: const Icon(Icons.add_rounded,
                              size: 20, color: AppColors.textSecondary),
                        )
                      : Tooltip(
                          key: ValueKey(flavor.id),
                          message: '${flavor.name} — tap to remove',
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x553D2916),
                                  blurRadius: 7,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/cookie_oatmeal.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      );
}

class _BakeryBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = RRect.fromRectAndRadius(
        Rect.fromLTWH(5, 4, w - 10, h - 15), const Radius.circular(26));
    canvas.drawShadow(Path()..addRRect(body), const Color(0x66263B4F), 9, true);
    canvas.drawRRect(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE5C99D), Color(0xFFB98C55)],
        ).createShader(Rect.fromLTWH(5, 4, w - 10, h - 15)),
    );

    final frontY = h - 76;
    final side = Path()
      ..moveTo(w - 32, frontY - 12)
      ..lineTo(w - 5, frontY - 1)
      ..lineTo(w - 5, h - 27)
      ..lineTo(w - 32, h - 38)
      ..close();
    canvas.drawPath(
        side,
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFB18148), Color(0xFF8B6038)],
          ).createShader(Rect.fromLTWH(w - 32, frontY, 27, 50)));

    final front = RRect.fromRectAndRadius(
        Rect.fromLTRB(14, frontY - 12, w - 32, h - 20),
        const Radius.circular(12));
    canvas.drawRRect(
      front,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD0A46B), Color(0xFF9A6B3D)],
        ).createShader(Rect.fromLTRB(14, frontY - 12, w - 32, h - 20)),
    );
    canvas.drawRRect(
      front,
      Paint()
        ..color = const Color(0x66835A33)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final top = RRect.fromRectAndRadius(
        Rect.fromLTRB(12, 10, w - 14, frontY - 5), const Radius.circular(20));
    canvas.drawRRect(
        top,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE8BE), Color(0xFFD7B17A)],
          ).createShader(Rect.fromLTRB(12, 10, w - 14, frontY - 5)));
    canvas.drawRRect(
      top,
      Paint()
        ..color = const Color(0x889B744A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _BakeryBoxPainter oldDelegate) => false;
}
