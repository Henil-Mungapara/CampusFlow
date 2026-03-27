import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class StudentTask extends StatelessWidget {
  const StudentTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Student Tasks & Assignments', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ),
    );
  }
}
