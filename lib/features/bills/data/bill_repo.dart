import 'package:uuid/uuid.dart';
import '../models/bill.dart';

class BillRepo {
  BillRepo._();
  static final BillRepo instance = BillRepo._();

  final _items = <Bill>[];

  List<Bill> all() {
    // ترتيب تصاعدي حسب أقرب موعد (returnBy/warrantyUntil) ثم بتاريخ الشراء
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
    DateTime? warrantyUntil,
  }) {
    final b = Bill(
      id: const Uuid().v4(),
      vendor: vendor,
      amount: amount,
      purchaseDate: purchaseDate,
      returnBy: returnBy,
      warrantyUntil: warrantyUntil,
    );
    _items.add(b);
    return b;
  }
}
