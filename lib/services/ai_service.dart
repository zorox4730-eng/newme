import '../models/app_models.dart';

class AIService {
  static String getSmartResponse(String message, List<Task> tasks, List<JournalEntry> journal) {
    final cleanMessage = message.trim().toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه');
    
    final now = DateTime.now();
    String greeting = "طاب يومك!";
    if (now.hour < 12) {
      greeting = "صباح الخير!";
    } else if (now.hour < 18) {
      greeting = "مساء الخير!";
    } else {
      greeting = "طاب مساؤك!";
    }

    // استجابة ذكية لعدم وجود مفتاح API
    if (cleanMessage.contains("غبى") || cleanMessage.contains("ما بيفهم") || cleanMessage.contains("لا يفهم")) {
      return "أعتذر منك! أنا حالياً أعمل بوضع 'المحرك الاحتياطي'. لكي أكون ذكياً جداً وأفهمك بعمق، تأكد من وضع 'مفتاح Gemini العالمي' في كود التطبيق. عندها سأبهرك بذكائي الخارق!";
    }

    // 1. التعريف بالنفس
    if (cleanMessage.contains("اسم") || cleanMessage.contains("من انت") || cleanMessage.contains("مين انت")) {
      return "أنا مساعدك الشخصي في رحلة 'أنا الجديد'. بمجرد تفعيل مفتاح الذكاء الخاص بي، سأكون رفيقك الدائم في تحقيق أهدافك.";
    }

    // 2. التحيات
    final greetings = ["مرحبا", "اهلا", "سلام", "هلا", "هاي", "صباح", "مساء"];
    if (greetings.any((g) => cleanMessage.contains(g))) {
      return "$greeting أنا هنا ومستعد لسماعك. هل نلقي نظرة على مهامك أم نكتب في يومياتك؟";
    }

    // 3. طلب نصيحة أو مساعدة
    if (cleanMessage.contains("كيف") || cleanMessage.contains("نصيحه") || cleanMessage.contains("ساعدني")) {
      return "أنا أحب روح المبادرة لديك! لتقديم نصيحة دقيقة جداً، أحتاج منك تفعيل مفتاح Gemini في الإعدادات. لكن بشكل عام: ابدأ بأهم مهمة لديك الآن وهي تنظيم مهامك في تبويب المهام.";
    }

    // 4. التفاعل مع المهام (مُطور)
    if (cleanMessage.contains("مهم") || cleanMessage.contains("شغل") || cleanMessage.contains("عمل") || cleanMessage.contains("افعل")) {
      final pendingTasks = tasks.where((t) => !t.isCompleted).toList();
      if (pendingTasks.isEmpty) {
        return "يومك يسير بشكل رائع! كل المهام منجزة. استغل هذا الوقت في تدوين تأملاتك في السجل اليومي.";
      } else {
        final highPriority = pendingTasks.where((t) => t.priority == TaskPriority.high).toList();
        String response = "لديك حالياً ${pendingTasks.length} مهام متبقية.";
        if (highPriority.isNotEmpty) {
          response += "\n\nأرشح لك البدء بـ '${highPriority.first.title}' فوراً للتقدم بسرعة.";
        }
        return response;
      }
    }

    // الرد الافتراضي
    return "رسالة جميلة! لكي أستطيع الرد على هذا النوع من الأسئلة المعقدة، أنا بانتظار أن تضع لي مفتاح الذكاء (Gemini Key) في شاشة الإعدادات. سأنتظرك!";
  }
}
