import '../services/payment_service.dart';

class PaymentResult {
  final String status;
  final String reference;
  const PaymentResult({required this.status, required this.reference});
}

abstract class PaymentRepository {
  Future<PaymentResult> pay({required double amount, required String method});
}

/// Local demo adapter; it never stores or submits card details.
class LocalPaymentRepository implements PaymentRepository {
  final PaymentService _service = PaymentService();
  @override
  Future<PaymentResult> pay(
      {required double amount, required String method}) async {
    final paid = await _service.processPayment(amount, method);
    return PaymentResult(
        status: paid ? 'Paid' : 'Pending',
        reference: 'NUMS-${DateTime.now().millisecondsSinceEpoch}');
  }
}
