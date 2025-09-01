class NerResult {
  final String? vendor; final DateTime? date; final double? amount;
  final DateTime? returnBy; final DateTime? warrantyUntil;
  NerResult({this.vendor,this.date,this.amount,this.returnBy,this.warrantyUntil});
}

class NerService {
  NerResult parse(String raw) {
    final dateMatch = RegExp(r'(\d{4})[/-](\d{1,2})[/-](\d{1,2})').firstMatch(raw);
    DateTime? date;
    if (dateMatch != null) {
      date = DateTime.utc(int.parse(dateMatch.group(1)!), int.parse(dateMatch.group(2)!), int.parse(dateMatch.group(3)!));
    }
    final amt = RegExp(r'(total|amount|المجموع)[^\d]*(\d+([.,]\d{1,2})?)', caseSensitive: false).firstMatch(raw);
    final amount = amt != null ? double.tryParse(amt.group(2)!.replaceAll(',', '')) : null;
    return NerResult(date: date, amount: amount);
  }
}
