import 'package:flutter/material.dart';

class ScreenD1 extends StatelessWidget {
  const ScreenD1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen D1')),
      body: const Center(child: Text('Screen D1')),
    );
  }
}
