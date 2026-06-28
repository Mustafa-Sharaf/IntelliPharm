import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'ChatGemini_Controller.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.chatId,
    required this.isCurrent,
    required this.controller,
    required this.colors,
  });

  final int chatId;
  final bool isCurrent;
  final ChatController controller;
  final ThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.primaryColor.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => controller.loadConversation(chatId),
        leading: Icon(
          Icons.chat_bubble_outline,
          color: isCurrent ? AppColors.primaryColor : colors.textSecondary,
        ),
        title: Text(
          'Conversation #$chatId',
          style: TextStyle(
            color: isCurrent ? AppColors.primaryColor : colors.textPrimary,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Cairo',
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Color(0xffEF4444)),
          onPressed: () {
            Get.defaultDialog(
              title: "Delete Chat",
              titleStyle: TextStyle(
                color: colors.textPrimary,
                fontFamily: 'Cairo',
              ),
              middleText: "Are you sure you want to delete this conversation?",
              middleTextStyle: TextStyle(
                color: colors.textSecondary,
                fontFamily: 'Cairo',
              ),
              backgroundColor: colors.component,
              textCancel: "Cancel",
              textConfirm: "Delete",
              cancelTextColor: colors.textSecondary,
              confirmTextColor: Colors.white,
              buttonColor: const Color(0xffEF4444),
              onConfirm: () {
                controller.deleteConversation(chatId);
                Get.back();
              },
            );
          },
        ),
      ),
    );
  }
}
