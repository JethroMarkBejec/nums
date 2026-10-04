import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class ReviewsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> get reviews =>
      _reviews.map(Map<String, dynamic>.unmodifiable).toList();
  double get averageRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.fold<int>(
            0, (total, review) => total + (review['rating'] as int)) /
        _reviews.length;
  }

  bool add(
      {required String orderId,
      required String email,
      required int rating,
      required String comment,
      List<String> flavors = const [],
      String? photoName,
      Uint8List? photoBytes}) {
    if (_reviews.any((review) => review['orderId'] == orderId) ||
        rating < 1 ||
        rating > 5) return false;
    _reviews.add({
      'orderId': orderId,
      'email': email,
      'rating': rating,
      'comment': comment.trim(),
      'flavors': flavors,
      if (photoName != null) 'photoName': photoName,
      if (photoBytes != null) 'photoBytes': Uint8List.fromList(photoBytes),
      'createdAt': DateTime.now()
    });
    notifyListeners();
    return true;
  }

  double averageFor(String flavor) {
    final ids = _reviews
        .map((review) => (review['flavors'] as List?)?.contains(flavor) == true
            ? review
            : null)
        .whereType<Map<String, dynamic>>();
    final values = ids.map((review) => review['rating'] as int).toList();
    return values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length;
  }
}
