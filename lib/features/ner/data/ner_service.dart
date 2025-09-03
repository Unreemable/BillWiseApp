class NerResult {
  final String? vendor; final DateTime? date; final double? amount;
  final DateTime? returnBy; final DateTime? warrantyUntil;
  NerResult({this.vendor,this.date,this.amount,this.returnBy,this.warrantyUntil});
}

class NerService {
  NerResult parse(String raw) {
    if (raw.isEmpty) return NerResult();

    // التاريخ
    DateTime? purchaseDate;
    final dateMatches = [
      RegExp(r'(\d{4})[/-](\d{1,2})[/-](\d{1,2})'),        // 2025-09-01
      RegExp(r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})'),      // 01/09/2025
    ];
    for (final r in dateMatches) {
      final m = r.firstMatch(raw);
      if (m != null) {
        try {
          if (m.groupCount == 3) {
            final g1 = m.group(1)!, g2 = m.group(2)!, g3 = m.group(3)!;
            if (g1.length == 4) {
              purchaseDate = DateTime(int.parse(g1), int.parse(g2), int.parse(g3));
            } else {
              purchaseDate = DateTime(int.parse(g3), int.parse(g2), int.parse(g1));
            }
            break;
          }
        } catch (_) {}
      }
    }

    // المبلغ
    final amt = RegExp(r'(total|amount|المجموع)[^\d]*(\d+([.,]\d{1,2})?)', caseSensitive: false)
        .firstMatch(raw);
    final amount = amt != null ? double.tryParse(amt.group(2)!.replaceAll(',', '.')) : null;

    // المتجر (تخمين مبسّط: أول سطر نصّي غير فاضي قبل كلمة Invoice/فاتورة)
    String? vendor;
    final lines = raw.split('\n').map((e)=>e.trim()).where((e)=>e.isNotEmpty).toList();
    for (final l in lines) {
      if (RegExp(r'(invoice|فاتورة)', caseSensitive: false).hasMatch(l)) break;
      if (l.length >= 3) { vendor = l; break; }
    }

    // return within X days
    DateTime? returnBy;
    final rDays = RegExp(r'return\s+(within\s+)?(\d{1,2})\s+days', caseSensitive:false).firstMatch(raw);
    if (purchaseDate != null && rDays != null) {
      final days = int.parse(rDays.group(2)!);
      returnBy = DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day).add(Duration(days: days));
    }

    // warranty X months/years
    DateTime? warrantyUntil;
    final w = RegExp(r'warranty\s+(\d{1,2})\s*(month|months|year|years)', caseSensitive:false).firstMatch(raw);
    if (purchaseDate != null && w != null) {
      final n = int.parse(w.group(1)!);
      final unit = w.group(2)!.toLowerCase();
      if (unit.startsWith('year')) {
        warrantyUntil = DateTime(purchaseDate.year + n, purchaseDate.month, purchaseDate.day);
      } else {
        final m = purchaseDate.month + n;
        warrantyUntil = DateTime(purchaseDate.year + ((m-1)~/12), ((m-1)%12)+1, purchaseDate.day);
      }
    }

    return NerResult(
      vendor: vendor,
      date: purchaseDate,
      amount: amount,
      returnBy: returnBy,
      warrantyUntil: warrantyUntil,
    );
  }
}
