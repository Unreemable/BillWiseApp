class Bill {
  final String id;
  final String vendor;
  final double amount;
  final DateTime purchaseDate;
  final DateTime? returnBy;
  final DateTime? warrantyUntil;

  Bill({
    required this.id,
    required this.vendor,
    required this.amount,
    required this.purchaseDate,
    this.returnBy,
    this.warrantyUntil,
  });
}
