import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final username = auth.username ?? 'Customer';

    return AppScreenScaffold(
      title: 'My Profile',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.person_rounded,
                      color: Colors.white, size: 52),
                ),
                const SizedBox(height: 12),
                Text(username, style: AppTextStyles.display1(30)),
                const SizedBox(height: 4),
                Text('Customer account',
                    style: AppTextStyles.q(14, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account details',
                    style: AppTextStyles.q(19, weight: FontWeight.w700)),
                const SizedBox(height: 16),
                _ProfileDetail(
                    icon: Icons.person_outline_rounded,
                    label: 'Username',
                    value: username),
                const Divider(height: 24, color: AppColors.divider),
                _ProfileDetail(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email',
                    value: auth.email ?? 'Not signed in'),
                const Divider(height: 24, color: AppColors.divider),
                const _ProfileDetail(
                    icon: Icons.badge_outlined,
                    label: 'Role',
                    value: 'Customer'),
              ],
            ),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.manage_accounts_outlined),
              label: const Text('Open demo staff dashboard'),
              onPressed: () => Navigator.pushNamed(context, '/admin-dashboard'),
            ),
          ],
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () async {
              final shouldSignOut = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Sign out?'),
                  content:
                      const Text('Your cart will be cleared on this device.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Sign out'),
                    ),
                  ],
                ),
              );
              if (shouldSignOut != true || !context.mounted) return;
              context.read<CartProvider>().clear();
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/welcome', (route) => false);
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetail(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.q(12, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.q(15, weight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
