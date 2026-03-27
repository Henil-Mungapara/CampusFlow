import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../../controllers/admin_controller.dart';
import '../../models/course_model.dart';
import '../../models/subject_model.dart';

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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _FacultyRegistrationDialog(),
    );
  }
}

class _FacultyRegistrationDialog extends StatefulWidget {
  const _FacultyRegistrationDialog();

  @override
  State<_FacultyRegistrationDialog> createState() => _FacultyRegistrationDialogState();
}

class _FacultyRegistrationDialogState extends State<_FacultyRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  
  String _selectedGender = 'Male';
  List<CourseModel> _allCourses = [];
  List<SubjectModel> _allSubjects = [];
  final List<String> _selectedCourseIds = [];
  final List<String> _selectedSubjectIds = [];
  bool _isLoadingData = true;
  bool _isSaving = false;

  final String _generatedId = 'FAC-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  final String _createdAtText = '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final controller = Provider.of<AdminController>(context, listen: false);
    final courses = await controller.fetchCourses();
    
    // For subject, we would normally fetch all subjects or by department, but AdminController currently doesn't have fetchSubjects.
    // Let's use getSetupItemsStream manually or fetch through a new method. Wait, AdminController has subjectsRef.
    // I'll add fetchSubjects to AdminController if needed, or just fetch directly here for UI.
    // Actually, AdminController has fetchDivisions, fetchCourses, fetchDepartments. Let's just fetch directly from Firestore or add it.
    // Let's assume we can fetch them via a direct firestore call or we just add fetchSubjects to AdminController later.
    // For now, let's fetch directly to avoid editing AdminController again.
    final subjectsSnapshot = await FirebaseFirestore.instance.collection('subjects').orderBy('name').get();
    final subjects = subjectsSnapshot.docs.map((doc) => SubjectModel.fromMap(doc.id, doc.data())).toList();

    if (!mounted) return;
    setState(() {
      _allCourses = courses;
      _allSubjects = subjects;
      _isLoadingData = false;
    });
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match'), backgroundColor: AppColors.priorityUrgent));
      return;
    }
    if (_selectedCourseIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one course'), backgroundColor: AppColors.priorityUrgent));
      return;
    }

    setState(() => _isSaving = true);
    final controller = Provider.of<AdminController>(context, listen: false);
    final error = await controller.registerFaculty(
      name: _nameCtrl.text,
      gender: _selectedGender,
      phone: _phoneCtrl.text,
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
      courses: _selectedCourseIds,
      subjects: _selectedSubjectIds,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: AppColors.priorityUrgent));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faculty Registered Successfully!'), backgroundColor: AppColors.priorityLow));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(28)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
              child: const Row(
                children: [
                  Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 16),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Faculty Registration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('Add a new faculty member', style: TextStyle(fontSize: 13, color: Colors.white70)),
                    ]
                  ))
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildInfoChip('ID: $_generatedId', Icons.badge)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoChip('Role: Faculty', Icons.admin_panel_settings)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoChip('Date: $_createdAtText', Icons.calendar_today),
                      const SizedBox(height: 24),
                      _buildTextField(_nameCtrl, 'Full Name', Icons.person, (v) => v!.isEmpty ? 'Required' : null),
                      const SizedBox(height: 16),
                      Text('Gender', style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['Male', 'Female', 'Other'].map((gender) => InkWell(
                          onTap: () => setState(() => _selectedGender = gender),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedGender == gender ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _selectedGender == gender ? AppColors.primary : Colors.grey.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _selectedGender == gender ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                  color: _selectedGender == gender ? AppColors.primary : Colors.grey.shade500,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(gender, style: TextStyle(fontSize: 14, color: _selectedGender == gender ? AppColors.primary : AppColors.textSecondary, fontWeight: _selectedGender == gender ? FontWeight.bold : FontWeight.normal)),
                              ],
                            ),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(_phoneCtrl, 'Phone Number', Icons.phone, (v) => v!.isEmpty ? 'Required' : null, TextInputType.phone),
                      const SizedBox(height: 16),
                      _buildTextField(_emailCtrl, 'Email Address', Icons.email, (v) => !v!.contains('@') ? 'Enter a valid email' : null, TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildTextField(_passwordCtrl, 'Password', Icons.lock, (v) => v!.length < 6 ? 'Min 6 chars' : null, TextInputType.visiblePassword, true),
                      const SizedBox(height: 16),
                      _buildTextField(_confirmPasswordCtrl, 'Confirm Password', Icons.lock_outline, (v) => v!.isEmpty ? 'Required' : null, TextInputType.visiblePassword, true),
                      const SizedBox(height: 24),
                      Text('Assign Courses (Multiple)', style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: _allCourses.map((c) => FilterChip(
                          label: Text(c.code),
                          selected: _selectedCourseIds.contains(c.id),
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.primary,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) { _selectedCourseIds.add(c.id); }
                              else { _selectedCourseIds.remove(c.id); }
                            });
                          },
                        )).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text('Assign Subjects (Multiple)', style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: _allSubjects.map((s) => FilterChip(
                          label: Text(s.name),
                          selected: _selectedSubjectIds.contains(s.id),
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.primary,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) { _selectedSubjectIds.add(s.id); }
                              else { _selectedSubjectIds.remove(s.id); }
                            });
                          },
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)))),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                      child: _isSaving
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Register Faculty', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String? Function(String?) validator, [TextInputType type = TextInputType.text, bool obscure = false]) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent)),
      ),
    );
  }
}
