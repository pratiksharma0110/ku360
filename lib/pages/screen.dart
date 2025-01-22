import 'package:flutter/material.dart';
import 'package:ku360/components/appbar.dart'; 
import 'package:ku360/components/navbar.dart'; 
import 'package:ku360/pages/userPages/course_page.dart';
import 'package:ku360/pages/userPages/home.dart';
import 'package:ku360/pages/userPages/notice.dart';
import 'package:ku360/pages/userPages/profile_screen.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int selectedIndex = 0;

  final List<String> appBarTitles = [
    'Home',
    'Course',
    'Notices',
    'Profile',
  ];

  final List<Widget> pages = [
    HomePage(),
    CoursesPage(),
    NoticePage(),
    ProfileScreen(),
  ];

  void _onTabChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages.map((page) {
          return Scaffold(
            appBar: MyAppBar(title: appBarTitles[selectedIndex]),
            body: page,
          );
        }).toList(),
      ),
      bottomNavigationBar: MyNavBar(
        selectedIndex: selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}
