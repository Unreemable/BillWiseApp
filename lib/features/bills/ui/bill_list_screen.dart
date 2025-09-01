import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/bill_repo.dart';
import '../models/bill.dart';

class BillListScreen extends StatefulWidget {
  const BillListScreen({super.key});
  @override State<BillListScreen> createState()=>_BillListScreenState();
}

class _BillListScreenState extends State<BillListScreen> {
  late List<Bill> _items;

  @override
  void initState() {
    super.initState();
    _items = BillRepo.instance.all();
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: const Text('Your Bills')),
      body: _items.isEmpty
          ? const Center(child: Text('No bills yet'))
          : ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __)=>const Divider(height: 1),
              itemBuilder: (_, i){
                final b = _items[i];
                final next = b.returnBy ?? b.warrantyUntil;
                final subtitle = [
                  'Amount: ${b.amount.toStringAsFixed(2)}',
                  'Date: ${df.format(b.purchaseDate)}',
                  if (next != null) 'Next: ${df.format(next)}'
                ].join(' • ');
                return ListTile(
                  title: Text(b.vendor),
                  subtitle: Text(subtitle),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-bill');
          setState(()=> _items = BillRepo.instance.all());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
