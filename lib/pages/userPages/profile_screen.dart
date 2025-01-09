import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ku360/components/card.dart';
import 'package:ku360/model/userprofile.dart';

import 'package:ku360/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> _profileFuture;
  final userService = UserService();

  @override
  void initState() {
    super.initState();
    _profileFuture = userService.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No profile data found.'),
            );
          }

          final userProfile = snapshot.data!;
          final year = userProfile.year;
          final semester = userProfile.semester;

          final batch = " $year / $semester";

          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userProfile.profileImageUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userProfile.name,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userProfile.email,
                  ),
                  const SizedBox(height: 16),
                  MyCard(
                    icon: Iconsax.teacher,
                    iconColor: theme.primaryColor,
                    text: userProfile.school,
                  ),
                  const SizedBox(height: 16),
                  MyCard(
                    icon: Iconsax.book,
                    iconColor: theme.primaryColor,
                    text: userProfile.department,
                  ),
                  const SizedBox(height: 16),
                  MyCard(
                      icon: Iconsax.teacher,
                      iconColor: theme.primaryColor,
                      text: batch),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
