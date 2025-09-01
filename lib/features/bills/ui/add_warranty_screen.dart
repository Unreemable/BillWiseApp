import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../bills/data/bill_repo.dart';

class AddWarrantyScreen extends StatefulWidget {
  const AddWarrantyScreen({super.key});
  @override
  State<AddWarrantyScreen> createState() => _AddWarrantyScreenState();
}

class _AddWarrantyScreenState extends State<AddWarrantyScreen> {
  final _productName = TextEditingController();
  final _vendor = TextEditingController();
  final _billNo = TextEditingController();
  final _serial = TextEditingController();
  final _duration = TextEditingController(text: '12'); // أشهر افتراضيًا
  final _reminderDays = TextEditingController();       // اختياري

  DateTime? _startDate;
  DateTime? _expiryDate;
  String _unit = 'months'; // months | years
  final _formKey = GlobalKey<FormState>();
  final _df = DateFormat('yyyy-MM-dd');

  @override
  void dispose() {
    _productName.dispose(); _vendor.dispose(); _billNo.dispose();
    _serial.dispose(); _duration.dispose(); _reminderDays.dispose();
    super.dispose();
  }

  DateTime _addMonths(DateTime d, int months) {
    final m = d.month + months;
    final y = d.year + ((m - 1) ~/ 12);
    final nm = ((m - 1) % 12) + 1;
    final day = d.day;
    final lastDay = DateTime(y, nm + 1, 0).day;
    return DateTime(y, nm, day > lastDay ? lastDay : day);
  }

  void _recomputeExpiry() {
    if (_startDate == null) return;
    final n = int.tryParse(_duration.text.trim());
    if (n == null) return;
    setState(() {
      _expiryDate = (_unit == 'years') ? DateTime(_startDate!.year + n, _startDate!.month, _startDate!.day)
                                       : _addMonths(_startDate!, n);
    });
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDate: _startDate ?? now,
    );
    if (picked != null) {
      setState(() => _startDate = picked);
      _recomputeExpiry();
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate() || _startDate == null || _expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields')));
      return;
    }

    // نخزن كسجل من نوع "ضمان": amount = 0، تاريخ الشراء = بداية الضمان
    BillRepo.instance.add(
      vendor: _vendor.text.trim(),
      amount: 0.0,
      purchaseDate: _startDate!,
      warrantyStartDate: _startDate!,
      warrantyUntil: _expiryDate!,
      productName: _productName.text.trim(),
      billNumber: _billNo.text.trim().isEmpty ? null : _billNo.text.trim(),
      serialNumber: _serial.text.trim().isEmpty ? null : _serial.text.trim(),
    );

    // مبدئيًا: نعرض نجاح الحفظ (التذكير الحقيقي لاحقًا مع FCM)
    final remind = int.tryParse(_reminderDays.text.trim() );
    if (remind != null) {
      // لاحقًا: نحسب تاريخ التذكير ونخزنه في Firestore/FCM
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Warranty saved')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: const Icon(Icons.save),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: const SizedBox(height: 56),
      ),
      body: Column(
        children: [
          // الهيدر المتدرّج
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B5CF6), Color(0xFFA58BFF)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: const Text(
              'Warranty Information',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),

          // النموذج
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  TextFormField(
                    controller: _productName,
                    decoration: const InputDecoration(labelText: 'Product Name *'),
                    validator: (v) => (v==null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _vendor,
                    decoration: const InputDecoration(labelText: 'Place of Purchase *'),
                    validator: (v) => (v==null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _billNo,
                    decoration: const InputDecoration(labelText: 'Bill/Invoice No. (optional)'),
                  ),
                  const SizedBox(height: 8),
                  // تاريخ بداية الضمان
                  Row(
                    children: [
                      Expanded(
                        child: Text(_startDate == null
                            ? 'Warranty Start Date *'
                            : 'Warranty Start: ${_df.format(_startDate!)}'),
                      ),
                      IconButton(
                        onPressed: _pickStartDate,
                        icon: const Icon(Icons.date_range),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // المدة + الوحدة
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _duration,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Warranty Duration *'),
                          onChanged: (_) => _recomputeExpiry(),
                          validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a number' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _unit,
                        items: const [
                          DropdownMenuItem(value: 'months', child: Text('Months')),
                          DropdownMenuItem(value: 'years',  child: Text('Years')),
                        ],
                        onChanged: (v) { if (v!=null) { setState(() => _unit = v); _recomputeExpiry(); } },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // تاريخ الانتهاء (محسوب)
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: _expiryDate == null ? 'Auto-calculated' : _df.format(_expiryDate!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _serial,
                    decoration: const InputDecoration(labelText: 'Product Serial Number (optional)'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reminderDays,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reminder days before (optional)'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
