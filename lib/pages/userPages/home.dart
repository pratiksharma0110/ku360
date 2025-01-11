import 'package:flutter/material.dart';
import 'package:ku360/model/attendance.dart';
import 'package:ku360/model/routine.dart';
import 'package:ku360/services/user_service.dart';

class HomePage extends StatelessWidget {
  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          userService.fetchUserProfile(),
          userService.fetchRoutine(),
          userService.fetchAttendances(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data as List<dynamic>;
            final profile = data[0];
            final routine = data[1] as List<Routine>;
            final attendances = data[2] as List<Attendance>;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${profile.name}',
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
                          subtitle: "Track your attendance",
                          icon: Icons.bar_chart,
                          color: Colors.blue,
                          onTap: () {
                            _showAttendanceDetails(context, attendances);
                          },
                        ),
                        _buildDashboardCard(
                          context,
                          title: 'Today\'s Classes',
                          subtitle: '${routine.length} Classes',
                          icon: Icons.schedule,
                          color: Colors.orange,
                          onTap: () {
                            _showClassDetails(context, routine);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4, // Adjusted width
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
      ),
    );
  }

  void _showClassDetails(BuildContext context, List<Routine> routine) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Today\'s Classes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              routine.isEmpty
                  ? Center(
                      child: Text(
                        'No Classes Today!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: routine.length,
                        itemBuilder: (context, index) {
                          final item = routine[index];
                          return ListTile(
                            leading: Icon(
                              Icons.class_,
                              color: Colors.blueAccent,
                            ),
                            title: Text(item.subName),
                            subtitle: Text('${item.time}'),
                            trailing: Text(
                              item.instructor,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  void _showAttendanceDetails(BuildContext context, List<Attendance> attendances) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Attendance Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              attendances.isEmpty
                  ? Center(
                      child: Text(
                        'No attendance data available.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: attendances.length,
                        itemBuilder: (context, index) {
                          final attendance = attendances[index];
                          return ListTile(
                            leading: Icon(
                              Icons.school,
                              color: Colors.blueAccent,
                            ),
                            title: Text(attendance.sub_code),
                            subtitle: Text(
                              'Attended: ${attendance.attended_classes}/${attendance.total_classes}',
                            ),
                            trailing: Text(
                              '${attendance.attended_percentage}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: double.parse(attendance.attended_percentage) >= 75
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  
}