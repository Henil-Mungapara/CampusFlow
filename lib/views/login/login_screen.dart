import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_size.dart';
import '../../utils/ui_helper.dart';
import '../../models/user_model.dart';
import '../admin/admin_home.dart';
import '../faculty/faculty_home.dart';
import '../student/student_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text.trim();
    
    if (username.toLowerCase() == 'henil') {
      _navigateToRole(UserRole.admin);
    } else if (username.toLowerCase() == 'shivam') {
      _navigateToRole(UserRole.faculty);
    } else if (username.toLowerCase() == 'dhruvi') {
      _navigateToRole(UserRole.student);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid user. Use Henil, Shivam, or Dhruvi')),
      );
    }
  }

  void _navigateToRole(UserRole role) {
    if (role == UserRole.admin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminHome()));
    } else if (role == UserRole.faculty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FacultyHome()));
    } else if (role == UserRole.student) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentHome()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSize.wp * 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSize.hp * 10),
              Center(
                child: Icon(Icons.school_rounded, size: AppSize.wp * 25, color: AppColors.primary),
              ),
              SizedBox(height: AppSize.hp * 4),
              const Text(
                'Welcome to\nCampus Companion',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              SizedBox(height: AppSize.hp * 1),
              const Text(
                'Sign in to your account',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSize.hp * 5),
              UIHelper.customTextField(
                controller: _usernameController,
                hintText: 'Username (Henil, Shivam, Dhruvi)',
                icon: Icons.person_outline,
              ),
              SizedBox(height: AppSize.hp * 2),
              UIHelper.customTextField(
                controller: _passwordController,
                hintText: 'Password (Any)',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              SizedBox(height: AppSize.hp * 6),
              UIHelper.customButton(
                text: 'Login',
                onPressed: _login,
              ),
              SizedBox(height: AppSize.hp * 4),
            ],
          ),
        ),
      ),
    );
  }
}
