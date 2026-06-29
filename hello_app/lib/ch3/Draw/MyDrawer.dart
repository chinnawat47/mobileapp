import 'package:flutter/material.dart';
import 'ScreenD1.dart';
import 'ScreenD2.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            // decoration: BoxDecoration(color: Colors.deepPurple),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/forest.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            // child: Text(
            //   'เมนูหลัก',
            //   style: TextStyle(color: Colors.white, fontSize: 24),
            // ),
            // กรณีแสดง Avartar ตอ้งแสดงผ่าน column
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/images/profile2.png'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mr.Flutter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'เมนูหลัก',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),

          //****** เปลี่ยนให้ expand ได้ */
          ExpansionTile(
            //leading: const Icon(Icons.menu_open),
            title: const Text('Pages (Click to expand)'),
            initiallyExpanded: true, // ตั้งเป็น true ถ้าอยากให้กางออกตั้งแต่แรก
            children: [
              //เมนูย่อยที่จะซ่อน/แสดง อยู่ในนี้
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  // Navigator.pop(context); // ปิด Drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScreenD1()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScreenD2()),
                  );
                },
              ),
              Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                // onTap: () {
                //   Navigator.pop(context); //ปิด dRAWER ก่อน
                // },
              ),
            ], //วงเล็บ child ที่เพิ่มจาก expandchild of listTileexapnd
          ), //expand ที่เพิ่ม
        ],
      ),
    );
  }
}
