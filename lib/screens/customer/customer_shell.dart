import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/gradient_background.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'menu_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _selectedIndex = 0;

  static const _tabs = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.fact_check_outlined, Icons.fact_check_rounded, 'Menu'),
    (Icons.shopping_cart_outlined, Icons.shopping_cart_rounded, 'Cart'),
    (Icons.checklist_rounded, Icons.checklist_rounded, 'Orders'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final navVerticalOffset = MediaQuery.of(context).viewPadding.bottom / 2;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final screens = [
      const HomeScreen(),
      const MenuScreen(),
      const CartScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: reduceMotion ? 1 : 200),
          reverseDuration: Duration(milliseconds: reduceMotion ? 1 : 160),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.018),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey(_selectedIndex),
            child: screens[_selectedIndex],
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          heroTag: 'customer-chip-assistant',
          tooltip: 'Open Chip',
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          onPressed: () => Navigator.pushNamed(context, '/assistant'),
          child: const Icon(Icons.chat_rounded),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            border: Border(
              top: BorderSide(
                  color: AppColors.cardBorder.withValues(alpha: 0.8)),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 68,
              child: Transform.translate(
                offset: Offset(0, navVerticalOffset),
                child: Row(
                  children: [
                    for (var i = 0; i < _tabs.length; i++)
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          splashColor: AppColors.accent.withValues(alpha: 0.18),
                          onTap: () => setState(() => _selectedIndex = i),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOut,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(
                                      i == _selectedIndex
                                          ? _tabs[i].$2
                                          : _tabs[i].$1,
                                      size: 24,
                                      color: i == _selectedIndex
                                          ? AppColors.primary
                                          : AppColors.navInactive,
                                    ),
                                    if (i == 2 && cartCount > 0)
                                      Positioned(
                                        right: -10,
                                        top: -6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: const BoxDecoration(
                                              color: AppColors.error,
                                              shape: BoxShape.circle),
                                          child: Text('$cartCount',
                                              style: AppTextStyles.q(9,
                                                  weight: FontWeight.w700,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _tabs[i].$3,
                                style: AppTextStyles.q(
                                  11,
                                  weight: i == _selectedIndex
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: i == _selectedIndex
                                      ? AppColors.primary
                                      : AppColors.navInactive,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
