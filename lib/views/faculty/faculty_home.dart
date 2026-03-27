import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../controllers/faculty_controller.dart';
import 'faculty_dashboard.dart';
import 'faculty_schedule.dart';
import 'faculty_task.dart';
import 'faculty_profile.dart';

class FacultyHome extends StatelessWidget {
  const FacultyHome({super.key});

  final List<Widget> _pages = const [
    FacultyDashboard(),
    FacultySchedule(),
    FacultyTask(),
    FacultyProfile(),
  ];

  void _showAddDialog(BuildContext context) {
    UIHelper.showCustomDialog(
      context: context,
      title: 'Create',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogOption(context, Icons.event, 'Add Event', AppColors.priorityMedium, () {
            Navigator.pop(context);
            _showAddForm(context, 'Event');
          }),
          const Divider(),
          _buildDialogOption(context, Icons.campaign, 'Add Notice', AppColors.priorityUrgent, () {
            Navigator.pop(context);
            _showAddForm(context, 'Notice');
          }),
        ],
      ),
    );
  }

  void _showAddForm(BuildContext context, String title) {
    final TextEditingController titleCtrl = TextEditingController();
    final TextEditingController descCtrl = TextEditingController();
    
    UIHelper.showCustomDialog(
      context: context,
      title: 'New $title',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UIHelper.customTextField(controller: titleCtrl, hintText: '$title Title'),
          UIHelper.customTextField(controller: descCtrl, hintText: 'Description'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title created successfully!')));
          },
          child: const Text('Post', style: TextStyle(color: Colors.white)),
        ),
      ],
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
    final controller = Provider.of<FacultyController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[controller.currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddDialog(context),
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
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
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Task'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
