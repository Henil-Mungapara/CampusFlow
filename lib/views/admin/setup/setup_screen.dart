import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/course_model.dart';
import '../../../models/department_model.dart';
import '../../../models/division_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/ui_helper.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  static final List<Map<String, dynamic>> _setupItems = [
    {'title': 'Department', 'icon': Icons.business_rounded, 'countKey': 'Departments', 'desc': 'Manage academic departments'},
    {'title': 'Course', 'icon': Icons.menu_book_rounded, 'countKey': 'Courses', 'desc': 'Configure available courses'},
    {'title': 'Division', 'icon': Icons.groups_rounded, 'countKey': 'Divisions', 'desc': 'Organize class divisions'},
    {'title': 'Subject', 'icon': Icons.science_rounded, 'countKey': 'Subjects', 'desc': 'Setup subjects & syllabus'},
  ];

  void _onCardTap(BuildContext context, String title) {
    _showViewScreen(context, title);
  }

  void _showViewScreen(BuildContext context, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SetupViewScreen(title: title)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // --- Premium Gradient Header ---
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Setup', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20)),
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -20,
                      child: Icon(Icons.settings_rounded, size: 180, color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -10,
                      child: Icon(Icons.tune_rounded, size: 120, color: Colors.white.withValues(alpha: 0.04)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 70, 24, 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Configure your institution',
                            style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Summary Stats Row ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: _setupItems.map((item) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: AppColors.defaultShadow,
                      ),
                      child: Column(
                        children: [
                          StreamBuilder<int>(
                            stream: context.read<AdminController>().getSetupCountStream(item['countKey']),
                            builder: (context, snap) {
                              return Text(
                                '${snap.data ?? 0}',
                                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                              );
                            }
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['title'],
                            style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ).animate(delay: (100 * _setupItems.indexOf(item)).ms).fadeIn().slideY(begin: 0.2),
                  );
                }).toList(),
              ),
            ),
          ),

          // --- Section Header ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Quick Actions',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
          ),

          // --- Setup Cards ---
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = _setupItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _onCardTap(context, item['title']),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppColors.defaultShadow,
                        ),
                        child: Row(
                          children: [
                            // Icon container
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(item['icon'] as IconData, color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 16),
                            // Title & Description
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['desc'],
                                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            // Count badge
                            StreamBuilder<int>(
                              stream: context.read<AdminController>().getSetupCountStream(item['countKey']),
                              builder: (context, snap) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${snap.data ?? 0}',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                                  ),
                                );
                              }
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
                          ],
                        ),
                      ),
                    ),
                  ).animate(delay: (120 * index).ms).fadeIn().slideX(begin: 0.1),
                );
              },
              childCount: _setupItems.length,
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class SetupViewScreen extends StatefulWidget {
  final String title;
  const SetupViewScreen({super.key, required this.title});

  @override
  State<SetupViewScreen> createState() => _SetupViewScreenState();
}

class _SetupViewScreenState extends State<SetupViewScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('View ${widget.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: UIHelper.customTextField(
              controller: _searchController,
              hintText: 'Search ${widget.title}...',
              icon: Icons.search,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: context.read<AdminController>().getSetupItemsStream(widget.title),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data', style: TextStyle(color: AppColors.priorityUrgent)));
                }

                final allItems = snapshot.data ?? [];
                
                final filteredItems = _searchQuery.isEmpty 
                    ? allItems 
                    : allItems.where((item) => 
                        item['name'].toString().toLowerCase().contains(_searchQuery) ||
                        item['code'].toString().toLowerCase().contains(_searchQuery)).toList();

                if (filteredItems.isEmpty) {
                  return const Center(child: Text('No items found.', style: TextStyle(color: AppColors.textSecondary)));
                }

                return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final firstLetter = item['code'].toString().isNotEmpty ? item['code'].toString().substring(0, 1).toUpperCase() : '?';
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                        color: AppColors.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          subtitle: Text(item['foreignId'] == '' ? 'Code: ${item['code']}' : 'Code: ${item['code']}  •  ${item['foreignId']}', style: const TextStyle(color: AppColors.textSecondary)),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text(firstLetter, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
                                onPressed: () => _showAddDialog(context, widget.title, item: item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.priorityUrgent),
                                onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: Text('Are you sure you want to delete ${item['name']}?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: AppColors.priorityUrgent))),
                                        ],
                                      )
                                    );
                                    
                                    if (confirm == true && context.mounted) {
                                      await context.read<AdminController>().deleteSetupItem(widget.title, item['id']);
                                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted ${item['name']}')));
                                    }
                                },
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn().slideX(begin: 0.05);
                    },
                  );
              }
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, widget.title),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add ${widget.title}', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 4,
      ),
    );
  }

  void _showAddDialog(BuildContext context, String title, {Map<String, dynamic>? item}) {
    if (title == 'Department') {
      _showAddDepartmentDialog(context, item: item);
      return;
    }
    if (title == 'Course') {
      _showAddCourseDialog(context, item: item);
      return;
    }
    if (title == 'Division') {
      _showAddDivisionDialog(context, item: item);
      return;
    }
    if (title == 'Subject') {
      _showAddSubjectDialog(context, item: item);
      return;
    }
  }

  void _showAddDepartmentDialog(BuildContext context, {Map<String, dynamic>? item}) {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController(text: item?['code'] ?? '');
    final nameCtrl = TextEditingController(text: item?['name'] ?? '');
    final now = DateTime.now();
    final createdAtText = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}  •  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: item != null ? 'Edit Department' : 'Add Department',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: a1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: a1, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: _AddDepartmentDialogContent(
              formKey: formKey,
              codeCtrl: codeCtrl,
              nameCtrl: nameCtrl,
              createdAtText: createdAtText,
              editItem: item,
            ),
          ),
        );
      },
    );
  }

  void _showAddCourseDialog(BuildContext context, {Map<String, dynamic>? item}) {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController(text: item?['code'] ?? '');
    final nameCtrl = TextEditingController(text: item?['name'] ?? '');
    final now = DateTime.now();
    final createdAtText = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}  •  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: item != null ? 'Edit Course' : 'Add Course',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: a1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: a1, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: _AddCourseDialogContent(
              formKey: formKey,
              codeCtrl: codeCtrl,
              nameCtrl: nameCtrl,
              createdAtText: createdAtText,
              editItem: item,
            ),
          ),
        );
      },
    );
  }

  void _showAddDivisionDialog(BuildContext context, {Map<String, dynamic>? item}) {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController(text: item?['code'] ?? '');
    final nameCtrl = TextEditingController(text: item?['name'] ?? '');
    final now = DateTime.now();
    final createdAtText = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}  •  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: item != null ? 'Edit Division' : 'Add Division',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: a1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: a1, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: _AddDivisionDialogContent(
              formKey: formKey,
              codeCtrl: codeCtrl,
              nameCtrl: nameCtrl,
              createdAtText: createdAtText,
              editItem: item,
            ),
          ),
        );
      },
    );
  }

  void _showAddSubjectDialog(BuildContext context, {Map<String, dynamic>? item}) {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController(text: item?['code'] ?? '');
    final nameCtrl = TextEditingController(text: item?['name'] ?? '');
    final now = DateTime.now();
    final createdAtText = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}  •  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: item != null ? 'Edit Subject' : 'Add Subject',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: a1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: a1, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: _AddSubjectDialogContent(
              formKey: formKey,
              codeCtrl: codeCtrl,
              nameCtrl: nameCtrl,
              createdAtText: createdAtText,
              editItem: item,
            ),
          ),
        );
      },
    );
  }
}

// ─── Premium Add Department Dialog ────────────────────────────────────────────
class _AddDepartmentDialogContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController codeCtrl;
  final TextEditingController nameCtrl;
  final String createdAtText;
  final Map<String, dynamic>? editItem;

  const _AddDepartmentDialogContent({
    required this.formKey,
    required this.codeCtrl,
    required this.nameCtrl,
    required this.createdAtText,
    this.editItem,
  });

  @override
  State<_AddDepartmentDialogContent> createState() => _AddDepartmentDialogContentState();
}

class _AddDepartmentDialogContentState extends State<_AddDepartmentDialogContent> {
  bool _isSaving = false;
  bool get _isEditing => widget.editItem != null;

  Future<void> _handleSave() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final controller = Provider.of<AdminController>(context, listen: false);
    String? error;
    if (_isEditing) {
      error = await controller.updateDepartment(
        code: widget.codeCtrl.text,
        name: widget.nameCtrl.text,
      );
    } else {
      error = await controller.addDepartment(
        code: widget.codeCtrl.text,
        name: widget.nameCtrl.text,
      );
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(error)),
            ],
          ),
          backgroundColor: AppColors.priorityUrgent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              const Expanded(child: Text('Department saved successfully!')),
            ],
          ),
          backgroundColor: AppColors.priorityLow,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.88;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Gradient Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.business_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 14),
                Text(
                  _isEditing ? 'Edit Department' : 'Add Department',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isEditing ? 'Update department details' : 'Create a new academic department',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // ── Form Body ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Form(
              key: widget.formKey,
              child: Column(
                children: [
                  // Department Code
                  _buildFormField(
                    controller: widget.codeCtrl,
                    label: 'Department Code',
                    hint: 'e.g. CS, ME, EC',
                    icon: Icons.tag_rounded,
                    readOnly: _isEditing,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Department code is required';
                      }
                      if (value.trim().length < 2) {
                        return 'Code must be at least 2 characters';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.characters,
                  ),

                  const SizedBox(height: 16),

                  // Department Name
                  _buildFormField(
                    controller: widget.nameCtrl,
                    label: 'Department Name',
                    hint: 'e.g. Computer Science',
                    icon: Icons.school_rounded,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Department name is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),

                  const SizedBox(height: 16),

                  // Created At (Read-only)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Created At',
                              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.createdAtText,
                              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Action Buttons ──
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _isSaving ? null : () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: AppColors.textLight.withValues(alpha: 0.3)),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: _isSaving ? null : AppColors.primaryGradient,
                            color: _isSaving ? AppColors.textLight : null,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: _isSaving
                                ? []
                                : [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isSaving ? null : _handleSave,
                              borderRadius: BorderRadius.circular(14),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: Center(
                                  child: _isSaving
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              _isEditing ? 'Update Department' : 'Create Department',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textCapitalization: textCapitalization,
      readOnly: readOnly,
      style: GoogleFonts.inter(color: readOnly ? AppColors.textSecondary : AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 14),
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.priorityUrgent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.priorityUrgent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class _AddCourseDialogContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController codeCtrl;
  final TextEditingController nameCtrl;
  final String createdAtText;
  final Map<String, dynamic>? editItem;

  const _AddCourseDialogContent({
    required this.formKey,
    required this.codeCtrl,
    required this.nameCtrl,
    required this.createdAtText,
    this.editItem,
  });

  @override
  State<_AddCourseDialogContent> createState() => _AddCourseDialogContentState();
}

class _AddCourseDialogContentState extends State<_AddCourseDialogContent> {
  bool _isSaving = false;
  bool _isLoadingDepts = true;
  List<DepartmentModel> _departments = [];
  DepartmentModel? _selectedDepartment;
  bool get _isEditing => widget.editItem != null;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final controller = Provider.of<AdminController>(context, listen: false);
    final depts = await controller.fetchDepartments();
    if (!mounted) return;
    setState(() {
      _departments = depts;
      _isLoadingDepts = false;
      if (_isEditing && widget.editItem!['foreignId'] != null) {
        final fid = widget.editItem!['foreignId'].toString();
        for (final d in _departments) {
          if (d.id == fid || d.code == fid) { _selectedDepartment = d; break; }
        }
      }
    });
  }

  Future<void> _handleSave() async {
    if (!widget.formKey.currentState!.validate()) return;
    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [Icon(Icons.error_outline, color: Colors.white, size: 20), SizedBox(width: 10), Expanded(child: Text('Please select a department'))]),
          backgroundColor: AppColors.priorityUrgent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final controller = Provider.of<AdminController>(context, listen: false);
    String? error;
    if (_isEditing) {
      error = await controller.updateCourse(code: widget.codeCtrl.text, name: widget.nameCtrl.text, departmentId: _selectedDepartment!.id);
    } else {
      error = await controller.addCourse(code: widget.codeCtrl.text, name: widget.nameCtrl.text, departmentId: _selectedDepartment!.id);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.error_outline, color: Colors.white, size: 20), const SizedBox(width: 10), Expanded(child: Text(error))]), backgroundColor: AppColors.priorityUrgent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.check_circle_outline, color: Colors.white, size: 20), const SizedBox(width: 10), Expanded(child: Text(_isEditing ? 'Course updated successfully!' : 'Course created successfully!'))]), backgroundColor: AppColors.priorityLow, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.88;
    return Container(
      width: width,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 15))]),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
              child: Column(children: [
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle), child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 32)),
                const SizedBox(height: 14),
                Text(_isEditing ? 'Edit Course' : 'Add Course', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(_isEditing ? 'Update course details' : 'Create a new academic course', style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.7))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Form(
                key: widget.formKey,
                child: Column(children: [
                  _buildFormField(controller: widget.codeCtrl, label: 'Course Code', hint: 'e.g. BCA, MCA, BTech', icon: Icons.tag_rounded, readOnly: _isEditing, validator: (v) { if (v == null || v.trim().isEmpty) return 'Course code is required'; if (v.trim().length < 2) return 'Code must be at least 2 characters'; return null; }, textCapitalization: TextCapitalization.characters),
                  const SizedBox(height: 16),
                  _buildFormField(controller: widget.nameCtrl, label: 'Course Name', hint: 'e.g. Bachelor of Computer Application', icon: Icons.school_rounded, validator: (v) { if (v == null || v.trim().isEmpty) return 'Course name is required'; if (v.trim().length < 3) return 'Name must be at least 3 characters'; return null; }, textCapitalization: TextCapitalization.words),
                  const SizedBox(height: 16),
                  _isLoadingDepts
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primary.withValues(alpha: 0.08))),
                          child: Row(children: [const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)), const SizedBox(width: 14), Text('Loading departments...', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14))]),
                        )
                      : DropdownButtonFormField<DepartmentModel>(
                          initialValue: _selectedDepartment,
                          decoration: InputDecoration(
                            labelText: 'Department', hintText: 'Select a department',
                            labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
                            hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 14),
                            prefixIcon: Container(margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 18)),
                            filled: true, fillColor: AppColors.background,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent)),
                            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent, width: 1.5)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          dropdownColor: AppColors.surface,
                          style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15),
                          items: _departments.map((dept) => DropdownMenuItem<DepartmentModel>(value: dept, child: Text('${dept.code} - ${dept.name}'))).toList(),
                          onChanged: (val) => setState(() => _selectedDepartment = val),
                          validator: (value) { if (value == null) return 'Please select a department'; return null; },
                        ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primary.withValues(alpha: 0.1))),
                    child: Row(children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18)),
                      const SizedBox(width: 14),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Created At', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(widget.createdAtText, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 28),
                  Row(children: [
                    Expanded(child: TextButton(onPressed: _isSaving ? null : () => Navigator.pop(context), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: AppColors.textLight.withValues(alpha: 0.3)))), child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 15)))),
                    const SizedBox(width: 14),
                    Expanded(flex: 2, child: Container(
                      decoration: BoxDecoration(gradient: _isSaving ? null : AppColors.primaryGradient, color: _isSaving ? AppColors.textLight : null, borderRadius: BorderRadius.circular(14), boxShadow: _isSaving ? [] : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]),
                      child: Material(color: Colors.transparent, child: InkWell(onTap: _isSaving ? null : _handleSave, borderRadius: BorderRadius.circular(14), child: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Center(child: _isSaving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_isEditing ? Icons.check_rounded : Icons.add_circle_outline_rounded, color: Colors.white, size: 20), const SizedBox(width: 8), Text(_isEditing ? 'Update Course' : 'Create Course', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))]))))),
                    )),
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({required TextEditingController controller, required String label, required String hint, required IconData icon, required String? Function(String?) validator, TextCapitalization textCapitalization = TextCapitalization.none, bool readOnly = false}) {
    return TextFormField(
      controller: controller, validator: validator, textCapitalization: textCapitalization, readOnly: readOnly,
      style: GoogleFonts.inter(color: readOnly ? AppColors.textSecondary : AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 14),
        prefixIcon: Container(margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 18)),
        filled: true, fillColor: readOnly ? AppColors.background.withValues(alpha: 0.5) : AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ─── Premium Add Division Dialog ─────────────────────────────────────────────
class _AddDivisionDialogContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController codeCtrl;
  final TextEditingController nameCtrl;
  final String createdAtText;
  final Map<String, dynamic>? editItem;

  const _AddDivisionDialogContent({
    required this.formKey,
    required this.codeCtrl,
    required this.nameCtrl,
    required this.createdAtText,
    this.editItem,
  });

  @override
  State<_AddDivisionDialogContent> createState() => _AddDivisionDialogContentState();
}

class _AddDivisionDialogContentState extends State<_AddDivisionDialogContent> {
  bool _isSaving = false;
  bool _isLoadingCourses = true;
  List<CourseModel> _courses = [];
  CourseModel? _selectedCourse;
  bool get _isEditing => widget.editItem != null;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final controller = Provider.of<AdminController>(context, listen: false);
    final courses = await controller.fetchCourses();
    if (!mounted) return;
    setState(() {
      _courses = courses;
      _isLoadingCourses = false;
      if (_isEditing && widget.editItem!['foreignId'] != null) {
        final fid = widget.editItem!['foreignId'].toString();
        for (final c in _courses) {
          if (c.id == fid || c.code == fid) { _selectedCourse = c; break; }
        }
      }
    });
  }

  Future<void> _handleSave() async {
    if (!widget.formKey.currentState!.validate()) return;
    if (_selectedCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Row(children: [Icon(Icons.error_outline, color: Colors.white, size: 20), SizedBox(width: 10), Expanded(child: Text('Please select a course'))]), backgroundColor: AppColors.priorityUrgent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
      return;
    }

    setState(() => _isSaving = true);

    final controller = Provider.of<AdminController>(context, listen: false);
    String? error;
    if (_isEditing) {
      error = await controller.updateDivision(code: widget.codeCtrl.text, name: widget.nameCtrl.text, courseId: _selectedCourse!.id);
    } else {
      error = await controller.addDivision(code: widget.codeCtrl.text, name: widget.nameCtrl.text, courseId: _selectedCourse!.id);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.error_outline, color: Colors.white, size: 20), const SizedBox(width: 10), Expanded(child: Text(error))]), backgroundColor: AppColors.priorityUrgent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.check_circle_outline, color: Colors.white, size: 20), const SizedBox(width: 10), Expanded(child: Text(_isEditing ? 'Division updated successfully!' : 'Division created successfully!'))]), backgroundColor: AppColors.priorityLow, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.88;
    return Container(
      width: width,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 15))]),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
              child: Column(children: [
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle), child: const Icon(Icons.groups_rounded, color: Colors.white, size: 32)),
                const SizedBox(height: 14),
                Text(_isEditing ? 'Edit Division' : 'Add Division', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(_isEditing ? 'Update division details' : 'Create a new class division', style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.7))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Form(
                key: widget.formKey,
                child: Column(children: [
                  _buildFormField(controller: widget.codeCtrl, label: 'Division Code', hint: 'e.g. A, B, C', icon: Icons.tag_rounded, readOnly: _isEditing, validator: (v) { if (v == null || v.trim().isEmpty) return 'Division code is required'; return null; }, textCapitalization: TextCapitalization.characters),
                  const SizedBox(height: 16),
                  _buildFormField(controller: widget.nameCtrl, label: 'Division Name', hint: 'e.g. Division A', icon: Icons.class_rounded, validator: (v) { if (v == null || v.trim().isEmpty) return 'Division name is required'; if (v.trim().length < 2) return 'Name must be at least 2 characters'; return null; }, textCapitalization: TextCapitalization.words),
                  const SizedBox(height: 16),
                  _isLoadingCourses
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primary.withValues(alpha: 0.08))),
                          child: Row(children: [const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)), const SizedBox(width: 14), Text('Loading courses...', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14))]),
                        )
                      : DropdownButtonFormField<CourseModel>(
                          initialValue: _selectedCourse,
                          decoration: InputDecoration(
                            labelText: 'Course', hintText: 'Select a course',
                            labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
                            hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 14),
                            prefixIcon: Container(margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 18)),
                            filled: true, fillColor: AppColors.background,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent)),
                            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent, width: 1.5)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          dropdownColor: AppColors.surface,
                          style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15),
                          items: _courses.map((c) => DropdownMenuItem<CourseModel>(value: c, child: Text('${c.code} - ${c.name}'))).toList(),
                          onChanged: (val) => setState(() => _selectedCourse = val),
                          validator: (value) { if (value == null) return 'Please select a course'; return null; },
                        ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primary.withValues(alpha: 0.1))),
                    child: Row(children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18)),
                      const SizedBox(width: 14),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Created At', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(widget.createdAtText, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 28),
                  Row(children: [
                    Expanded(child: TextButton(onPressed: _isSaving ? null : () => Navigator.pop(context), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: AppColors.textLight.withValues(alpha: 0.3)))), child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 15)))),
                    const SizedBox(width: 14),
                    Expanded(flex: 2, child: Container(
                      decoration: BoxDecoration(gradient: _isSaving ? null : AppColors.primaryGradient, color: _isSaving ? AppColors.textLight : null, borderRadius: BorderRadius.circular(14), boxShadow: _isSaving ? [] : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]),
                      child: Material(color: Colors.transparent, child: InkWell(onTap: _isSaving ? null : _handleSave, borderRadius: BorderRadius.circular(14), child: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Center(child: _isSaving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_isEditing ? Icons.check_rounded : Icons.add_circle_outline_rounded, color: Colors.white, size: 20), const SizedBox(width: 8), Text(_isEditing ? 'Update Division' : 'Create Division', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))]))))),
                    )),
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({required TextEditingController controller, required String label, required String hint, required IconData icon, required String? Function(String?) validator, TextCapitalization textCapitalization = TextCapitalization.none, bool readOnly = false}) {
    return TextFormField(
      controller: controller, validator: validator, textCapitalization: textCapitalization, readOnly: readOnly,
      style: GoogleFonts.inter(color: readOnly ? AppColors.textSecondary : AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 14),
        prefixIcon: Container(margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 18)),
        filled: true, fillColor: readOnly ? AppColors.background.withValues(alpha: 0.5) : AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ─── Premium Add Subject Dialog ──────────────────────────────────────────────
class _AddSubjectDialogContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController codeCtrl;
  final TextEditingController nameCtrl;
  final String createdAtText;
  final Map<String, dynamic>? editItem;

  const _AddSubjectDialogContent({
    required this.formKey,
    required this.codeCtrl,
    required this.nameCtrl,
    required this.createdAtText,
    this.editItem,
  });

  @override
  State<_AddSubjectDialogContent> createState() => _AddSubjectDialogContentState();
}

class _AddSubjectDialogContentState extends State<_AddSubjectDialogContent> {
  bool _isSaving = false;
  bool _isLoadingDivisions = true;
  List<DivisionModel> _divisions = [];
  DivisionModel? _selectedDivision;
  bool get _isEditing => widget.editItem != null;

  @override
  void initState() {
    super.initState();
    _loadDivisions();
  }

  Future<void> _loadDivisions() async {
    final controller = Provider.of<AdminController>(context, listen: false);
    final divs = await controller.fetchDivisions();
    if (!mounted) return;
    setState(() {
      _divisions = divs;
      _isLoadingDivisions = false;
      if (_isEditing && widget.editItem!['foreignId'] != null) {
        final fid = widget.editItem!['foreignId'].toString();
        for (final d in _divisions) {
          if (d.id == fid || d.code == fid) { _selectedDivision = d; break; }
        }
      }
    });
  }

  Future<void> _handleSave() async {
    if (!widget.formKey.currentState!.validate()) return;
    if (_selectedDivision == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Row(children: [Icon(Icons.error_outline, color: Colors.white, size: 20), SizedBox(width: 10), Expanded(child: Text('Please select a division'))]), backgroundColor: AppColors.priorityUrgent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
      return;
    }

    setState(() => _isSaving = true);

    final controller = Provider.of<AdminController>(context, listen: false);
    String? error;
    if (_isEditing) {
      error = await controller.updateSubject(code: widget.codeCtrl.text, name: widget.nameCtrl.text, divisionId: _selectedDivision!.id);
    } else {
      error = await controller.addSubject(code: widget.codeCtrl.text, name: widget.nameCtrl.text, divisionId: _selectedDivision!.id);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.error_outline, color: Colors.white, size: 20), const SizedBox(width: 10), Expanded(child: Text(error))]), backgroundColor: AppColors.priorityUrgent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.check_circle_outline, color: Colors.white, size: 20), const SizedBox(width: 10), Expanded(child: Text(_isEditing ? 'Subject updated successfully!' : 'Subject created successfully!'))]), backgroundColor: AppColors.priorityLow, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.88;
    return Container(
      width: width,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 15))]),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
              child: Column(children: [
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle), child: const Icon(Icons.science_rounded, color: Colors.white, size: 32)),
                const SizedBox(height: 14),
                Text(_isEditing ? 'Edit Subject' : 'Add Subject', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(_isEditing ? 'Update subject details' : 'Create a new subject', style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.7))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Form(
                key: widget.formKey,
                child: Column(children: [
                  _buildFormField(controller: widget.codeCtrl, label: 'Subject Code', hint: 'e.g. CS101, MA201', icon: Icons.tag_rounded, readOnly: _isEditing, validator: (v) { if (v == null || v.trim().isEmpty) return 'Subject code is required'; if (v.trim().length < 2) return 'Code must be at least 2 characters'; return null; }, textCapitalization: TextCapitalization.characters),
                  const SizedBox(height: 16),
                  _buildFormField(controller: widget.nameCtrl, label: 'Subject Name', hint: 'e.g. Data Structures', icon: Icons.book_rounded, validator: (v) { if (v == null || v.trim().isEmpty) return 'Subject name is required'; if (v.trim().length < 3) return 'Name must be at least 3 characters'; return null; }, textCapitalization: TextCapitalization.words),
                  const SizedBox(height: 16),
                  _isLoadingDivisions
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primary.withValues(alpha: 0.08))),
                          child: Row(children: [const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)), const SizedBox(width: 14), Text('Loading divisions...', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14))]),
                        )
                      : DropdownButtonFormField<DivisionModel>(
                          initialValue: _selectedDivision,
                          decoration: InputDecoration(
                            labelText: 'Division', hintText: 'Select a division',
                            labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
                            hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 14),
                            prefixIcon: Container(margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.groups_rounded, color: AppColors.primary, size: 18)),
                            filled: true, fillColor: AppColors.background,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent)),
                            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent, width: 1.5)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          dropdownColor: AppColors.surface,
                          style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15),
                          items: _divisions.map((d) => DropdownMenuItem<DivisionModel>(value: d, child: Text('${d.code} - ${d.name}'))).toList(),
                          onChanged: (val) => setState(() => _selectedDivision = val),
                          validator: (value) { if (value == null) return 'Please select a division'; return null; },
                        ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primary.withValues(alpha: 0.1))),
                    child: Row(children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18)),
                      const SizedBox(width: 14),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Created At', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(widget.createdAtText, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 28),
                  Row(children: [
                    Expanded(child: TextButton(onPressed: _isSaving ? null : () => Navigator.pop(context), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: AppColors.textLight.withValues(alpha: 0.3)))), child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 15)))),
                    const SizedBox(width: 14),
                    Expanded(flex: 2, child: Container(
                      decoration: BoxDecoration(gradient: _isSaving ? null : AppColors.primaryGradient, color: _isSaving ? AppColors.textLight : null, borderRadius: BorderRadius.circular(14), boxShadow: _isSaving ? [] : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]),
                      child: Material(color: Colors.transparent, child: InkWell(onTap: _isSaving ? null : _handleSave, borderRadius: BorderRadius.circular(14), child: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Center(child: _isSaving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_isEditing ? Icons.check_rounded : Icons.add_circle_outline_rounded, color: Colors.white, size: 20), const SizedBox(width: 8), Text(_isEditing ? 'Update Subject' : 'Create Subject', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))]))))),
                    )),
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({required TextEditingController controller, required String label, required String hint, required IconData icon, required String? Function(String?) validator, TextCapitalization textCapitalization = TextCapitalization.none, bool readOnly = false}) {
    return TextFormField(
      controller: controller, validator: validator, textCapitalization: textCapitalization, readOnly: readOnly,
      style: GoogleFonts.inter(color: readOnly ? AppColors.textSecondary : AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 14),
        prefixIcon: Container(margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 18)),
        filled: true, fillColor: readOnly ? AppColors.background.withValues(alpha: 0.5) : AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.priorityUrgent, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

