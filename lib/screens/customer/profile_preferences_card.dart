import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/allergy_profile_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/payment_account_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';

class ProfilePreferencesCard extends StatefulWidget {
  const ProfilePreferencesCard({super.key});
  @override
  State<ProfilePreferencesCard> createState() => _ProfilePreferencesCardState();
}

class _ProfilePreferencesCardState extends State<ProfilePreferencesCard> {
  static const _allergyOptions = ['Nuts', 'Dairy', 'Gluten', 'Eggs'];
  final _phone = TextEditingController();
  final _avoid = TextEditingController();
  final Set<String> _allergies = {};
  String _method = 'GCash';
  bool _loaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final email = context.read<AuthProvider>().email ?? '';
    _allergies.addAll(context.read<AllergyProfileProvider>().forEmail(email));
    _avoid.text = context.read<AllergyProfileProvider>().noteFor(email);
    final account = context.read<PaymentAccountProvider>().accountFor(email);
    if (account != null) {
      _method = account['method']!;
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    _avoid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthProvider>().email ?? '';
    final savedAccount =
        context.watch<PaymentAccountProvider>().accountFor(email);
    final linkedForSelection =
        savedAccount != null && savedAccount['method'] == _method;
    return Column(children: [
      AppCard(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Allergy profile',
            style: AppTextStyles.q(18, weight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
            'Ingredient recipes are not verified in this local demo. Staff should confirm every allergy request.',
            style: AppTextStyles.q(12, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        for (final allergy in _allergyOptions)
          _AllergyOption(
              label: allergy,
              selected: _allergies.contains(allergy),
              onTap: () => setState(() {
                    if (!_allergies.add(allergy)) _allergies.remove(allergy);
                  })),
        const SizedBox(height: 8),
        TextField(
            controller: _avoid,
            maxLength: 160,
            decoration:
                const InputDecoration(labelText: 'Other ingredients to avoid')),
        const SizedBox(height: 10),
        Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
                onPressed: () {
                  context
                      .read<AllergyProfileProvider>()
                      .save(email, _allergies, _avoid.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Allergy profile saved on this device.')));
                },
                child: const Text('Save allergies'))),
      ])),
      const SizedBox(height: 16),
      AppCard(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Payment account',
            style: AppTextStyles.q(18, weight: FontWeight.w700)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
            value: _method,
            decoration: const InputDecoration(labelText: 'Preferred payment'),
            items: const [
              DropdownMenuItem(value: 'GCash', child: Text('GCash')),
              DropdownMenuItem(value: 'Maya', child: Text('Maya')),
              DropdownMenuItem(value: 'Cash', child: Text('Cash'))
            ],
            onChanged: (value) => setState(() => _method = value ?? 'GCash')),
        if (_method != 'Cash') ...[
          const SizedBox(height: 10),
          TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(labelText: 'Linked mobile number')),
        ],
        const SizedBox(height: 14),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
                color: AppColors.accentSoft.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.cardBorder.withValues(alpha: 0.8))),
            child: Row(children: [
              Icon(
                  _method == 'Cash'
                      ? Icons.payments_outlined
                      : linkedForSelection
                          ? Icons.verified_user_outlined
                          : Icons.phone_iphone_rounded,
                  size: 20,
                  color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                        _method == 'Cash'
                            ? 'Cash selected'
                            : linkedForSelection
                                ? 'Payment number linked'
                                : savedAccount == null
                                    ? 'No payment number linked'
                                    : '${savedAccount['method']} account on file',
                        style: AppTextStyles.q(12, weight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                        _method == 'Cash'
                            ? 'No mobile number needed.'
                            : linkedForSelection
                                ? savedAccount['number'] ?? ''
                                : savedAccount == null
                                    ? 'Enter a number above to link $_method.'
                                    : 'Enter a $_method number above to switch.',
                        style: AppTextStyles.q(12,
                            color: AppColors.textSecondary)),
                  ])),
            ])),
        const SizedBox(height: 16),
        SizedBox(
            width: double.infinity,
            child: FilledButton(
                onPressed: () {
                  if (!context
                      .read<PaymentAccountProvider>()
                      .save(email, _method, _phone.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Enter a valid mobile number, or choose Cash.')));
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Payment preference saved locally.')));
                },
                child: const Text('Save payment preference'))),
      ])),
      const SizedBox(height: 16),
      AppCard(
          child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Filipino language preference'),
              subtitle: const Text(
                  'Toggle primary assistant replies between English and Filipino.'),
              value: context.watch<LanguageProvider>().isTagalog,
              onChanged: (_) => context.read<LanguageProvider>().toggle())),
    ]);
  }
}

class _AllergyOption extends StatelessWidget {
  const _AllergyOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        label: label,
        checked: selected,
        button: true,
        onTap: onTap,
        child: ExcludeSemantics(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: SizedBox(
                height: 42,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(label,
                          style: AppTextStyles.q(14 * 0.75,
                              color: AppColors.textSecondary)),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            selected ? AppColors.primary : Colors.transparent,
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          width: 1.8,
                        ),
                      ),
                      child: selected
                          ? const Icon(Icons.check_rounded,
                              size: 14, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
