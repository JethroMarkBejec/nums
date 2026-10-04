import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';

class DesignPreviewScreen extends StatelessWidget {
  const DesignPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8E9F0),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              _PhoneMockup(
                accent: Color(0xFFEDF7FB),
                screen: _LoginScreenMockup(),
              ),
              SizedBox(width: 24),
              _PhoneMockup(
                accent: Color(0xFFDDEEF4),
                screen: _HomeScreenMockup(),
              ),
              SizedBox(width: 24),
              _PhoneMockup(
                accent: Color(0xFFDDEEF4),
                screen: _ProductScreenMockup(),
              ),
              SizedBox(width: 24),
              _PhoneMockup(
                accent: Color(0xFFDDEEF4),
                screen: _SummaryScreenMockup(),
              ),
              SizedBox(width: 24),
              _PhoneMockup(
                accent: Color(0xFFDDEEF4),
                screen: _ConfirmationScreenMockup(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  final Color accent;
  final Widget screen;

  const _PhoneMockup({required this.accent, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 392,
      height: 840,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(42),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.22),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: Colors.black87, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: screen,
        ),
      ),
    );
  }
}

class _LoginScreenMockup extends StatelessWidget {
  const _LoginScreenMockup();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDCECF3),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('9:41',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18 * AppTextStyles.scaleFactor)),
              Row(children: [
                Icon(Icons.signal_cellular_4_bar, size: 16),
                SizedBox(width: 4),
                Icon(Icons.wifi, size: 16),
                SizedBox(width: 4),
                Icon(Icons.battery_5_bar, size: 16)
              ]),
            ],
          ),
          const SizedBox(height: 22),
          const Text('noms',
              style: TextStyle(
                  fontSize: 32 * AppTextStyles.scaleFactor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  color: Color(0xFF1B2D39),
                  fontFamily: 'Georgia')),
          const SizedBox(height: 16),
          const Text('Welcome back!',
              style: TextStyle(
                  fontSize: 30 * AppTextStyles.scaleFactor,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF243C4A))),
          const SizedBox(height: 22),
          _field('Email or Phone Number'),
          const SizedBox(height: 12),
          _field('Password', obscure: true),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(children: [
                Checkbox(value: false, onChanged: null),
                Text('Remember Me')
              ]),
              Text('Forgot Password?',
                  style: TextStyle(
                      color: Color(0xFF2A4B5E), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF304B5D),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
                child: Text('Log in',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18 * AppTextStyles.scaleFactor))),
          ),
          const SizedBox(height: 16),
          const Text('or',
              style: TextStyle(
                  fontSize: 18 * AppTextStyles.scaleFactor,
                  color: Colors.black54)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFEBF7FB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF304B5D), width: 1.5),
            ),
            child: const Center(
                child: Text('Create a New Account',
                    style: TextStyle(
                        color: Color(0xFF1D3C4F),
                        fontWeight: FontWeight.w700,
                        fontSize: 18 * AppTextStyles.scaleFactor))),
          ),
          const Spacer(),
          const Text(
              'By continuing, you agree to our Terms of Service and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11 * AppTextStyles.scaleFactor,
                  color: Color(0xFF536D7A))),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _field(String label, {bool obscure = false}) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB6D0DA)),
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration.collapsed(
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFF496679))),
      ),
    );
  }
}

class _HomeScreenMockup extends StatelessWidget {
  const _HomeScreenMockup();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDDEEF4),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('9:41',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20 * AppTextStyles.scaleFactor)),
              Row(children: [
                Icon(Icons.signal_cellular_4_bar, size: 16),
                SizedBox(width: 4),
                Icon(Icons.wifi, size: 16),
                SizedBox(width: 4),
                Icon(Icons.battery_5_bar, size: 16)
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hi, Jethro,',
                  style: TextStyle(
                      fontSize: 24 * AppTextStyles.scaleFactor,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF234052))),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFDFE9ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.person_outline, color: Color(0xFF25465D)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: const Text('Good things are baking!',
                style: TextStyle(
                    color: Color(0xFF4A6677),
                    fontSize: 15 * AppTextStyles.scaleFactor)),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF304B5D),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Today\'s Batch',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18 * AppTextStyles.scaleFactor,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('191 cookies left',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16 * AppTextStyles.scaleFactor)),
                    Text('3/ 4',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14 * AppTextStyles.scaleFactor)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 30,
                  width: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B6474),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                      child: Text('Orders still open',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              _MiniCard(title: 'Tomorrow\'s Delivery', subtitle: 'pre-order'),
              SizedBox(width: 12),
              _MiniCard(title: 'Today\'s Specials', subtitle: 'fresh batch'),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Today\'s Specials',
              style: TextStyle(
                  fontSize: 17 * AppTextStyles.scaleFactor,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF243C4A))),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                  child: _CookieItemCard(label: 'Cinnamon', price: '₱180')),
              SizedBox(width: 10),
              Expanded(
                  child: _CookieItemCard(label: 'Dark Choco', price: '₱120')),
            ],
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.home, color: Color(0xFF2C4557)),
                Icon(Icons.menu_book, color: Color(0xFF2C4557)),
                Icon(Icons.shopping_bag, color: Color(0xFF2C4557)),
                Icon(Icons.receipt_long, color: Color(0xFF2C4557)),
                Icon(Icons.person_outline, color: Color(0xFF2C4557)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _MiniCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 78,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE0EEF3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB2CBD6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: Color(0xFF1F3B4B))),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(
                    color: Color(0xFF5B7180),
                    fontSize: 11 * AppTextStyles.scaleFactor)),
          ],
        ),
      ),
    );
  }
}

class _CookieItemCard extends StatelessWidget {
  final String label;
  final String price;

  const _CookieItemCard({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFE9F0F4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB7CCD6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFD2A770),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Color(0xFF1D3A4A))),
          Text(price, style: const TextStyle(color: Color(0xFF416172))),
        ],
      ),
    );
  }
}

class _ProductScreenMockup extends StatelessWidget {
  const _ProductScreenMockup();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDDEEF4),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('9:41',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20 * AppTextStyles.scaleFactor)),
              Row(children: [
                Icon(Icons.signal_cellular_4_bar, size: 16),
                SizedBox(width: 4),
                Icon(Icons.wifi, size: 16),
                SizedBox(width: 4),
                Icon(Icons.battery_5_bar, size: 16)
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.arrow_back_ios_new, size: 18),
              const SizedBox(width: 8),
              const Text('Order Details',
                  style: TextStyle(
                      fontSize: 22 * AppTextStyles.scaleFactor,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F3D4F))),
              const Spacer(),
              const Icon(Icons.shopping_cart_outlined)
            ],
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3F5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB8CDD8)),
            ),
            child: Row(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7A871),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Oatmeal Chocolate Chip',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18 * AppTextStyles.scaleFactor,
                              color: Color(0xFF1F3D4F))),
                      SizedBox(height: 8),
                      Text(
                          'Soft, chewy, and packed with chunks of chocolate and oats.',
                          style: TextStyle(
                              color: Color(0xFF5C7280),
                              fontSize: 12 * AppTextStyles.scaleFactor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('Choose Box Size',
                  style: TextStyle(
                      fontSize: 18 * AppTextStyles.scaleFactor,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF21405C)))),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                  child: _SizeOption(
                      label: 'Box of 5', price: '₱220', selected: true)),
              SizedBox(width: 12),
              Expanded(
                  child: _SizeOption(
                      label: 'Box of 6', price: '₱260', selected: false)),
              SizedBox(width: 12),
              Expanded(
                  child: _SizeOption(
                      label: 'Box of 12', price: '₱440', selected: false)),
            ],
          ),
          const SizedBox(height: 22),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('Quantity',
                  style: TextStyle(
                      fontSize: 18 * AppTextStyles.scaleFactor,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF21405C)))),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3F5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.remove, color: Color(0xFF23425A)),
                Text('1',
                    style: TextStyle(
                        fontSize: 24 * AppTextStyles.scaleFactor,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F3D4F))),
                Icon(Icons.add, color: Color(0xFF23425A)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
              'This item is included in the daily preorder limit (500 cookies).',
              style: TextStyle(
                  fontSize: 12 * AppTextStyles.scaleFactor,
                  color: Color(0xFF5C7280))),
          const Spacer(),
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF2F485E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
                child: Text('Add to Cart | ₱110',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18 * AppTextStyles.scaleFactor))),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SizeOption extends StatelessWidget {
  final String label;
  final String price;
  final bool selected;

  const _SizeOption(
      {required this.label, required this.price, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEAFAF9) : const Color(0xFFE9EFF3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color:
                selected ? const Color(0xFF2F485E) : const Color(0xFFB8CDD8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: const Color(0xFFD7A871),
                  borderRadius: BorderRadius.circular(12))),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 12 * AppTextStyles.scaleFactor,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F3D4F))),
          Text(price,
              style: const TextStyle(
                  fontSize: 11 * AppTextStyles.scaleFactor,
                  color: Color(0xFF5C7280))),
        ],
      ),
    );
  }
}

class _SummaryScreenMockup extends StatelessWidget {
  const _SummaryScreenMockup();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDDEEF4),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('9:41',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20 * AppTextStyles.scaleFactor)),
              Row(children: [
                Icon(Icons.signal_cellular_4_bar, size: 16),
                SizedBox(width: 4),
                Icon(Icons.wifi, size: 16),
                SizedBox(width: 4),
                Icon(Icons.battery_5_bar, size: 16)
              ]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.arrow_back_ios_new, size: 18),
              SizedBox(width: 8),
              Text('Payment',
                  style: TextStyle(
                      fontSize: 22 * AppTextStyles.scaleFactor,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F3D4F))),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3F5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB7CBD5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order Summary',
                    style: TextStyle(
                        fontSize: 20 * AppTextStyles.scaleFactor,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F3D4F))),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(
                        child: Text('Oatmeal Chocolate Chip',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    Text('₱220'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(
                        child: Text('Mins-in',
                            style: TextStyle(color: Color(0xFF4B6778)))),
                    Text('₱220'),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: const [
                    Expanded(
                        child: Text('Subtotal',
                            style: TextStyle(color: Color(0xFF4B6778)))),
                    Text('₱220'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(
                        child: Text('Delivery Fee',
                            style: TextStyle(color: Color(0xFF4B6778)))),
                    Text('₱0'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(
                        child: Text('Total',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F3D4F)))),
                    Text('₱220',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F3D4F))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('Payment Method',
                  style: TextStyle(
                      fontSize: 18 * AppTextStyles.scaleFactor,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF21405C)))),
          const SizedBox(height: 10),
          const PaymentOption(label: 'GCash', selected: true),
          const SizedBox(height: 8),
          const PaymentOption(label: 'Maya', selected: false),
          const SizedBox(height: 8),
          const PaymentOption(label: 'GoTume', selected: false),
          const Spacer(),
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF2F485E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
                child: Text('Confirm Payment',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18 * AppTextStyles.scaleFactor))),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final String label;
  final bool selected;

  const PaymentOption({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
                selected ? const Color(0xFF2F485E) : const Color(0xFFBAD0DB)),
      ),
      child: Row(
        children: [
          Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                  color: selected ? const Color(0xFF2F485E) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2F485E)))),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFF21405C))),
          const Spacer(),
          if (selected) const Icon(Icons.check, color: Color(0xFF2F485E)),
        ],
      ),
    );
  }
}

class _ConfirmationScreenMockup extends StatelessWidget {
  const _ConfirmationScreenMockup();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDDEEF4),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('9:41',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20 * AppTextStyles.scaleFactor)),
              Row(children: [
                Icon(Icons.signal_cellular_4_bar, size: 16),
                SizedBox(width: 4),
                Icon(Icons.wifi, size: 16),
                SizedBox(width: 4),
                Icon(Icons.battery_5_bar, size: 16)
              ]),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
                color: Color(0xFF2F485E), shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 18),
          const Text('Order Confirmed!',
              style: TextStyle(
                  fontSize: 26 * AppTextStyles.scaleFactor,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F3D4F))),
          const SizedBox(height: 8),
          const Text('Thank you for supporting our small business!',
              style: TextStyle(
                  color: Color(0xFF587184),
                  fontSize: 14 * AppTextStyles.scaleFactor)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3F5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB7CDD8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Order #NMS-1026',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Color(0xFF1F3D4F))),
                SizedBox(height: 18),
                Row(children: [
                  Expanded(child: Text('Total Amount')),
                  Text('₱220')
                ]),
                SizedBox(height: 10),
                Row(children: [
                  Expanded(child: Text('Payment Method')),
                  Text('GCash')
                ]),
                SizedBox(height: 10),
                Row(children: [
                  Expanded(child: Text('Order Date')),
                  Text('September 21, 2026')
                ]),
                SizedBox(height: 10),
                Row(children: [
                  Expanded(child: Text('Delivery Date')),
                  Text('Tomorrow')
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('Order Status',
                  style: TextStyle(
                      fontSize: 18 * AppTextStyles.scaleFactor,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF21405C)))),
          const SizedBox(height: 10),
          const _StatusTimeline(),
          const Spacer(),
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF2F485E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
                child: Text('Back to Home',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18 * AppTextStyles.scaleFactor))),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF2F485E), size: 18),
            SizedBox(width: 10),
            Text('Ordered Place',
                style: TextStyle(
                    color: Color(0xFF23465F), fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.timelapse, color: Color(0xFF2F485E), size: 18),
            SizedBox(width: 10),
            Text('Baking',
                style: TextStyle(
                    color: Color(0xFF23465F), fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.check_circle_outline,
                color: Color(0xFF93A9B5), size: 18),
            SizedBox(width: 10),
            Text('Out for Delivery',
                style: TextStyle(
                    color: Color(0xFF93A9B5), fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.check_circle_outline,
                color: Color(0xFF93A9B5), size: 18),
            SizedBox(width: 10),
            Text('Delivered',
                style: TextStyle(
                    color: Color(0xFF93A9B5), fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
