import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AdminManage extends StatelessWidget {
  const AdminManage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Manage Faculty & Students', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ),
    );
  }
}
