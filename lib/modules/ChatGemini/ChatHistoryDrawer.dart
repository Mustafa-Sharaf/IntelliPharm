import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'ChatGemini_Controller.dart';
import 'ConversationTile.dart';

class ChatHistoryDrawer extends StatelessWidget {
  const ChatHistoryDrawer({
    super.key,
    required this.controller,
    required this.colors,
  });

  final ChatController controller;
  final ThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colors.backgroundMain,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: controller.startNewChat,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: colors.component,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: AppColors.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'New Chat',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: Obx(() {
                if (controller.savedConversations.isEmpty) {
                  return Center(
                    child: Text(
                      'No saved chats',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.savedConversations.length,
                  itemBuilder: (context, index) {
                    final chatId = controller.savedConversations[index];
                    final isCurrent =
                        controller.currentConversationId == chatId;

                    return ConversationTile(
                      chatId: chatId,
                      isCurrent: isCurrent,
                      controller: controller,
                      colors: colors,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
