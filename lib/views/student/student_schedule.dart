import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class StudentSchedule extends StatelessWidget {
  const StudentSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Student Class Schedule', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ),
    );
  }
}
