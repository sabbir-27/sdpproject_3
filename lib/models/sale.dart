class Sale {
  final String id;
  final String customer;
  final double amount;
  final DateTime date;
  final String paymentMethod;

  Sale({
    required this.id,
    required this.customer,
    required this.amount,
    required this.date,
    required this.paymentMethod,
  });
}
