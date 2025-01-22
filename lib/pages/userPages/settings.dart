import 'package:flutter/material.dart';
import 'package:ku360/services/login_or_register.dart';
import 'package:ku360/services/shared_pref.dart';
import 'package:ku360/pages/authPages/login.dart';
import 'package:ku360/services/user_service.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final sharedPref = SharedPrefHelper();

  // Create TextEditingControllers for the password fields
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

void _changePassword(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Change Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _currentPasswordController,  // Added controller
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Current Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _newPasswordController,  // Added controller
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmNewPasswordController,  // Added controller
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm New Password',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            // Get the entered values
            final currentPassword = _currentPasswordController.text;
            final newPassword = _newPasswordController.text;
            final confirmNewPassword = _confirmNewPasswordController.text;

            // Check if the new password and confirmation match
            if (newPassword != confirmNewPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("New passwords don't match")),
              );
              return;
            }

            // Call the changePassword API
            final result = await UserService().changePassword(
              password: currentPassword,
              newPassword: newPassword,
            );

            // Close the dialog
            Navigator.pop(context);

            // Show the result of the API call in a SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['data'])),
            );
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              sharedPref.removeValue("jw_key");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginOrRegister(),
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () => _changePassword(context),
              icon: const Icon(Icons.lock),
              label: const Text('Change Password'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
