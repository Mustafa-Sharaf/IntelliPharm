
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../services/ServiceApi/ChatService.dart';
import 'ChatGemini_Model.dart';

class ChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  int? currentConversationId;
  var savedConversationIds = <int>[].obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final _storage = GetStorage();
  final String _storageKey = 'local_chats';

  @override
  void onInit() {
    super.onInit();
    _loadConversationsFromStorage();
  }

  void _loadConversationsFromStorage() {
    final localData = _storage.read<Map<String, dynamic>>(_storageKey);
    if (localData != null) {
      var ids = localData.keys.map((e) => int.parse(e)).toList();
      ids.sort((a, b) => b.compareTo(a));
      savedConversationIds.assignAll(ids);
    }
  }

  void _saveCurrentChatToStorage() {
    if (currentConversationId == null || messages.isEmpty) return;
    Map<String, dynamic> localData = _storage.read<Map<String, dynamic>>(_storageKey) ?? {};

    List<Map<String, dynamic>> jsonMessages = messages.map((msg) => msg.toJson()).toList();
    localData[currentConversationId.toString()] = jsonMessages;

    if (localData.length > 10) {
      var sortedKeys = localData.keys.map((e) => int.parse(e)).toList()..sort();
      localData.remove(sortedKeys.first.toString());
    }

    _storage.write(_storageKey, localData);
    _loadConversationsFromStorage();
  }

  void loadConversation(int conversationId) {
    final localData = _storage.read<Map<String, dynamic>>(_storageKey);
    if (localData != null && localData.containsKey(conversationId.toString())) {
      currentConversationId = conversationId;

      List<dynamic> rawMses = localData[conversationId.toString()];
      List<ChatMessageModel> loadedMses = rawMses.map((m) => ChatMessageModel.fromJson(m)).toList();

      messages.assignAll(loadedMses);
      Get.back();
      scrollToBottom();
    }
  }

  void startNewChat() {
    messages.clear();
    currentConversationId = null;
    textController.clear();
    Get.back();
  }

  void deleteConversation(int conversationId) {
    Map<String, dynamic> localData = _storage.read<Map<String, dynamic>>(_storageKey) ?? {};
    localData.remove(conversationId.toString());
    _storage.write(_storageKey, localData);

    _loadConversationsFromStorage();

    if (currentConversationId == conversationId) {
      messages.clear();
      currentConversationId = null;
    }
  }

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

          _saveCurrentChatToStorage();
        }
      } else {
        messages.add(ChatMessageModel(
            role: 'model',
            message: 'ًAn error occurred while connecting to the server. Please try again later.'
        ));
      }
    } catch (e) {
      messages.remove(placeholderMessage);
      messages.add(ChatMessageModel(
          role: 'model',
          message: 'Make sure you are connected to the internet and try again.'
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