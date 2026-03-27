import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../controllers/student_controller.dart';
import 'student_dashboard.dart';
import 'student_schedule.dart';
import 'student_task.dart';
import 'student_profile.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  final List<Widget> _pages = const [
    StudentDashboard(),
    StudentSchedule(),
    StudentTask(),
    StudentProfile(),
  ];

  void _showViewDialog(BuildContext context) {
    UIHelper.showCustomDialog(
      context: context,
      title: 'Updates',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogOption(context, Icons.event, 'View Events', AppColors.primaryLight, () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Viewing Events...')));
          }),
          const Divider(),
          _buildDialogOption(context, Icons.campaign, 'View Notices', AppColors.priorityUrgent, () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Viewing Notices...')));
          }),
        ],
      ),
    );
  }

  Widget _buildDialogOption(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<StudentController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[controller.currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () => _showViewDialog(context),
        elevation: 2,
        child: const Icon(Icons.notifications_active, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.currentIndex,
        onTap: (index) => controller.setIndex(index),
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Task'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
