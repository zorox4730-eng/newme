import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import '../services/app_provider.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Voice Tools
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("ar");
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text, String voiceType) async {
    // محاكاة اختيار الصوت (يعتمد على دعم النظام)
    if (voiceType == 'male') {
      await _flutterTts.setPitch(0.8);
    } else {
      await _flutterTts.setPitch(1.2);
    }
    await _flutterTts.speak(text);
  }

  void _listen(AppDataProvider data) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              // اختياري: إرسال تلقائي عند التوقف
            }
          }),
          localeId: data.language == "ar" ? "ar-SA" : "en-US",
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_controller.text.isNotEmpty) {
        _sendMessage(data);
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: 'ai_avatar',
              child: const CircleAvatar(
                backgroundColor: AppTheme.accentBlue,
                radius: 18,
                child: Icon(Icons.smart_toy, size: 16, color: AppTheme.mainText),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.aiName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  data.isAiTyping ? 'جاري التفكير...' : (_isListening ? 'أنا أسمعك...' : 'متصل الآن'),
                  style: TextStyle(fontSize: 11, color: _isListening ? Colors.pink : (data.isAiTyping ? Colors.blue : Colors.green)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, size: 20),
            onPressed: () {
              if (data.chatHistory.isNotEmpty) {
                _speak(data.chatHistory.last.text, data.voiceType);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: data.chatHistory.length,
              itemBuilder: (context, index) {
                final message = data.chatHistory[index];
                return _buildChatBubble(message, data);
              },
            ),
          ),
          if (data.isAiTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: LinearProgressIndicator(minHeight: 1, backgroundColor: Colors.transparent),
            ),
          _buildInputArea(data),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, AppDataProvider data) {
    return Column(
      crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: GlassContainer(
              color: message.isUser ? AppTheme.accentBlue : Colors.white,
              borderRadius: message.isUser 
                ? const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                : const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  message.text,
                  style: const TextStyle(color: AppTheme.mainText, fontSize: 16, height: 1.4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea(AppDataProvider data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: GlassContainer(
              color: AppTheme.backgroundLight,
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: AppTheme.mainText),
                decoration: const InputDecoration(
                  hintText: 'تحدث معي...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onSubmitted: (val) => _sendMessage(data),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AvatarGlow(
            animate: _isListening,
            glowColor: Colors.pink,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            child: CircleAvatar(
              backgroundColor: _isListening ? Colors.pink : AppTheme.accentBlue,
              child: IconButton(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: AppTheme.mainText),
                onPressed: () => _listen(data),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppTheme.mainText,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: () => _sendMessage(data),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(AppDataProvider data) async {
    if (_controller.text.isNotEmpty) {
      final text = _controller.text;
      _controller.clear();
      await data.sendChatMessage(text);
      _scrollToBottom();
      
      // التحدث تلقائياً بعد استلام الرد
      if (data.chatHistory.isNotEmpty && !data.chatHistory.last.isUser) {
        _speak(data.chatHistory.last.text, data.voiceType);
      }
    }
  }
}
