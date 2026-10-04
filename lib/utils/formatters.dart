class AppFormatters {
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String formatCurrency(double value) {
    return '₱${value.toStringAsFixed(2)}';
  }

  /// ₱220 (no decimals when whole).
  static String peso(num value) {
    final whole = value == value.roundToDouble();
    return '₱${whole ? value.toStringAsFixed(0) : value.toStringAsFixed(2)}';
  }

  /// September 21, 2026
  static String longDate(DateTime d) =>
      '${_months[d.month - 1]} ${d.day}, ${d.year}';

  /// 9:42 PM
  static String time12(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m ${d.hour >= 12 ? 'PM' : 'AM'}';
  }

  static DateTime tomorrow([DateTime? from]) {
    final n = from ?? DateTime.now();
    return DateTime(n.year, n.month, n.day).add(const Duration(days: 1));
  }
}
