import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/ServiceApi/ChatService.dart';
import 'ChatGemini_Model.dart';


class ChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;

  // قائمة لتخزين العناوين أو أرقام المحادثات المحفوظة
  var savedConversations = <int>[].obs;

  var isLoading = false.obs;
  int? currentConversationId;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // هنا يمكنك استدعاء الـ API لجلب المحادثات المحفوظة للمستخدم عند تشغيل الواجهة
    _loadSavedConversations();
  }

  void _loadSavedConversations() {
    // محاكاة أو استدعاء حقيقي من الـ API لـ List of conversations
    // savedConversations.assignAll([41, 40, 39]);
  }

  // --- 1. بدء محادثة جديدة ---
  void startNewChat() {
    messages.clear();
    currentConversationId = null;
    textController.clear();
    Get.back(); // لإغلاق الـ Drawer بعد الضغط
  }

  // --- 2. الانتقال لمحادثة محفوظة ---
  void loadConversation(int conversationId) {
    currentConversationId = conversationId;
    messages.clear();

    // هنا تقوم باستدعاء الـ API الخاص بجلب رسائل هذه المحادثة تحديداً وعرضها
    // مثلاً: messages.assignAll(fetchedMessages);

    Get.back(); // إغلاق الـ Drawer
    scrollToBottom();
  }

  // --- 3. حذف محادثة ---
  void deleteConversation(int conversationId) {
    savedConversations.remove(conversationId);

    // استدعاء الـ API الخاص بحذف المحادثة من السيرفر إذا كان متوفراً
    // ChatService.deleteConversation(conversationId);

    // إذا حذف المستخدم المحادثة المفتوحة حالياً، نقوم بتصفير الشاشة
    if (currentConversationId == conversationId) {
      startNewChat();
    }
  }

  // إرسال الرسالة (تحديث بسيط لإضافة الـ ID للقائمة إذا كانت المحادثة جديدة)
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
            // إضافة المحادثة الجديدة لقائمة المحادثات المحفوظة
            savedConversations.insert(0, currentConversationId!);
          }
          messages.add(ChatMessageModel.fromJson(data));
        }
      } else {
        messages.add(ChatMessageModel(role: 'model', message: 'حدث خطأ أثناء الاتصال بالخادم.'));
      }
    } catch (e) {
      messages.remove(placeholderMessage);
      messages.add(ChatMessageModel(role: 'model', message: 'تأكد من اتصالك بالإنترنت.'));
    } finally {
      scrollToBottom();
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
}