import 'package:flutter/foundation.dart';

class RequestsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _requests = [];
  List<Map<String, dynamic>> get requests => _requests
      .map((request) => Map<String, dynamic>.unmodifiable(request))
      .toList(growable: false);

  void create(
      {required String email,
      required String message,
      String type = 'chat',
      Map<String, dynamic> data = const {}}) {
    _requests.insert(0, {
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'email': email,
      'message': message,
      'type': type,
      ...data,
      'createdAt': DateTime.now(),
      'status': 'Open',
      'reply': null,
    });
    notifyListeners();
  }

  List<Map<String, dynamic>> get flavorRequests =>
      requests.where((item) => item['type'] == 'flavor').toList();
  String? get flavorOfTheMonth {
    final ideas =
        flavorRequests.where((item) => item['status'] != 'Declined').toList();
    if (ideas.isEmpty) return null;
    ideas.sort(
        (a, b) => (b['votes'] as int? ?? 0).compareTo(a['votes'] as int? ?? 0));
    return ideas.first['flavor'] as String?;
  }

  bool upvoteFlavor(String id, String email) {
    final index = _requests
        .indexWhere((item) => item['id'] == id && item['type'] == 'flavor');
    if (index < 0) return false;
    final voters = (_requests[index]['voters'] as Set<String>?) ?? <String>{};
    final key = email.trim().toLowerCase();
    if (key.isEmpty || !voters.add(key)) return false;
    _requests[index]['voters'] = voters;
    _requests[index]['votes'] = voters.length;
    notifyListeners();
    return true;
  }

  void setStatus(String id, String status, {String? reply}) {
    final index = _requests.indexWhere((item) => item['id'] == id);
    if (index < 0) return;
    _requests[index]['status'] = status;
    if (reply != null) _requests[index]['reply'] = reply;
    notifyListeners();
  }

  void reply(String id, String text) {
    final index = _requests.indexWhere((request) => request['id'] == id);
    if (index < 0) return;
    _requests[index]['reply'] = text.trim();
    _requests[index]['status'] = 'Addressed';
    notifyListeners();
  }
}
