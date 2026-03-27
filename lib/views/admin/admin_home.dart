import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../controllers/admin_controller.dart';
import 'admin_dashboard.dart';
import 'admin_manage.dart';
import 'admin_profile.dart';
import 'setup/setup_screen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  final List<Widget> _pages = const [
    AdminDashboard(),
    AdminManage(),
    AdminProfile(),
  ];

  void _showAddDialog(BuildContext context) {
    UIHelper.showCustomDialog(
      context: context,
      title: 'Admin Actions',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogOption(context, Icons.schedule, 'Schedule', Colors.blue, () {}),
          _buildDialogOption(context, Icons.event, 'Event', AppColors.priorityMedium, () {}),
          _buildDialogOption(context, Icons.campaign, 'Notice', AppColors.priorityUrgent, () {}),
          _buildDialogOption(context, Icons.task, 'Task', AppColors.priorityLow, () {}),
          const Divider(),
          _buildDialogOption(context, Icons.settings, 'Setup', Colors.grey.shade700, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SetupScreen()));
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
    final controller = Provider.of<AdminController>(context);
    
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
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: 'Manage'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
