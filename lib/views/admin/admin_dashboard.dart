import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../controllers/admin_controller.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AdminController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.pageHeader('Overview', 'Welcome back, Admin'),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(child: UIHelper.statCard(title: 'Students', value: '${controller.totalStudents}', icon: Icons.group, color: AppColors.primary)),
                    const SizedBox(width: 16),
                    Expanded(child: UIHelper.statCard(title: 'Faculty', value: '${controller.totalFaculty}', icon: Icons.person_outline, color: AppColors.secondary)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(child: UIHelper.statCard(title: 'Notices', value: '${controller.activeNotices}', icon: Icons.campaign, color: AppColors.accent)),
                    const SizedBox(width: 16),
                    Expanded(child: UIHelper.statCard(title: 'Events', value: '${controller.upcomingEvents}', icon: Icons.event, color: AppColors.priorityMedium)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppColors.primary))),
                  ],
                ),
              ),
              
              UIHelper.priorityCard(
                title: 'New Student Registered',
                subtitle: 'Aarav Patel (Computer Science)',
                priorityColor: AppColors.priorityLow,
              ),
              UIHelper.priorityCard(
                title: 'Urgent Notice Posted',
                subtitle: 'By Principal regarding holidays',
                priorityColor: AppColors.priorityUrgent,
              ),
              UIHelper.priorityCard(
                title: 'Faculty Leave Request',
                subtitle: 'Shivam asked for 2 days leave',
                priorityColor: AppColors.priorityMedium,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
