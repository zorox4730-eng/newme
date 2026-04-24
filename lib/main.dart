import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_provider.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/journal_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'screens/ai_chat_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppDataProvider(),
      child: const NewMeApp(),
    ),
  );
}

class NewMeApp extends StatelessWidget {
  const NewMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEW ME',
      debugShowCheckedModeBanner: false,
      theme: context.watch<AppDataProvider>().currentThemeData,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TasksScreen(),
    const JournalScreen(),
    const AIChatScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: AppTheme.accentBlue,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.house, size: 20),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.listCheck, size: 20),
              label: 'المهام',
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.penNib, size: 20),
              label: 'اليوميات',
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.robot, size: 20),
              label: 'الذكاء',
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.gear, size: 20),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}
