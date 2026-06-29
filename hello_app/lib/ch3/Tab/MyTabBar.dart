//import 'package:app01_test1/ui/ScreenC.dart';
import 'package:flutter/material.dart';

import 'ScreenA.dart';
import 'ScreenB.dart';
import 'ScreenC.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // จำนวน tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Example'),
          //กำหนด theme fg,bg ของ tabbar
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple, //set bg here
          // show tabbar here
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
        ),

        body: const TabBarView(children: [ScreenA(), ScreenB(), ScreenC()]),

        // define tabbar at the bottom with bottomNavigationBar
        // bottomNavigationBar: Container(
        //   color: Colors.deepPurple,
        //   child: const TabBar(
        //     tabs: [
        //       Tab(icon: Icon(Icons.home), text: 'Home'),
        //       Tab(icon: Icon(Icons.person), text: 'Profile'),
        //       Tab(icon: Icon(Icons.settings), text: 'Settings'),
        //     ],
        //     labelColor: Colors.white,
        //     unselectedLabelColor: Colors.white70,
        //     indicatorColor: Colors.pinkAccent,
        //   ),
        // ),
      ),
    );
  }
}
