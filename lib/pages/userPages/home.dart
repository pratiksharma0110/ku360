import 'package:flutter/material.dart';
import 'package:ku360/services/profile_service.dart';

class HomePage extends StatelessWidget {
  final profileService = ProfileService();

//TODO: refactor and use api to render various things
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: profileService.fetchUserProfile(), // Fetch the user profile
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while fetching
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message if there's an error
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            // Build the UI with fetched data
            final profile = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard Section
                    Text(
                      'Welcome, ${profile.name}', // Use profile name
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDashboardCard(
                          context,
                          title: 'Attendance',
                          subtitle: '85%',
                          icon: Icons.bar_chart,
                          color: Colors.blue,
                        ),
                        _buildDashboardCard(
                          context,
                          title: 'Today\'s Classes',
                          subtitle: '3 Classes',
                          icon: Icons.schedule,
                          color: Colors.orange,
                        ),
                        _buildDashboardCard(
                          context,
                          title: 'Events',
                          subtitle: '2 Upcoming',
                          icon: Icons.event,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    // Quick Access Section
                    Text(
                      'Quick Access',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickAccessButton(
                          context,
                          title: 'Courses',
                          icon: Icons.book,
                          color: Colors.blue,
                        ),
                        _buildQuickAccessButton(
                          context,
                          title: 'Results',
                          icon: Icons.school,
                          color: Colors.orange,
                        ),
                        _buildQuickAccessButton(
                          context,
                          title: 'Library',
                          icon: Icons.library_books,
                          color: Colors.green,
                        ),
                        _buildQuickAccessButton(
                          context,
                          title: 'Helpdesk',
                          icon: Icons.help,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    // Notifications Section
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildNotificationCard(
                      title: 'Exam Registration Deadline',
                      subtitle: 'Complete by March 15th, 2025',
                    ),
                    _buildNotificationCard(
                      title: 'New Assignment Posted',
                      subtitle:
                          'Data Structures Assignment due March 10th, 2025',
                    ),
                    _buildNotificationCard(
                      title: 'Library Overdue Notice',
                      subtitle: 'Return borrowed books by March 5th, 2025',
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Show a default fallback UI
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(BuildContext context,
      {required String title, required IconData icon, required Color color}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 28),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(
      {required String title, required String subtitle}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(Icons.notifications, color: Colors.blue),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}
