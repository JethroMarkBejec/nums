class CookieFlavor {
  final String id;
  final String name;
  final int boxPrice;
  final bool isAvailable;
  final String description;
  final List<String> listedIngredients;

  const CookieFlavor({
    required this.id,
    required this.name,
    required this.boxPrice,
    this.isAvailable = true,
    this.description = '',
    this.listedIngredients = const [],
  });

  double get pricePerCookie => boxPrice / 6;
}

class CookieCatalog {
  static const flavors = <CookieFlavor>[
    CookieFlavor(
        id: 'butter-cookie',
        name: 'Butter Cookie',
        boxPrice: 120,
        description: 'Classic buttery cookie.'),
    CookieFlavor(
        id: 'chocolate-chip',
        name: 'Chocolate Chip',
        boxPrice: 150,
        description: 'Loaded with chocolate chips.'),
    CookieFlavor(
        id: 'sugar-cookie',
        name: 'Sugar Cookie',
        boxPrice: 130,
        description: 'Soft, sweet, and festive.'),
  ];

  static CookieFlavor? find(String query) {
    final normalized = query.toLowerCase();
    for (final flavor in flavors) {
      if (normalized.contains(flavor.name.toLowerCase()) ||
          normalized.contains(flavor.id.replaceAll('-', ' '))) return flavor;
    }
    if (normalized.contains('choco')) return flavors[1];
    if (normalized.contains('butter')) return flavors[0];
    if (normalized.contains('sugar')) return flavors[2];
    return null;
  }
}
