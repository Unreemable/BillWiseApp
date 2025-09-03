class Bill {
  final String id;
  final String vendor;
  final double amount;
  final DateTime purchaseDate;

  final DateTime? returnBy;
  final DateTime? warrantyStartDate;
  final DateTime? warrantyUntil;

  // معلومات إضافية (اختيارية)
  final String? productName;
  final String? billNumber;
  final String? serialNumber;

  Bill({
    required this.id,
    required this.vendor,
    required this.amount,
    required this.purchaseDate,
    this.returnBy,
    this.warrantyStartDate,
    this.warrantyUntil,
    this.productName,
    this.billNumber,
    this.serialNumber,
  });
}
