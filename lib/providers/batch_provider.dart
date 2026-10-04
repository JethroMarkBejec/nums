import 'package:flutter/foundation.dart';

class BatchProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _batches = [
    {
      'id': 'B-101',
      'name': 'Morning bake',
      'quantity': 300,
      'status': 'In progress',
      'progress': 0.6,
    },
    {
      'id': 'B-102',
      'name': 'Tomorrow preorder',
      'quantity': 200,
      'status': 'Scheduled',
      'progress': 0.2,
    },
  ];

  List<Map<String, dynamic>> get batches => _batches
      .map((batch) => Map<String, dynamic>.unmodifiable(batch))
      .toList(growable: false);

  bool advance(String id) {
    final index = _batches.indexWhere((batch) => batch['id'] == id);
    if (index < 0 || _batches[index]['status'] == 'Complete') return false;

    final progress =
        ((_batches[index]['progress'] as num).toDouble() + 0.2).clamp(0.0, 1.0);
    _batches[index]['progress'] = progress;
    _batches[index]['status'] = progress >= 1 ? 'Complete' : 'In progress';
    notifyListeners();
    return true;
  }
}
