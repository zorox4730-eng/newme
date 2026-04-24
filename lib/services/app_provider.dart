import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import 'ai_service.dart';
import 'gemini_service.dart';
import 'config.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isUser: json['isUser'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class AppDataProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<JournalEntry> _journalEntries = [];
  List<ChatMessage> _chatHistory = [];
  bool _isLoading = true;
  bool _isAiTyping = false;
  String? _apiKey;

  // AI Identity & Settings
  String _aiName = "مساعدي الذكي";
  String _voiceType = "female"; // female or male
  String _language = "ar"; // ar or en
  String _themeName = "pastel"; // pastel, dark, gold, emerald

  List<Task> get tasks => _tasks;
  List<JournalEntry> get journalEntries => _journalEntries;
  List<ChatMessage> get chatHistory => _chatHistory;
  bool get isLoading => _isLoading;
  bool get isAiTyping => _isAiTyping;
  String? get apiKey => _apiKey;
  String get aiName => _aiName;
  String get voiceType => _voiceType;
  String get language => _language;
  String get themeName => _themeName;
  ThemeData get currentThemeData => AppTheme.getTheme(_themeName);

  AppDataProvider() {
    loadData();
  }

  Future<void> setAiName(String name) async {
    _aiName = name;
    (await SharedPreferences.getInstance()).setString('ai_name', name);
    notifyListeners();
  }

  Future<void> setVoiceType(String type) async {
    _voiceType = type;
    (await SharedPreferences.getInstance()).setString('voice_type', type);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    (await SharedPreferences.getInstance()).setString('language', lang);
    notifyListeners();
  }

  Future<void> setApiKey(String key) async {
    _apiKey = key;
    (await SharedPreferences.getInstance()).setString('api_key', key);
    notifyListeners();
  }

  Future<void> setTheme(String name) async {
    _themeName = name;
    (await SharedPreferences.getInstance()).setString('theme_name', name);
    notifyListeners();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('api_key');
    _aiName = prefs.getString('ai_name') ?? "مساعدي الذكي";
    _voiceType = prefs.getString('voice_type') ?? "female";
    _language = prefs.getString('language') ?? "ar";
    _themeName = prefs.getString('theme_name') ?? "pastel";
    
    final tasksJson = prefs.getString('tasks') ?? '[]';
    _tasks = (json.decode(tasksJson) as List).map((t) => Task.fromJson(t)).toList();

    final journalJson = prefs.getString('journal') ?? '[]';
    _journalEntries = (json.decode(journalJson) as List).map((j) => JournalEntry.fromJson(j)).toList();

    final chatJson = prefs.getString('chat') ?? '[]';
    final List<dynamic> decodedChat = json.decode(chatJson);
    _chatHistory = decodedChat.map((c) => ChatMessage.fromJson(c)).toList();

    if (_chatHistory.isEmpty) {
      _chatHistory.add(ChatMessage(text: "مرحباً بك! أنا $_aiName. كيف يمكنني مساعدتك؟", isUser: false));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveTasks() async => (await SharedPreferences.getInstance()).setString('tasks', json.encode(_tasks.map((t) => t.toJson()).toList()));
  Future<void> saveJournal() async => (await SharedPreferences.getInstance()).setString('journal', json.encode(_journalEntries.map((j) => j.toJson()).toList()));
  Future<void> saveChat() async => (await SharedPreferences.getInstance()).setString('chat', json.encode(_chatHistory.map((c) => c.toJson()).toList()));

  void addTask(String title, TaskPriority priority) {
    _tasks.add(Task(title: title, priority: priority));
    saveTasks();
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      saveTasks();
      notifyListeners();
    }
  }

  void addJournalEntry(String content) {
    _journalEntries.insert(0, JournalEntry(content: content));
    saveJournal();
    notifyListeners();
  }

  Future<void> sendChatMessage(String message) async {
    _chatHistory.add(ChatMessage(text: message, isUser: true));
    _isAiTyping = true;
    notifyListeners();
    saveChat();

    String response;
    final effectiveApiKey = (_apiKey != null && _apiKey!.isNotEmpty) ? _apiKey : Config.globalGeminiKey;

    if (effectiveApiKey != null && effectiveApiKey.isNotEmpty) {
      response = await GeminiService.getGeminiResponse(effectiveApiKey, message, _tasks, _journalEntries, _aiName, _language);
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      response = AIService.getSmartResponse(message, _tasks, _journalEntries);
    }
    
    _chatHistory.add(ChatMessage(text: response, isUser: false));
    _isAiTyping = false;
    notifyListeners();
    saveChat();
  }
}
