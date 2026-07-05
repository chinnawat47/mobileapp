import 'package:flutter/material.dart';
import 'data/UserParam.dart';

class DetailScreen extends StatelessWidget {
  // 1. ประกาศตัวแปรเพื่อรับ Object (ใช้ final)
  final UserParam user;

  // 2. get parm Constructor
  const DetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3. get data from Object 
            Text('Name: xx', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
