import '../providers/auth_provider.dart';

/// Local point rules. A server-side implementation can replace this repository
/// later while the UI continues to use the same operations.
class PointsRepository {
  static const feedbackReward = 5;
  static const newFlavorReward = 2;

  final Map<String, Set<String>> _feedbackAwards = {};
  final Map<String, Set<String>> _flavorAwards = {};

  int balance(AuthProvider auth, String email) =>
      auth.pointsForAccount(email) ?? 0;

  bool awardGamePoints(
    AuthProvider auth, {
    required String email,
    required int points,
  }) {
    if (points <= 0) return false;
    return _changeBalance(auth, email, points);
  }

  bool awardFeedback(
    AuthProvider auth, {
    required String email,
    required String feedbackId,
  }) {
    return _awardOnce(
      auth,
      email: email,
      id: feedbackId,
      reward: feedbackReward,
      awards: _feedbackAwards,
    );
  }

  bool awardNewFlavor(
    AuthProvider auth, {
    required String email,
    required String flavorId,
  }) {
    return _awardOnce(
      auth,
      email: email,
      id: flavorId,
      reward: newFlavorReward,
      awards: _flavorAwards,
    );
  }

  bool redeemPoints(
    AuthProvider auth, {
    required String email,
    required int points,
  }) {
    if (points <= 0) return false;
    final current = balance(auth, email);
    if (current < points) return false;
    return auth.setPointsBalance(email, current - points);
  }

  bool _awardOnce(
    AuthProvider auth, {
    required String email,
    required String id,
    required int reward,
    required Map<String, Set<String>> awards,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedId = id.trim();
    if (normalizedEmail.isEmpty || normalizedId.isEmpty) return false;
    final userAwards = awards.putIfAbsent(normalizedEmail, () => <String>{});
    if (userAwards.contains(normalizedId)) return false;
    if (!_changeBalance(auth, normalizedEmail, reward)) return false;
    userAwards.add(normalizedId);
    return true;
  }

  bool _changeBalance(AuthProvider auth, String email, int difference) {
    final current = balance(auth, email);
    if (auth.pointsForAccount(email) == null) return false;
    return auth.setPointsBalance(email, current + difference);
  }
}
