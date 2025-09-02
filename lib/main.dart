import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp(firebaseReady: true));
  } catch (e) {
    runApp(MyApp(firebaseReady: false, initError: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.firebaseReady = false, this.initError});

  final bool firebaseReady;
  final String? initError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BillWise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(firebaseReady: firebaseReady, initError: initError),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.firebaseReady, this.initError});

  final bool firebaseReady;
  final String? initError;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final ready = widget.firebaseReady;
    final err = widget.initError;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('BillWise Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (ready && err == null) ...[
              const Icon(Icons.verified, size: 48, color: Colors.green),
              const SizedBox(height: 8),
              const Text('Firebase جاهز ✅'),
              const SizedBox(height: 8),
              // 👇 نعرض Project ID
              Text(
                'Project ID: ${DefaultFirebaseOptions.currentPlatform.projectId}',
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
            ] else if (err != null) ...[
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              const Text('تعذر تهيئة Firebase ❌'),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  err,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ] else ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              const Text('جاري التحضير...'),
            ],
            const SizedBox(height: 24),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
