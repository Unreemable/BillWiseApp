import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});
  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  final _picker = ImagePicker();
  File? _imageFile;
  String _recognized = '';
  bool _busy = false;

  Future<void> _pick(ImageSource src) async {
    final x = await _picker.pickImage(source: src, imageQuality: 85);
    if (x == null) return;
    setState(() {
      _imageFile = File(x.path);
      _recognized = '';
    });
  }

  Future<void> _runOcr() async {
    if (_imageFile == null) return;
    setState(() => _busy = true);
    try {
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final input = InputImage.fromFile(_imageFile!);
      final result = await recognizer.processImage(input);
      await recognizer.close();
      setState(() => _recognized = result.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OCR error: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _sendToAddBill() {
    if (_recognized.trim().isEmpty) return;
    Navigator.pushNamed(context, '/add-bill',
        arguments: {'ocrText': _recognized});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Camera'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Gallery'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_imageFile!, height: 240, fit: BoxFit.cover),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: (_imageFile == null || _busy) ? null : _runOcr,
            child: _busy
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Run OCR'),
          ),
          const SizedBox(height: 12),
          Text('Recognized text:',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: SelectableText(
              _recognized.isEmpty ? '—' : _recognized,
              style: const TextStyle(height: 1.3),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _recognized.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(
                            ClipboardData(text: _recognized));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied')));
                      },
                icon: const Icon(Icons.copy_all),
                label: const Text('Copy'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _recognized.isEmpty ? null : _sendToAddBill,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Send to Add Bill'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
