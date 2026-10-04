class PaymentService {
  Future<bool> processPayment(double amount, String method) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return amount > 0 && method.isNotEmpty;
  }
}
