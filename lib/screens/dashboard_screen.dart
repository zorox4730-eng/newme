import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.accentBlue,
              AppTheme.backgroundLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحباً بك،',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'أنا الجديد 👋',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person_outline, color: AppTheme.mainText),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'مهامك',
                        '${data.tasks.where((t) => t.isCompleted).length}/${data.tasks.length}',
                        FontAwesomeIcons.circleCheck,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'يومياتك',
                        '${data.journalEntries.length}',
                        FontAwesomeIcons.heart,
                        Colors.pink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'نظرة سريعة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mainText,
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: data.tasks.isEmpty 
                    ? const Center(child: Text('ابدأ بإضافة مهامك اليومية', style: TextStyle(color: AppTheme.secondaryText)))
                    : ListView.builder(
                        itemCount: data.tasks.length > 3 ? 3 : data.tasks.length,
                        itemBuilder: (context, index) {
                          final task = data.tasks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassContainer(
                              color: Colors.white.withValues(alpha: 0.6),
                              child: ListTile(
                                leading: Icon(
                                  task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                                  color: task.isCompleted ? Colors.green : AppTheme.secondaryText,
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    color: task.isCompleted ? AppTheme.secondaryText : AppTheme.mainText,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ),
                const SizedBox(height: 10),
                _buildQuickJournal(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return GlassContainer(
      color: Colors.white.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 14)),
            Text(value, style: const TextStyle(color: AppTheme.mainText, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickJournal(BuildContext context) {
    final controller = TextEditingController();
    return GlassContainer(
      color: AppTheme.accentPink.withValues(alpha: 0.3),
      border: Border.all(color: AppTheme.accentPink.withValues(alpha: 0.5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: AppTheme.mainText),
                decoration: const InputDecoration(
                  hintText: 'كيف تشعر الآن؟',
                  hintStyle: TextStyle(color: AppTheme.secondaryText, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.pinkAccent),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<AppDataProvider>().addJournalEntry(controller.text);
                  controller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تدوين لحظتك بنجاح ✨')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
