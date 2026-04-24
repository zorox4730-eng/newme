import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('الإعدادات المتطورة')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileHeader(data, context),
          const SizedBox(height: 30),
          _buildSectionTitle(context, 'التحكم في المساعد'),
          _buildSettingTile(
            icon: Icons.record_voice_over,
            color: Colors.pink,
            title: 'نوع الصوت',
            subtitle: data.voiceType == 'female' ? 'أنثى' : 'ذكر',
            onTap: () => _showVoiceDialog(context, data),
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            icon: Icons.language,
            color: Colors.green,
            title: 'لغة التطبيق',
            subtitle: data.language == 'ar' ? 'العربية' : 'English',
            onTap: () => _showLanguageDialog(context, data),
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            icon: Icons.palette,
            color: Colors.deepPurple,
            title: 'السمات (Simada)',
            subtitle: _getThemeFriendlyName(data.themeName),
            onTap: () => _showThemeDialog(context, data),
          ),
          const SizedBox(height: 30),
          _buildSectionTitle(context, 'إحصائيات الإنجاز'),
          Row(
            children: [
              Expanded(child: _buildSimpleStat('المهام', '${data.tasks.where((t) => t.isCompleted).length}/${data.tasks.length}')),
              const SizedBox(width: 15),
              Expanded(child: _buildSimpleStat('اليوميات', '${data.journalEntries.length}')),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('إعادة ضبط التطبيق', style: TextStyle(color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.primary)),
    );
  }

  Widget _buildSettingTile({required IconData icon, required Color color, required String title, required String subtitle, required VoidCallback onTap}) {
    return GlassContainer(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right, size: 18),
      ),
    );
  }

  Widget _buildProfileHeader(AppDataProvider data, BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showNameDialog(context, data),
          child: Hero(
            tag: 'ai_avatar',
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Icon(Icons.smart_toy, size: 50, color: Theme.of(context).colorScheme.primary)),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(data.aiName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text('انقر على الصورة لتغيير اسمي', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildSimpleStat(String label, String value) {
    return GlassContainer(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText)),
          ],
        ),
      ),
    );
  }

  void _showNameDialog(BuildContext context, AppDataProvider data) {
    final controller = TextEditingController(text: data.aiName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغيير اسم المساعد'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'أدخل الاسم الجديد...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () {
            data.setAiName(controller.text);
            Navigator.pop(context);
          }, child: const Text('حفظ')),
        ],
      ),
    );
  }

  void _showVoiceDialog(BuildContext context, AppDataProvider data) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر جرس الصوت', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.face_3, color: Colors.pink),
              title: const Text('صوت أنثوي'),
              onTap: () { data.setVoiceType('female'); Navigator.pop(context); },
              trailing: data.voiceType == 'female' ? const Icon(Icons.check, color: Colors.green) : null,
            ),
            ListTile(
              leading: const Icon(Icons.face, color: Colors.blue),
              title: const Text('صوت ذكوري'),
              onTap: () { data.setVoiceType('male'); Navigator.pop(context); },
              trailing: data.voiceType == 'male' ? const Icon(Icons.check, color: Colors.green) : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppDataProvider data) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر لغة التعامل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('العربية'),
              onTap: () { data.setLanguage('ar'); Navigator.pop(context); },
              trailing: data.language == 'ar' ? const Icon(Icons.check, color: Colors.green) : null,
            ),
            ListTile(
              title: const Text('English'),
              onTap: () { data.setLanguage('en'); Navigator.pop(context); },
              trailing: data.language == 'en' ? const Icon(Icons.check, color: Colors.green) : null,
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeFriendlyName(String theme) {
    switch (theme) {
      case 'pastel': return 'باستيل هادئ';
      case 'dark': return 'الوضع الليلي';
      case 'gold': return 'الملكي الذهبي';
      case 'emerald': return 'الزمرد الطبيعي';
      default: return theme;
    }
  }

  void _showThemeDialog(BuildContext context, AppDataProvider data) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر المظهر (Simada)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _themeOption(context, data, 'pastel', 'باستيل هادئ', Icons.wb_sunny, Colors.blue),
            _themeOption(context, data, 'dark', 'الوضع الليلي', Icons.nightlight_round, Colors.indigo),
            _themeOption(context, data, 'gold', 'الملكي الذهبي', Icons.stars, Colors.amber),
            _themeOption(context, data, 'emerald', 'الزمرد الطبيعي', Icons.eco, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _themeOption(BuildContext context, AppDataProvider data, String key, String name, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(name),
      onTap: () { data.setTheme(key); Navigator.pop(context); },
      trailing: data.themeName == key ? const Icon(Icons.check, color: Colors.green) : null,
    );
  }
}
