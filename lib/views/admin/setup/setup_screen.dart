import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../controllers/admin_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/ui_helper.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  static final List<Map<String, dynamic>> _setupItems = [
    {'title': 'Department', 'icon': Icons.business_rounded, 'count': 6, 'desc': 'Manage academic departments'},
    {'title': 'Course', 'icon': Icons.menu_book_rounded, 'count': 12, 'desc': 'Configure available courses'},
    {'title': 'Division', 'icon': Icons.groups_rounded, 'count': 8, 'desc': 'Organize class divisions'},
    {'title': 'Subject', 'icon': Icons.science_rounded, 'count': 24, 'desc': 'Setup subjects & syllabus'},
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
                          Text(
                            '${item['count']}',
                            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${item['count']}',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                              ),
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
  late List<Map<String, dynamic>> _allItems;
  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _allItems = List.generate(8, (index) => {
      'id': '#100${index + 1}',
      'name': 'Mock ${widget.title} ${index + 1}',
      'index': index + 1,
    });
    _filteredItems = _allItems;
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
      _filteredItems = _allItems.where((item) {
        return item['name']!.toLowerCase().contains(query) ||
               item['id']!.toLowerCase().contains(query);
      }).toList();
    });
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
            child: _filteredItems.isEmpty
                ? const Center(child: Text('No items found.', style: TextStyle(color: AppColors.textSecondary)))
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                        color: AppColors.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          subtitle: Text('ID: ${item['id']}', style: const TextStyle(color: AppColors.textSecondary)),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text('${item['index']}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.priorityUrgent),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted ${item['name']}')));
                            },
                          ),
                        ),
                      ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.05);
                    },
                  ),
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

  void _showAddDialog(BuildContext context, String title) {
    if (title == 'Department') {
      _showAddDepartmentDialog(context);
      return;
    }
    final TextEditingController nameCtrl = TextEditingController();
    UIHelper.showCustomDialog(
      context: context,
      title: 'Add $title',
      content: UIHelper.customTextField(
        controller: nameCtrl,
        hintText: 'Enter $title Name',
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title saved successfully!')));
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _showAddDepartmentDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final now = DateTime.now();
    final createdAtText = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}  •  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Department',
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

  const _AddDepartmentDialogContent({
    required this.formKey,
    required this.codeCtrl,
    required this.nameCtrl,
    required this.createdAtText,
  });

  @override
  State<_AddDepartmentDialogContent> createState() => _AddDepartmentDialogContentState();
}

class _AddDepartmentDialogContentState extends State<_AddDepartmentDialogContent> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final controller = Provider.of<AdminController>(context, listen: false);
    final error = await controller.addDepartment(
      code: widget.codeCtrl.text,
      name: widget.nameCtrl.text,
    );

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
              const Expanded(child: Text('Department created successfully!')),
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
                  'Add Department',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create a new academic department',
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
                                            const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Create Department',
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
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textCapitalization: textCapitalization,
      style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15),
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
