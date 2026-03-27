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
          _buildDialogOption(context, Icons.settings, 'Setup', () {
            Navigator.pop(context);
            _showSetupDialog(context);
          }),
        ],
      ),
    );
  }

  void _showSetupDialog(BuildContext context) {
    final setupItems = [
      {'title': 'Department', 'icon': Icons.business_rounded},
      {'title': 'Course', 'icon': Icons.menu_book_rounded},
      {'title': 'Division', 'icon': Icons.groups_rounded},
      {'title': 'Subject', 'icon': Icons.science_rounded},
    ];

    UIHelper.showCustomDialog(
      context: context,
      title: 'Setup',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: setupItems.map((item) {
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 22),
            ),
            title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textLight, size: 20),
            onTap: () {
              Navigator.pop(context);
              _showSetupActionDialog(context, item['title'] as String);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showSetupActionDialog(BuildContext context, String title) {
    UIHelper.showCustomDialog(
      context: context,
      title: 'Manage $title',
      content: Text('What would you like to do with $title?', style: const TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _showSetupAddDialog(context, title);
          },
          child: const Text('Add', style: TextStyle(color: AppColors.primary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SetupScreen()));
          },
          child: const Text('View', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _showSetupAddDialog(BuildContext context, String title) {
    final TextEditingController nameCtrl = TextEditingController();
    UIHelper.showCustomDialog(
      context: context,
      title: 'Add $title',
      content: UIHelper.customTextField(
        controller: nameCtrl,
        hintText: 'Enter $title Name',
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title saved successfully!')));
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildDialogOption(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      onTap: onTap,
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit App?', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        content: const Text('Are you sure you want to leave Campus Companion?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
        if (shouldPop && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _pages[controller.currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          onPressed: () => _showAddDialog(context),
          elevation: 4,
          child: const Icon(Icons.add, color: AppColors.primary, size: 28),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex,
          onTap: (index) => controller.setIndex(index),
          backgroundColor: AppColors.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: 'Faculty'),
            BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Student'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
