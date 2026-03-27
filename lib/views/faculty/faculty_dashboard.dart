import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../controllers/faculty_controller.dart';

class FacultyDashboard extends StatelessWidget {
  const FacultyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FacultyController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.pageHeader('My Dashboard', 'Good Morning, Faculty'),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.defaultShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Today\'s Classes', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('${controller.todayLectures} Lectures', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.schedule, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text('Next: ${controller.nextClass}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Quick Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppColors.primary))),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(child: UIHelper.statCard(title: 'Pending', value: '${controller.pendingTasks}', icon: Icons.assignment_late, color: AppColors.priorityMedium)),
                    const SizedBox(width: 16),
                    Expanded(child: UIHelper.statCard(title: 'Completed', value: '${controller.completedTasks}', icon: Icons.check_circle, color: AppColors.priorityLow)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Department Updates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ),
              
              UIHelper.priorityCard(
                title: 'Staff Meeting',
                subtitle: 'Today at 4:00 PM in Conference Room A.',
                priorityColor: AppColors.priorityUrgent,
              ),
              UIHelper.priorityCard(
                title: 'New Syllabus Guidelines',
                subtitle: 'Check email for the updated curriculum.',
                priorityColor: AppColors.priorityLow,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
