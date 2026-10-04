import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/requests_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_screen_scaffold.dart';

class FlavorIdeasScreen extends StatefulWidget {
  const FlavorIdeasScreen({super.key});
  @override
  State<FlavorIdeasScreen> createState() => _FlavorIdeasScreenState();
}

class _FlavorIdeasScreenState extends State<FlavorIdeasScreen> {
  final _idea = TextEditingController();
  @override
  void dispose() {
    _idea.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requests = context.watch<RequestsProvider>();
    final email = context.watch<AuthProvider>().email ?? '';
    final ideas = requests.flavorRequests;
    return AppScreenScaffold(
        title: 'Flavor ideas',
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text('Vote for a future cookie', style: AppTextStyles.display1(24)),
          const SizedBox(height: 6),
          Text('Suggest a flavor, then upvote ideas you like.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          TextField(
              controller: _idea,
              maxLength: 60,
              decoration: const InputDecoration(labelText: 'Flavor idea')),
          Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                  onPressed: () {
                    final flavor = _idea.text.trim();
                    if (flavor.isEmpty) return;
                    requests.create(
                        email: email,
                        type: 'flavor',
                        message: 'Flavor suggestion: $flavor',
                        data: {
                          'flavor': flavor,
                          'votes': 0,
                          'voters': <String>{}
                        });
                    _idea.clear();
                  },
                  child: const Text('Submit idea'))),
          const SizedBox(height: 12),
          for (final idea in ideas)
            Card(
                child: ListTile(
              title: Text(idea['flavor'] as String),
              subtitle: Text('${idea['status']} · ${idea['votes'] ?? 0} votes'),
              trailing: IconButton(
                  tooltip: 'Upvote flavor',
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () =>
                      requests.upvoteFlavor(idea['id'] as String, email)),
            )),
        ]));
  }
}
