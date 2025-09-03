import 'package:uuid/uuid.dart';
import '../models/bill.dart';

class BillRepo {
  BillRepo._();
  static final BillRepo instance = BillRepo._();

  final _items = <Bill>[];

  List<Bill> all() {
    _items.sort((a, b) {
      final da = a.returnBy ?? a.warrantyUntil ?? a.purchaseDate;
      final db = b.returnBy ?? b.warrantyUntil ?? b.purchaseDate;
      return da.compareTo(db);
    });
    return List.unmodifiable(_items);
  }

  Bill add({
    required String vendor,
    required double amount,
    required DateTime purchaseDate,
    DateTime? returnBy,
    DateTime? warrantyStartDate,
    DateTime? warrantyUntil,
    String? productName,
    String? billNumber,
    String? serialNumber,
  }) {
    final b = Bill(
      id: const Uuid().v4(),
      vendor: vendor,
      amount: amount,
      purchaseDate: purchaseDate,
      returnBy: returnBy,
      warrantyStartDate: warrantyStartDate,
      warrantyUntil: warrantyUntil,
      productName: productName,
      billNumber: billNumber,
      serialNumber: serialNumber,
    );
    _items.add(b);
    return b;
  }
}
