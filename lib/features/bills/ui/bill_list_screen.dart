import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/bill_repo.dart';
import '../models/bill.dart';

class BillListScreen extends StatefulWidget {
  const BillListScreen({super.key});
  @override
  State<BillListScreen> createState() => _BillListScreenState();
}

class _BillListScreenState extends State<BillListScreen> {
  final _search = TextEditingController();

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final all = BillRepo.instance.all();
    final items = all.where((b) =>
      _search.text.trim().isEmpty ||
      b.vendor.toLowerCase().contains(_search.text.trim().toLowerCase())
    ).toList();

    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-bill'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), notchMargin: 8,
        child: SizedBox(height: 56, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
            IconButton(onPressed: ()=>Navigator.pushNamed(context, '/ocr'), icon: const Icon(Icons.document_scanner_outlined)),
          ],
        )),
      ),
      body: Column(
        children: [
          _ListHeader(
            title: 'All Bills',
            search: _search,
            rightIcons: const [Icons.document_scanner_outlined, Icons.filter_list],
            onRightTap: (i) {
              if (i == 0) Navigator.pushNamed(context, '/ocr');
            },
          ),
          Expanded(
            child: items.isEmpty
              ? const Center(child: Text('No bills yet'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _BillCard(item: items[i]),
                ),
          ),
        ],
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  const _BillCard({required this.item});
  final Bill item;

  double _progress(DateTime start, DateTime end) {
    final now = DateTime.now();
    if (now.isBefore(start)) return 0;
    if (now.isAfter(end)) return 1;
    final total = end.difference(start).inSeconds;
    final done  = now.difference(start).inSeconds;
    return (done / total).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('y MMM d');
    final next = item.returnBy ?? item.warrantyUntil;
    final percent = next == null ? null : _progress(item.purchaseDate, next);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {/* لاحقًا: صفحة تفاصيل */},
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF3F2B96), Color(0xFFA8C0FF)],
            begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.receipt_long_outlined, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(item.vendor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                const Icon(Icons.chevron_right, color: Colors.white),
              ]),
              const SizedBox(height: 6),
              Text('Date: ${df.format(item.purchaseDate)} • Amount: ${item.amount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: percent, minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader({
    required this.title,
    required this.search,
    required this.rightIcons,
    required this.onRightTap,
  });

  final String title;
  final TextEditingController search;
  final List<IconData> rightIcons;
  final void Function(int index) onRightTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B5CF6), Color(0xFFA58BFF)],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط البحث
          TextField(
            controller: search,
            onChanged: (_) => (context as Element).markNeedsBuild(),
            decoration: InputDecoration(
              hintText: 'Search by name',
              filled: true, fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              const Spacer(),
              for (int i=0; i<rightIcons.length; i++) ...[
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  child: IconButton(
                    onPressed: () => onRightTap(i),
                    icon: Icon(rightIcons[i], color: Colors.white, size: 18),
                    splashRadius: 18,
                  ),
                ),
                if (i != rightIcons.length-1) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
