import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('سجل اللحظات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.pink),
            onPressed: () => _showAddEntryDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentPink,
        onPressed: () => _showAddEntryDialog(context),
        child: const Icon(Icons.edit, color: AppTheme.mainText),
      ),
      body: data.journalEntries.isEmpty 
        ? _buildEmptyState(context)
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.journalEntries.length,
            itemBuilder: (context, index) {
              final entry = data.journalEntries[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (index != data.journalEntries.length - 1)
                          Container(
                            width: 2,
                            height: 100,
                            color: Colors.pinkAccent.withValues(alpha: 0.1),
                          ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('yyyy/MM/dd - hh:mm a').format(entry.timestamp),
                            style: const TextStyle(color: AppTheme.secondaryText, fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          GlassContainer(
                            color: Colors.white,
                            borderRadius: 18.0,
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Text(
                                entry.content,
                                style: const TextStyle(
                                  color: AppTheme.mainText, 
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories, size: 80, color: AppTheme.accentPink.withValues(alpha: 0.5)),
          const SizedBox(height: 20),
          const Text(
            'سجلك اليومي لا يزال فارغاً',
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showAddEntryDialog(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPink),
            child: const Text('أضف أول يومية لك الآن', style: TextStyle(color: AppTheme.mainText)),
          ),
        ],
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('تدوين لحظة جديدة'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'عبر عن مشاعرك أو ما حدث معك...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<AppDataProvider>().addJournalEntry(controller.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPink),
            child: const Text('حفظ', style: TextStyle(color: AppTheme.mainText)),
          ),
        ],
      ),
    );
  }
}
