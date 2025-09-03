import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:billwise/main.dart'; 

void main() {
  testWidgets('BillWise app basic navigation', (WidgetTester tester) async {
    // يبني التطبيق
    await tester.pumpWidget(const BillWiseApp());
    expect(find.byType(MaterialApp), findsOneWidget);

    // شاشة تسجيل الدخول أولاً
    expect(find.text('BillWise - Login'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);

    // نروح شاشة إنشاء حساب
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Create Account'), findsOneWidget);

    // من شاشة إنشاء حساب نروح للهوم (السلوك المؤقت)
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // نتأكد وصلنا للهوم
    expect(find.text('BillWise'), findsOneWidget);
    expect(find.text('Scan Bill (OCR)'), findsOneWidget);
  });
}
