import 'package:flutter/material.dart';
import '../../bills/data/bill_repo.dart';
import '../../bills/models/bill.dart';

enum FilterOption { all, bill, warranty }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  FilterOption _filter = FilterOption.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = BillRepo.instance.all();

    // تطبيق البحث + الفلتر
    final items = all.where((b) {
      final txt = _search.text.trim().toLowerCase();
      final byText = txt.isEmpty || b.vendor.toLowerCase().contains(txt);
      final isWarranty = b.warrantyUntil != null;
      final isBill = !isWarranty || b.returnBy != null;
      final byFilter = _filter == FilterOption.all
          ? true
          : _filter == FilterOption.bill
              ? isBill
              : isWarranty;
      return byText && byFilter;
    }).toList();

    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddChooser(context), // ← نافذة اختيار Bill/Warranty
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.home_filled)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined)),
            ],
          ),
        ),
      ),

      // الجسم
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Header(
              search: _search,
              onScan: () => Navigator.pushNamed(context, '/ocr'),
              onFilter: _openFilterSheet,
              filterLabel: _filter == FilterOption.warranty
                  ? 'Warranty'
                  : _filter == FilterOption.bill
                      ? 'Bill'
                      : 'All',
              onViewBills: () => Navigator.pushNamed(context, '/bills'),
              onViewWarranties: () =>
                  Navigator.pushNamed(context, '/warranties'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text('Recent Bills & Warranty',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          SliverList.builder(
            itemCount: items.length,
            itemBuilder: (context, i) => _BillTile(item: items[i]),
          ),
          if (items.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No items yet. Tap + to add one.'),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // نافذة الفلتر
  Future<void> _openFilterSheet() async {
    var temp = _filter;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              value: FilterOption.warranty,
              groupValue: temp,
              onChanged: (v) => setState(() => temp = v as FilterOption),
              title: const Text('Warranty'),
            ),
            RadioListTile(
              value: FilterOption.bill,
              groupValue: temp,
              onChanged: (v) => setState(() => temp = v as FilterOption),
              title: const Text('Bill'),
            ),
            RadioListTile(
              value: FilterOption.all,
              groupValue: temp,
              onChanged: (v) => setState(() => temp = v as FilterOption),
              title: const Text('All'),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  setState(() => _filter = temp);
                  Navigator.pop(ctx);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نافذة اختيار Bill/Warranty عند الضغط على +
  void _openAddChooser(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Bill Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pushNamed(context, '/add-bill');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Bill\nManual/Scan',
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pushNamed(context, '/add-warranty');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Warranty\nAny device',
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.search,
    required this.onScan,
    required this.onFilter,
    required this.filterLabel,
    required this.onViewBills,
    required this.onViewWarranties,
  });

  final TextEditingController search;
  final VoidCallback onScan;
  final VoidCallback onFilter;
  final String filterLabel;
  final VoidCallback onViewBills;
  final VoidCallback onViewWarranties;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B5CF6), Color(0xFFA58BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // بطاقة Scan + فلتر + روابط سريعة
          Row(
            children: [
              Expanded(child: _ScanCard(onScan: onScan)),
              const SizedBox(width: 12),
              Column(
                children: [
                  IconButton.filledTonal(
                    onPressed: onFilter,
                    icon: const Icon(Icons.filter_list),
                  ),
                  Text(filterLabel, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: onViewBills,
                icon: const Icon(Icons.receipt_long_outlined, color: Colors.white),
                label: const Text('All Bills',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onViewWarranties,
                icon: const Icon(Icons.verified, color: Colors.white),
                label: const Text('All warranties',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({required this.onScan});
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onScan,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.document_scanner_outlined, size: 28),
              SizedBox(width: 8),
              Text('Scan bill', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BillTile extends StatelessWidget {
  const _BillTile({required this.item});
  final Bill item;

  double _progress(DateTime start, DateTime end) {
    final now = DateTime.now();
    if (now.isBefore(start)) return 0;
    if (now.isAfter(end)) return 1;
    final total = end.difference(start).inSeconds;
    final done = now.difference(start).inSeconds;
    return (done / total).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final next = item.returnBy ?? item.warrantyUntil;
    final percent = next == null ? null : _progress(item.purchaseDate, next);

    return ListTile(
      title: Text(item.vendor),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (next != null)
            Text(item.returnBy != null
                ? 'Return by: $next'
                : 'Warranty until: $next'),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {}, // لاحقًا: صفحة تفاصيل
    );
  }
}
