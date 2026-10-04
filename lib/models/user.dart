class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final int points;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.points = 0,
  });

  AppUser copyWith({int? points}) => AppUser(
        id: id,
        name: name,
        email: email,
        role: role,
        points: points ?? this.points,
      );
}
