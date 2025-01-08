import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

class MyNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const MyNavBar({
    required this.selectedIndex,
    required this.onTabChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GNav(
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.black,
        tabBackgroundColor: Colors.white,
        gap: 8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
        tabs: [
          GButton(
            icon: Iconsax.home,
            text: "Home",
          ),
          GButton(
            icon: Iconsax.book,
            text: "Courses",
          ),
          GButton(
            icon: Iconsax.note,
            text: "Notice",
          ),
          GButton(
            icon: Iconsax.profile,
            text: "Profile",
          ),
        ],
      ),
    );
  }
}
