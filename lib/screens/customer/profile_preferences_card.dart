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
        for (final allergy in _allergyOptions)
          CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(allergy),
              value: _allergies.contains(allergy),
              onChanged: (checked) => setState(() {
                    checked == true
                        ? _allergies.add(allergy)
                        : _allergies.remove(allergy);
                  })),
        TextField(
            controller: _avoid,
            maxLength: 160,
            decoration:
                const InputDecoration(labelText: 'Other ingredients to avoid')),
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
      const SizedBox(height: 12),
      AppCard(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Payment account',
            style: AppTextStyles.q(18, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
            value: _method,
            decoration: const InputDecoration(labelText: 'Preferred payment'),
            items: const [
              DropdownMenuItem(value: 'GCash', child: Text('GCash')),
              DropdownMenuItem(value: 'Maya', child: Text('Maya')),
              DropdownMenuItem(value: 'Cash', child: Text('Cash'))
            ],
            onChanged: (value) => setState(() => _method = value ?? 'GCash')),
        if (_method != 'Cash')
          TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(labelText: 'Linked mobile number')),
        const SizedBox(height: 8),
        Align(
            alignment: Alignment.centerRight,
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
        Text(
            'Linked account: ${context.watch<PaymentAccountProvider>().accountFor(email)?['number'] ?? 'Not linked'}',
            style: AppTextStyles.q(12, color: AppColors.textSecondary)),
      ])),
      const SizedBox(height: 12),
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
