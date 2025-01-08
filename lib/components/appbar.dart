import 'package:flutter/material.dart';
import 'package:ku360/model/userprofile.dart';
import 'package:ku360/services/profile_service.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({
    required this.title,
    super.key
  }) ;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String? _profileImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final profileService = ProfileService();
    try {
      final UserProfile profile = await profileService.fetchUserProfile();
      setState(() {
        _profileImageUrl = profile.profileImageUrl;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching profile image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E2E38),
              Color(0xFF3A505D)
            ], // Charcoal gray to teal gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 4,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          _isLoading
              ? CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade400,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : _profileImageUrl != null
                  ? CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(_profileImageUrl!),
                    )
                  : CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.shade400,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
        ],
      ),
    );
  }
}

