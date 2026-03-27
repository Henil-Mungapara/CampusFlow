import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/ui_helper.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  void _onCardTap(BuildContext context, String title) {
    UIHelper.showCustomDialog(
      context: context,
      title: 'Manage $title',
      content: Text('What would you like to do with $title?', style: const TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            _showAddDialog(context, title);
          },
          child: const Text('Add', style: TextStyle(color: AppColors.primary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            Navigator.pop(context); // Close dialog
            _showViewScreen(context, title);
          },
          child: const Text('View', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context, String title) {
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
            // Mock save
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title saved successfully!')));
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _showViewScreen(BuildContext context, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SetupViewScreen(title: title)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSetupCard(context, 'Department', Icons.business),
          _buildSetupCard(context, 'Course', Icons.book_rounded),
          _buildSetupCard(context, 'Division', Icons.group),
          _buildSetupCard(context, 'Subject', Icons.subject),
        ],
      ),
    );
  }

  Widget _buildSetupCard(BuildContext context, String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _onCardTap(context, title),
      ),
    );
  }
}

class SetupViewScreen extends StatelessWidget {
  final String title;
  const SetupViewScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View $title', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: UIHelper.customTextField(
              controller: TextEditingController(),
              hintText: 'Search $title...',
              icon: Icons.search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  color: AppColors.surface,
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text('Mock $title ${index + 1}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('ID: #100${index + 1}'),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text('${index + 1}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.priorityUrgent),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted mock $title ${index + 1}')));
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
