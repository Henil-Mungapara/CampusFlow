import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../controllers/student_controller.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<StudentController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.pageHeader('Campus Companion', 'Hello, Student 👋'),
              
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Attendance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 8),
                          Text('${controller.attendancePercentage}%', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            child: Text(controller.attendanceStatus, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: CircularProgressIndicator(
                              value: controller.attendancePercentage / 100,
                              strokeWidth: 8,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                          const Icon(Icons.verified, color: Colors.white, size: 32),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Important Updates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ),
              
              UIHelper.priorityCard(
                title: 'Mid-term Exams Schedule',
                subtitle: 'Starts next monday. Check the portal for details.',
                priorityColor: AppColors.priorityUrgent,
              ),
              UIHelper.priorityCard(
                title: 'Cultural Fest 2026',
                subtitle: 'Registrations are open for dance and music.',
                priorityColor: AppColors.priorityMedium,
              ),
              UIHelper.priorityCard(
                title: 'System Design Assignment',
                subtitle: 'Due in 3 days. Submit on time.',
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
