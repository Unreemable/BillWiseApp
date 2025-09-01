import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BillWise')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: ()=>Navigator.pushNamed(context, '/ocr'),
            child: const Text('Scan Bill (OCR)'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: ()=>Navigator.pushNamed(context, '/add-bill'),
            child: const Text('Add Bill Manually'),
          ),
        ],
      ),
    );
  }
}
