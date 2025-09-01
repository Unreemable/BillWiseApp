import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});
  @override State<AddBillScreen> createState()=>_AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _vendor = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _purchaseDate;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _vendor, decoration: const InputDecoration(labelText: 'Vendor')),
            TextField(controller: _amount, decoration: const InputDecoration(labelText: 'Total Amount'), keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(_purchaseDate==null ? 'Pick purchase date' : 'Date: ${df.format(_purchaseDate!)}')),
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
            const Spacer(),
            ElevatedButton(
              onPressed: (){
                // لاحقًا: حفظ في Firestore
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved (demo)')));
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
