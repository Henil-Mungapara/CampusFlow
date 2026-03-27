import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../controllers/admin_controller.dart';
import 'admin_dashboard.dart';
import 'admin_manage_faculty.dart';
import 'admin_manage_student.dart';
import 'admin_profile.dart';
import 'setup/setup_screen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  final List<Widget> _pages = const [
    AdminDashboard(),
    AdminManageFaculty(),
    AdminManageStudent(),
    AdminProfile(),
  ];

  // 🔥 MAIN ACTION DIALOG
  void _showAddDialog(BuildContext context) {
    UIHelper.showCustomDialog(
      context: context,
      title: 'Admin Actions',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogOption(context, Icons.schedule, 'Schedule', () {}),
          _buildDialogOption(context, Icons.event, 'Event', () {}),
          _buildDialogOption(context, Icons.campaign, 'Notice', () {}),
          _buildDialogOption(context, Icons.task, 'Task', () {}),

          const Divider(height: 1),

          // ✅ FIXED: Direct Navigation
          _buildDialogOption(context, Icons.settings, 'Setup', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SetupScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDialogOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }

  // 🔙 EXIT CONFIRMATION
  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Exit App?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'Are you sure you want to leave Campus Companion?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return exitResult ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AdminController>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _pages[controller.currentIndex],

        // ➕ FAB
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          elevation: 4,
          onPressed: () => _showAddDialog(context),
          child: const Icon(Icons.add, color: AppColors.primary, size: 28),
        ),

        // 🔽 Bottom Navigation
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex,
          onTap: (index) => controller.setIndex(index),
          backgroundColor: AppColors.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded),
              label: 'Faculty',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_rounded),
              label: 'Student',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
