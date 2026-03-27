import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          UIHelper.profileHeader(name: 'Dhruvi', role: 'Student - Semester 4', email: 'dhruvi@campusflow.edu'),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProfileOption(Icons.person_pin, 'Personal Information'),
                _buildProfileOption(Icons.library_books, 'Academic Records'),
                _buildProfileOption(Icons.account_balance_wallet, 'Fees & Payments'),
                _buildProfileOption(Icons.settings, 'Settings'),
                const SizedBox(height: 24),
                UIHelper.customButton(
                  text: 'Log Out',
                  onPressed: () {},
                  gradient: const LinearGradient(colors: [AppColors.priorityUrgent, Colors.redAccent]),
                ),
                const SizedBox(height: 100),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.defaultShadow,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textLight),
        onTap: () {},
      ),
    );
  }
}
