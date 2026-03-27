import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';

class AdminManageStudent extends StatefulWidget {
  const AdminManageStudent({super.key});

  @override
  State<AdminManageStudent> createState() => _AdminManageStudentState();
}

class _AdminManageStudentState extends State<AdminManageStudent> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _allStudents = [
    {'name': 'Dhruvi', 'role': 'Semester 4'},
    {'name': 'Rahul', 'role': 'Semester 6'},
  ];
  List<Map<String, String>> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _filteredStudents = _allStudents;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _allStudents.where((student) {
        return student['name']!.toLowerCase().contains(query) ||
               student['role']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showAddStudentDialog(context),
      ),
      appBar: AppBar(
        title: const Text('Manage Students', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          UIHelper.customTextField(
            controller: _searchController, 
            hintText: 'Search students...', 
            icon: Icons.search,
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('Student Directory'),
          const SizedBox(height: 8),
          if (_filteredStudents.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No students found.', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
          ..._filteredStudents.map((student) => 
              _buildUserCard(student['name']!, student['role']!, Icons.school)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildUserCard(String name, String role, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.defaultShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
        subtitle: Text(role, style: const TextStyle(color: AppColors.textSecondary)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_outlined, color: AppColors.primary), onPressed: () {}),
            IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.priorityUrgent), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    UIHelper.showCustomDialog(
      context: context,
      title: 'Student Registration',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Full Name', icon: Icons.person),
            const SizedBox(height: 12),
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Enrollment Number', icon: Icons.badge),
            const SizedBox(height: 12),
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Email Address', icon: Icons.email),
            const SizedBox(height: 12),
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Phone Number', icon: Icons.phone),
            const SizedBox(height: 12),
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Course / Branch', icon: Icons.book),
            const SizedBox(height: 12),
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Current Semester', icon: Icons.timeline),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student Registered Successfully!')));
          },
          child: const Text('Register', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
