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

  // إرسال الرسالة
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
}