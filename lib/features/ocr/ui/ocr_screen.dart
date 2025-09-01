import 'package:flutter/material.dart';

class OCRScreen extends StatelessWidget {
  const OCRScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR')),
      body: const Center(child: Text('Soon: capture image + extract text')),
    );
  }
}
