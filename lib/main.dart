import 'package:flutter/material.dart';
import 'core/app_theme.dart';

// Auth + Home
import 'features/auth/ui/login_screen.dart';
import 'features/auth/ui/signup_screen.dart';
import 'features/home/ui/home_screen.dart';

// OCR + Bills
import 'features/ocr/ui/ocr_screen.dart';
import 'features/bills/ui/add_bill_screen.dart';
import 'features/bills/ui/bill_list_screen.dart';
import 'features/bills/ui/warranty_list_screen.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // نهيئة Firebase (لو فشلت، ما نكسر التشغيل)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  runApp(const BillWiseApp());
}

class BillWiseApp extends StatelessWidget {
  const BillWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/login',
      routes: {
        '/login'      : (_) => const LoginScreen(),
        '/signup'     : (_) => const SignupScreen(),
        '/home'       : (_) => const HomeScreen(),
        '/ocr'        : (_) => const OCRScreen(),
        '/add-bill'   : (_) => const AddBillScreen(),
        '/bills'      : (_) => const BillListScreen(),
        '/warranties' : (_) => const WarrantyListScreen(),
      },
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
