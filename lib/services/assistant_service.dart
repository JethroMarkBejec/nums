class AssistantService {
  static const _menu = <({String name, int price})>[
    (name: 'Butter Cookie', price: 120),
    (name: 'Chocolate Chip', price: 150),
    (name: 'Sugar Cookie', price: 130),
  ];

  static const destinations = <AssistantAction>[
    AssistantAction(label: 'Open Home', route: '/home'),
    AssistantAction(label: 'Open Menu', route: '/menu'),
    AssistantAction(label: 'Open Cart', route: '/cart'),
    AssistantAction(label: 'Open Orders', route: '/orders'),
    AssistantAction(label: 'Open Notifications', route: '/notifications'),
    AssistantAction(label: 'Open Profile', route: '/profile'),
  ];

  /// Local rule-based guide. It does not send messages to an online AI.
  Future<AssistantReply> getReply(String query,
      {bool preferTagalog = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final message = query.trim().toLowerCase();
    final tagalog = preferTagalog || _isTagalog(message);

    if (_isGreeting(message)) {
      return AssistantReply(
        text: tagalog
            ? 'Kumusta! Maaari kitang tulungan pumili ng cookies o maghanap ng '
                'screen sa app. Pumili ng button sa ibaba o sabihin kung ano '
                'ang kailangan mo.'
            : 'Hi! I can help you choose cookies or find a screen in the app. '
                'Choose a button below or tell me what you need.',
        actions: destinations,
      );
    }

    if (_matches(message, const ['redeem', 'points', 'reward', 'puntos'])) {
      return AssistantReply(
          text: tagalog
              ? 'May local points rewards sa account mo. Sabihin ang “redeem free cookie” kung may 20 points ka; susuriin ko muna ang balance.'
              : 'Points are stored in your local demo account. Say “redeem free cookie” to use 20 points; I will check your balance first.',
          actions: const [
            AssistantAction(label: 'Open Profile', route: '/profile')
          ]);
    }
    if (_matches(message,
        const ['build a box', 'custom box', 'mix a box', 'build my box'])) {
      return const AssistantReply(
          text:
              'Choose a 4, 6, or 12-cookie box, then tap or drag flavors into the slots.',
          actions: [
            AssistantAction(label: 'Build a Box', route: '/build-box')
          ]);
    }

    if (_matches(message, const [
      'help',
      'tulong',
      'screen reader',
      "can't read",
      'cant read',
      'cannot read',
      "can't see",
      'cant see',
      'blind',
      'bulag',
      'hindi makakita',
      'hindi makabasa',
      'navigate',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'Pindutin ang mga button para buksan ang Home, Menu, Cart, '
                'Orders, '
                'Notifications, o Profile. May label ang bawat button para '
                'mabasa ito ng screen reader.'
            : 'Use the labeled buttons below to open Home, Menu, Cart, Orders, '
                'Notifications, or Profile. A screen reader can '
                'read each button label aloud.',
        actions: destinations,
      );
    }

    if (_matches(message, const ['allerg', 'ingredient', 'gluten', 'nut'])) {
      return AssistantReply(
        text: tagalog
            ? 'Wala akong beripikadong impormasyon tungkol sa allergens. '
                'Magtanong muna sa panaderya bago umorder kung may allergy ka.'
            : 'I do not have verified allergen information. Please ask the '
                'bakery before ordering if you have an allergy or dietary '
                'restriction.',
      );
    }

    if (_matches(message, const [
      'order status',
      'order progress',
      'track',
      'tracking',
      'status',
      'delivery',
      'sundan',
      'nasaan ang order',
      'update sa order',
      'my orders',
      'orders',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'Buksan ang Orders para makita ang kasalukuyang status. Maaari '
                'itong maging Confirmed, Mixing, Baking, Cooling, Packed, o '
                'Ready for pickup/delivery.'
            : 'Open Orders to see current progress: Confirmed, Mixing, Baking, '
                'Cooling, Packed, or Ready for pickup/delivery. Updates also '
                'appear in Notifications.',
        actions: const [
          AssistantAction(label: 'Open Orders', route: '/orders'),
          AssistantAction(label: 'Open Notifications', route: '/notifications'),
        ],
      );
    }

    if (_matches(message, const ['notification', 'abiso', 'alerts'])) {
      return AssistantReply(
        text: tagalog
            ? 'Dito makikita ang mga update tungkol sa order mo.'
            : 'Notifications shows updates about your orders.',
        actions: const [
          AssistantAction(label: 'Open Notifications', route: '/notifications'),
        ],
      );
    }

    if (_matches(message, const ['profile', 'account', 'my details'])) {
      return AssistantReply(
        text: tagalog
            ? 'Buksan ang Profile para makita ang impormasyon ng account mo.'
            : 'Open Profile to view your account information and account '
                'actions.',
        actions: const [
          AssistantAction(label: 'Open Profile', route: '/profile'),
        ],
      );
    }

    if (_matches(message, const [
      'cart',
      'basket',
      'shopping bag',
      'cart ko',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'Sa Cart mo masusuri ang items at dami bago mag-checkout.'
            : 'Open Cart to review your items and quantities before checkout.',
        actions: const [AssistantAction(label: 'Open Cart', route: '/cart')],
      );
    }

    if (_matches(message, const [
      'checkout',
      'payment',
      'gcash',
      'maya',
      'gotyme',
      'bayad',
      'magbayad',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'Buksan ang Cart at magpatuloy sa checkout. Maaari mong piliin '
                'ang GCash, Maya, o GoTyme. Simulasyon lang ang bayad at '
                'walang '
                'sisingilin sa iyo.'
            : 'Open Cart and continue to checkout. You can select GCash, Maya, '
                'or GoTyme. Payment is simulated; no money is charged.',
        actions: const [AssistantAction(label: 'Open Cart', route: '/cart')],
      );
    }

    if (_matches(message, const [
      'custom',
      'mix-in',
      'mix in',
      'oat',
      'chips',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'May chocolate chips at rolled oats na kasama sa customization. '
                'Pumili ng cookie sa Menu para makita ang order options.'
            : 'Chocolate chips and rolled oats are listed as included mix-ins. '
                'Choose a cookie in Menu to see its order options.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    if (_matches(message, const [
      'home',
      'start',
      'bahay',
      'tahanan',
      'umpisa',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'Buksan ang Home para makita ang mga tampok at notification.'
            : 'Open Home to see featured items and notifications.',
        actions: const [AssistantAction(label: 'Open Home', route: '/home')],
      );
    }

    if (_matches(message, const [
      'menu',
      'browse',
      'pumili',
      'cookie menu',
      'show cookies',
      'order cookies',
      'mag order',
      'mag-order',
      'umorder',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'Sa Menu, pumili ng cookie at box size. Pindutin ang Menu para '
                'makapagsimula.'
            : 'Open Menu to browse cookies. Choose an item there to select a '
                'box size and continue ordering.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    if (_matches(message, const [
      'tomorrow',
      'pickup',
      'pick up',
      'pre-order',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'Para sa pickup o delivery bukas, piliin ang cookies sa Menu at '
                'suriin ang petsa sa checkout.'
            : 'For pickup or delivery tomorrow, choose cookies in Menu and '
                'review the date during checkout.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    if (_matches(message, const [
      'box size',
      'box of',
      'sizes',
      'size',
      'kahon',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'Pumili ng kahon na may 3, 6, o 12 cookies. Makikita ang '
                'pagpipilian '
                'pagkatapos pumili ng item sa Menu.'
            : 'Choose a box of 3, 6, or 12 cookies. The size options appear '
                'after you select an item from Menu.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    final budget = _findBudget(message);
    if (budget != null) {
      final match = _menu.where((cookie) => cookie.price <= budget).toList();
      final choices =
          match.map((cookie) => '${cookie.name} (₱${cookie.price})').join(', ');
      return AssistantReply(
        text: match.isEmpty
            ? 'The listed box of 6 starts at ₱${_menu.first.price}. Smaller '
                'box sizes are available in the order flow.'
            : 'For a budget of ₱${budget.toStringAsFixed(0)}, these listed '
                'six-cookie boxes fit: $choices. Smaller sizes are available '
                'in the order flow.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    if (_matches(message, const ['share', 'party', 'gift', 'family'])) {
      return AssistantReply(
        text: tagalog
            ? 'Para sa saluhan, maaari kang pumili ng kahon na may 3, 6, o 12 '
                'cookies. Tingnan ang Menu para sa flavors at presyo.'
            : 'For sharing, choose a box of 3, 6, or 12 cookies. Open Menu to '
                'see the flavors and prices.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    if (_matches(message, const ['chocolate', 'choc'])) {
      return AssistantReply(
        text: tagalog
            ? 'Ang Chocolate Chip ay ₱150 para sa kahon na may 6 cookies. '
                'Makakapili ka rin ng ibang box size.'
            : 'Chocolate Chip is ₱150 for the listed box of 6. You can choose '
                'a different box size in the order flow.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    if (_matches(message, const ['butter', 'classic'])) {
      return AssistantReply(
        text: tagalog
            ? 'Ang Butter Cookie ay ₱120 para sa kahon na may 6 cookies.'
            : 'Butter Cookie is ₱120 for the listed box of 6.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    if (_matches(message, const ['sugar', 'sweet'])) {
      return AssistantReply(
        text: tagalog
            ? 'Ang Sugar Cookie ay ₱130 para sa kahon na may 6 cookies.'
            : 'Sugar Cookie is ₱130 for the listed box of 6.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    if (_matches(message, const [
      'menu',
      'price',
      'cost',
      'cookie',
      'recommend',
      'masarap',
      'what options',
      'choices',
    ])) {
      return AssistantReply(
        text: tagalog
            ? 'May Butter Cookie (₱120), Chocolate Chip (₱150), at Sugar '
                'Cookie (₱130) sa Menu. Presyo ito para sa kahon na may 6. '
                'Pindutin ang Menu para pumili.'
            : 'The menu has Butter Cookie (₱120), Chocolate Chip (₱150), and '
                'Sugar Cookie (₱130), each listed for a box of 6. Open Menu '
                'to choose a cookie and size.',
        actions: const [AssistantAction(label: 'Open Menu', route: '/menu')],
      );
    }

    return AssistantReply(
      text: tagalog
          ? 'Maaari mong sabihin ang “buksan ang Menu,” “tingnan ang Cart,” '
              'o “sundan ang order.” Maaari ka ring pumili ng screen sa mga '
              'button sa ibaba.'
          : 'Try “open Menu,” “show my Cart,” or “track my order.” You can '
              'also choose a destination from the buttons below.',
      actions: destinations,
    );
  }

  bool _matches(String message, List<String> keywords) =>
      keywords.any((keyword) => message.contains(keyword));

  bool _isGreeting(String message) {
    final normalized = message.replaceAll(RegExp(r'[^a-z\s]'), '').trim();
    return const ['hi', 'hello', 'hey', 'good morning', 'good afternoon']
            .contains(normalized) ||
        normalized.startsWith('hi ') ||
        normalized.startsWith('hello ') ||
        normalized.startsWith('hey ');
  }

  bool _isTagalog(String message) {
    final words = message.split(RegExp(r'[^a-zñ]+'));
    return const {
      'kumusta',
      'paano',
      'saan',
      'gusto',
      'masarap',
      'magkano',
      'presyo',
      'tulong',
      'buksan',
      'pumili',
      'sundan',
      'bayad',
      'kahon',
      'anong',
      'ano',
      'meron',
      'hindi',
      'bulag',
      'makakita',
      'makabasa',
      'po',
      'ng',
    }.any(words.contains);
  }

  double? _findBudget(String message) {
    if (!_matches(message, const ['budget', 'under', 'below', '₱', 'php'])) {
      return null;
    }
    final amount = RegExp(r'\d+(?:\.\d+)?').firstMatch(message)?.group(0);
    return amount == null ? null : double.tryParse(amount);
  }
}

class AssistantReply {
  final String text;
  final List<AssistantAction> actions;

  const AssistantReply({required this.text, this.actions = const []});
}

class AssistantAction {
  final String label;
  final String route;

  const AssistantAction({required this.label, required this.route});
}
