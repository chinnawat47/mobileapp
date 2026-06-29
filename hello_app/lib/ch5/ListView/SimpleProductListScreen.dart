import 'dart:convert'; // use for convert JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle; // use for read json file

class SimpleProductListScreen extends StatefulWidget {
  const SimpleProductListScreen({super.key});

  @override
  State<SimpleProductListScreen> createState() =>
      _SimpleProductListScreenState();
}

class _SimpleProductListScreenState extends State<SimpleProductListScreen> {
  List<dynamic> mockProducts = [];

  @override
  void initState() {
    super.initState();
    loadAssetData(); // init here
  }

  Future<void> loadAssetData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/employees.json',
    );
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    final List<dynamic> rawList = jsonData['content'];

    setState(() {
      mockProducts = rawList.map((e) {
        var emp = e['data'];
        return {
          "title": "${emp['first_name']} ${emp['last_name']}",
          "email": "${emp['email']}",
          "image": "https://picsum.photos/id/1/200/300",
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Basic ListView (From Asset)',
        ), // เปลี่ยนแค่ชื่อ Title
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      // 7. ส่วนนี้คือโค้ด ListView.builder ชุดเดิมของคุณ 100% ไม่มีการแก้ไส้ในเลย
      body: mockProducts.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            ) // เพิ่มตัวหมุนรอช่วงโหลดไฟล์
          : ListView.builder(
              itemCount: mockProducts.length,
              itemBuilder: (context, index) {
                final item = mockProducts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      item['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
