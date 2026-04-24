import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../models/app_models.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('مهامي اليومية'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentBlue,
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add, color: AppTheme.mainText),
      ),
      body: data.tasks.isEmpty 
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.tasks.length,
            itemBuilder: (context, index) {
              final task = data.tasks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassContainer(
                  color: Colors.white,
                  child: ListTile(
                    onTap: () => data.toggleTask(task.id),
                    leading: Icon(
                      task.isCompleted 
                        ? FontAwesomeIcons.solidCircleCheck 
                        : FontAwesomeIcons.circle,
                      color: task.isCompleted ? Colors.green : _getPriorityColor(task.priority),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? AppTheme.secondaryText : AppTheme.mainText,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getPriorityText(task.priority),
                        style: TextStyle(
                          color: _getPriorityColor(task.priority),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.clipboardList, size: 60, color: AppTheme.accentBlue.withValues(alpha: 0.5)),
          const SizedBox(height: 20),
          const Text('لا توجد مهام اليوم، استمتع بوقتك!', style: TextStyle(color: AppTheme.secondaryText, fontSize: 16)),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high: return Colors.redAccent;
      case TaskPriority.medium: return Colors.orange;
      case TaskPriority.low: return Colors.blue;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high: return 'هام جداً';
      case TaskPriority.medium: return 'متوسط';
      case TaskPriority.low: return 'عادي';
    }
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('إضافة مهمة جديدة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'ما هي المهمة؟',
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('الأولوية:', style: TextStyle(fontSize: 12, color: AppTheme.secondaryText)),
              ),
              DropdownButton<TaskPriority>(
                value: selectedPriority,
                isExpanded: true,
                items: TaskPriority.values.map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(_getPriorityText(p)),
                )).toList(),
                onChanged: (val) => setState(() => selectedPriority = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<AppDataProvider>().addTask(controller.text, selectedPriority);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentBlue),
              child: const Text('إضافة', style: TextStyle(color: AppTheme.mainText)),
            ),
          ],
        ),
      ),
    );
  }
}
