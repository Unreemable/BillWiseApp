import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BillWise')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            // Scan by OCR (أساسي)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/ocr'),
                icon: const Icon(Icons.document_scanner_outlined),
                label: const Text('Scan Bill (OCR)'),
              ),
            ),
            const SizedBox(height: 8),

            // Add bill manually (ثانوي)
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => Navigator.pushNamed(context, '/add-bill'),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Bill Manually'),
              ),
            ),
            const SizedBox(height: 8),

            // View bills (قائمة)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/bills'),
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('View Bills'),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            Expanded(
              child: Center(
                child: Text(
                  'Welcome to BillWise 👋\nAdd your first bill to get started.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
