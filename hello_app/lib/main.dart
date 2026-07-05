import 'package:flutter/material.dart';
import 'pages/home_template_page.dart';
import 'theme/app_theme.dart';

void main() {
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
