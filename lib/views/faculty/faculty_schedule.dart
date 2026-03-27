import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FacultySchedule extends StatelessWidget {
  const FacultySchedule({super.key});

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
        child: Text('Faculty Schedule View', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ),
    );
  }
}
