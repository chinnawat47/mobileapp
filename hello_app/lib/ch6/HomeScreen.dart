import 'package:flutter/material.dart';
import 'DetailScreen.dart';
import 'package:hello_app/ch4/Navigation/data/UserParam.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. create controller to get input
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // enter input
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Enter name:'),
            ),

            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Enter age:'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // 2. get object as class
                final dataToSend = UserParam(
                  name: nameController.text,
                  age:
                      int.tryParse(ageController.text) ?? 0, 
                  role: 'Developer',
                );

                // 3. sending dat as obj
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(user: dataToSend),
                  ),
                );
              },
              child: const Text('Sending obj as Class'),
            ),
          ],
        ),
      ),
    );
  }
}
