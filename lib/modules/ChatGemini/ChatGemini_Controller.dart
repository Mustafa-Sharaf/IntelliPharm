/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/ChatService.dart';
import 'ChatGemini_Model.dart';


class ChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  int? currentConversationId;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();


  Future<void> sendChatMessage() async {
    String userText = textController.text.trim();
    if (userText.isEmpty) return;

    // 1. إضافة رسالة المستخدم فوراً للواجهة وتفريغ الحقل
    final userMessage = ChatMessageModel(role: 'user', message: userText);
    messages.add(userMessage);
    textController.clear();
    scrollToBottom();

    // 2. إضافة رسالة وهمية "مؤقتة" للمودل لإظهار مؤشر التحميل (Loading) للبوت
    final placeholderMessage = ChatMessageModel(role: 'model', message: '', isLoading: true);
    messages.add(placeholderMessage);
    scrollToBottom();

    try {
      // 3. استدعاء الـ API
      final responseData = await ChatService.sendMessage(
        message: userText,
        conversationId: currentConversationId,
      );

      // إزالة رسالة التحميل المؤقتة
      messages.remove(placeholderMessage);

      if (responseData != null && responseData['isSuccess'] == true) {
        final data = responseData['data'];
        if (data != null) {
          // تحديث الـ conversationId إذا كان أول إرسال
          if (currentConversationId == null && data['conversation_id'] != null) {
            currentConversationId = data['conversation_id'];
          }

          // إضافة رد المودل الحقيقي
          messages.add(ChatMessageModel.fromJson(data));
        }
      } else {
        // في حال حدوث خطأ من السيرفر
        messages.add(ChatMessageModel(
            role: 'model',
            message: 'حدث خطأ أثناء الاتصال بالخادم، يرجى المحاولة لاحقاً.'
        ));
      }
    } catch (e) {
      messages.remove(placeholderMessage);
      messages.add(ChatMessageModel(
          role: 'model',
          message: 'تأكد من اتصالك بالإنترنت وأعد المحاولة.'
      ));
    } finally {
      scrollToBottom();
    }
  }

  // عمل Scroll لآخر رسالة تلقائياً
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../services/ServiceApi/ChatService.dart';
import 'ChatGemini_Model.dart';

class ChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  int? currentConversationId;

  // قائمة لتخزين معرفات المحادثات المحفوظة محلياً لعرضها في القائمة
  var savedConversationIds = <int>[].obs;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // تعريف مفتاح التخزين لـ GetStorage
  final _storage = GetStorage();
  final String _storageKey = 'local_chats';

  @override
  void onInit() {
    super.onInit();
    // تحميل المحادثات المحفوظة فور تشغيل الـ Controller
    _loadConversationsFromStorage();
  }

  // --- 1. تحميل قائمة المحادثات من الذاكرة المحلية ---
  void _loadConversationsFromStorage() {
    final localData = _storage.read<Map<String, dynamic>>(_storageKey);
    if (localData != null) {
      // جلب الـ IDs وترتيبها من الأحدث للأقدم
      var ids = localData.keys.map((e) => int.parse(e)).toList();
      ids.sort((a, b) => b.compareTo(a));
      savedConversationIds.assignAll(ids);
    }
  }

  // --- 2. حفظ الرسائل الحالية تلقائياً ومراعاة حد الـ 10 محادثات ---
  void _saveCurrentChatToStorage() {
    if (currentConversationId == null || messages.isEmpty) return;

    // قراءة البيانات القديمة أو إنشاء خريطة جديدة
    Map<String, dynamic> localData = _storage.read<Map<String, dynamic>>(_storageKey) ?? {};

    // تحويل الرسائل الحالية إلى JSON
    List<Map<String, dynamic>> jsonMessages = messages.map((msg) => msg.toJson()).toList();
    localData[currentConversationId.toString()] = jsonMessages;

    // التحقق من الحد الأقصى (آخر 10 محادثات فقط)
    if (localData.length > 10) {
      // ترتيب المفتاح للحصول على الأقدم وحذفه
      var sortedKeys = localData.keys.map((e) => int.parse(e)).toList()..sort();
      localData.remove(sortedKeys.first.toString());
    }

    // حفظ البيانات النهائية في GetStorage
    _storage.write(_storageKey, localData);
    _loadConversationsFromStorage(); // تحديث القائمة في الواجهة
  }

  // --- 3. الانتقال والرجوع لمحادثة محفوظة ---
  void loadConversation(int conversationId) {
    final localData = _storage.read<Map<String, dynamic>>(_storageKey);
    if (localData != null && localData.containsKey(conversationId.toString())) {
      currentConversationId = conversationId;

      // جلب الرسائل وتحويلها من JSON إلى Models
      List<dynamic> rawMsgs = localData[conversationId.toString()];
      List<ChatMessageModel> loadedMsgs = rawMsgs.map((m) => ChatMessageModel.fromJson(m)).toList();

      messages.assignAll(loadedMsgs);
      Get.back(); // إغلاق الـ Drawer الجانبي
      scrollToBottom();
    }
  }

  // --- 4. بدء محادثة جديدة وفصل الحالية ---
  void startNewChat() {
    messages.clear();
    currentConversationId = null;
    textController.clear();
    Get.back();
  }

  // --- 5. حذف محادثة معينة محلياً ---
  void deleteConversation(int conversationId) {
    Map<String, dynamic> localData = _storage.read<Map<String, dynamic>>(_storageKey) ?? {};
    localData.remove(conversationId.toString());
    _storage.write(_storageKey, localData);

    _loadConversationsFromStorage();

    // إذا كانت المحادثة المحذوفة هي المفتوحة حالياً، نفتح محادثة جديدة فارغة
    if (currentConversationId == conversationId) {
      messages.clear();
      currentConversationId = null;
    }
  }

  // --- 6. إرسال الرسالة ---
  Future<void> sendChatMessage() async {
    String userText = textController.text.trim();
    if (userText.isEmpty) return;

    final userMessage = ChatMessageModel(role: 'user', message: userText);
    messages.add(userMessage);
    textController.clear();
    scrollToBottom();

    final placeholderMessage = ChatMessageModel(role: 'model', message: '', isLoading: true);
    messages.add(placeholderMessage);
    scrollToBottom();

    try {
      final responseData = await ChatService.sendMessage(
        message: userText,
        conversationId: currentConversationId,
      );

      messages.remove(placeholderMessage);

      if (responseData != null && responseData['isSuccess'] == true) {
        final data = responseData['data'];
        if (data != null) {
          if (currentConversationId == null && data['conversation_id'] != null) {
            currentConversationId = data['conversation_id'];
          }

          messages.add(ChatMessageModel.fromJson(data));

          // حفظ التحديثات محلياً فور استقبال رد البوت بنجاح
          _saveCurrentChatToStorage();
        }
      } else {
        messages.add(ChatMessageModel(
            role: 'model',
            message: 'حدث خطأ أثناء الاتصال بالخادم، يرجى المحاولة لاحقاً.'
        ));
      }
    } catch (e) {
      messages.remove(placeholderMessage);
      messages.add(ChatMessageModel(
          role: 'model',
          message: 'تأكد من اتصالك بالإنترنت وأعد المحاولة.'
      ));
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}