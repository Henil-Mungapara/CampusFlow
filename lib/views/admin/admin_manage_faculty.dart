import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';

class AdminManageFaculty extends StatefulWidget {
  const AdminManageFaculty({super.key});

  @override
  State<AdminManageFaculty> createState() => _AdminManageFacultyState();
}

class _AdminManageFacultyState extends State<AdminManageFaculty> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _allFaculty = [
    {'name': 'Shivam', 'role': 'Senior Professor (CS)'},
    {'name': 'Dr. Verma', 'role': 'HOD Mathematics'},
  ];
  List<Map<String, String>> _filteredFaculty = [];

  @override
  void initState() {
    super.initState();
    _filteredFaculty = _allFaculty;
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
      _filteredFaculty = _allFaculty.where((faculty) {
        return faculty['name']!.toLowerCase().contains(query) ||
               faculty['role']!.toLowerCase().contains(query);
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
        onPressed: () => _showAddFacultyDialog(context),
      ),
      appBar: AppBar(
        title: const Text('Manage Faculty', style: TextStyle(fontWeight: FontWeight.bold)),
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
            hintText: 'Search faculty...', 
            icon: Icons.search,
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('Faculty Directory'),
          const SizedBox(height: 8),
          if (_filteredFaculty.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No faculty found.', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
          ..._filteredFaculty.map((faculty) => 
              _buildUserCard(faculty['name']!, faculty['role']!, Icons.person)),
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

  void _showAddFacultyDialog(BuildContext context) {
    UIHelper.showCustomDialog(
      context: context,
      title: 'Faculty Registration',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Full Name', icon: Icons.person),
            const SizedBox(height: 12),
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Email Address', icon: Icons.email),
            const SizedBox(height: 12),
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Phone Number', icon: Icons.phone),
            const SizedBox(height: 12),
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Department', icon: Icons.business),
            const SizedBox(height: 12),
            UIHelper.customTextField(controller: TextEditingController(), hintText: 'Designation / Role', icon: Icons.work),
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faculty Registered Successfully!')));
          },
          child: const Text('Register', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
