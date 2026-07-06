import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hello_app/ui/home_template_page.dart';
import 'package:hello_app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    // Initialization can fail on unsupported platforms or misconfiguration.
    // Log the error and continue; Firestore calls will surface errors to the UI.
    debugPrint('Firebase.initializeApp error: $e');
    debugPrint('$st');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Template App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeTemplatePage(),
    );
  }
}
