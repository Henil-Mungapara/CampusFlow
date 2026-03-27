import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FacultyTask extends StatelessWidget {
  const FacultyTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Faculty Task Management', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ),
    );
  }
}
