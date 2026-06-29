import 'package:flutter/material.dart';
import 'DetailScreen.dart';
import 'data/UserParam.dart';

class HomeScreenInput extends StatelessWidget {
  const HomeScreenInput({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. สร้าง Controller เพื่อดึงค่าจากช่องพิมพ์ (พยายามเขียนให้สั้นที่สุด)
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Input your name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Input your age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final dataToSend = UserParam(
                  name: nameController.text,
                  age: int.tryParse(ageController.text) ?? 0,
                  role: 'User',
                );

                // 3. send data to next pg
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(user: dataToSend),
                  ),
                );
              },
              child: const Text('Sending data as Class'),
            ),
          ],
        ),
      ),
    );
  }
}
