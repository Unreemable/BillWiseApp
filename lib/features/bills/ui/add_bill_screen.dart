import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../ner/data/ner_service.dart';
import '../data/bill_repo.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});
  @override State<AddBillScreen> createState()=>_AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _vendor = TextEditingController();
  final _amount = TextEditingController();
  final _returnDays = TextEditingController();     // اختياري
  final _warrantyMonths = TextEditingController(); // اختياري
  final _ocrText = TextEditingController();        // للصق نص الـ OCR
  DateTime? _purchaseDate;

  final _ner = NerService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bill')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _vendor,
              decoration: const InputDecoration(labelText: 'Vendor *'),
              validator: (v)=> (v==null || v.trim().isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _amount,
              decoration: const InputDecoration(labelText: 'Total Amount *'),
              keyboardType: TextInputType.number,
              validator: (v){
                final x = double.tryParse(v?.replaceAll(',', '.') ?? '');
                return (x==null) ? 'Enter a valid number' : null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(_purchaseDate==null ? 'Pick purchase date *' : 'Date: ${df.format(_purchaseDate!)}')),
                TextButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context, firstDate: DateTime(now.year-5), lastDate: DateTime(now.year+5), initialDate: now,
                    );
                    if (picked!=null) setState(()=>_purchaseDate=picked);
                  },
                  child: const Text('Choose'),
                ),
              ],
            ),
            const Divider(height: 24),

            // اختياري: حساب المواعيد تلقائيًا إذا ما استخدمنا NER
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _returnDays,
                    decoration: const InputDecoration(labelText: 'Return policy (days)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _warrantyMonths,
                    decoration: const InputDecoration(labelText: 'Warranty (months)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            TextFormField(
              controller: _ocrText,
              decoration: const InputDecoration(
                labelText: 'Paste OCR text (optional)',
                alignLabelWithHint: true,
              ),
              minLines: 3, maxLines: 6,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                final r = _ner.parse(_ocrText.text);
                setState(() {
                  if (r.vendor != null && r.vendor!.trim().isNotEmpty) _vendor.text = r.vendor!;
                  if (r.amount != null) _amount.text = r.amount!.toStringAsFixed(2);
                  if (r.date != null) _purchaseDate = r.date;
                  if (r.returnBy != null && r.date != null) {
                    final days = r.returnBy!.difference(r.date!).inDays;
                    _returnDays.text = days.toString();
                  }
                  if (r.warrantyUntil != null && r.date != null) {
                    final months = ((r.warrantyUntil!.year - r.date!.year) * 12) + (r.warrantyUntil!.month - r.date!.month);
                    _warrantyMonths.text = months.toString();
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fields extracted')));
              },
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('Extract from text'),
            ),

            const SizedBox(height: 24),
            FilledButton(
              onPressed: (){
                if(!_formKey.currentState!.validate() || _purchaseDate==null){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill required fields')));
                  return;
                }
                final amount = double.parse(_amount.text.replaceAll(',', '.'));
                final d = _purchaseDate!;
                DateTime? returnBy;
                DateTime? warrantyUntil;

                final rd = int.tryParse(_returnDays.text);
                if (rd != null) returnBy = DateTime(d.year, d.month, d.day).add(Duration(days: rd));

                final wm = int.tryParse(_warrantyMonths.text);
                if (wm != null) {
                  final m = d.month + wm;
                  warrantyUntil = DateTime(d.year + ((m-1)~/12), ((m-1)%12)+1, d.day);
                }

                BillRepo.instance.add(
                  vendor: _vendor.text.trim(),
                  amount: amount,
                  purchaseDate: d,
                  returnBy: returnBy,
                  warrantyUntil: warrantyUntil,
                );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved locally')));
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
