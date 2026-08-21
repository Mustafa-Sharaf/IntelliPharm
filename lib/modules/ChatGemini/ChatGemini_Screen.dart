import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'ChatBottomInput.dart';
import 'ChatGemini_Controller.dart';
import 'PulseBotAnimation.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;

    // استخدام Get.find بدلاً من Get.put داخل دالة build
    final ChatController controller = Get.find<ChatController>();

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      drawer: _buildHistoryDrawer(context, colors),
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.textPrimary),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: size.width * 0.03),
            Text(
              'IntelliPharma_AI'.tr,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BotExpressiveAnimation(
                        containerColor: colors.component,
                        iconColor: colors.textSecondary,
                        size: 100,
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'How_can_I_help_you_today'.tr,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        'Write_your_question_below_to_get_started'.tr,
                        style: TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isUser = msg.role == 'user';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colors.component,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.smart_toy_outlined,
                              color: colors.textSecondary,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? AppColors.primaryColor
                                  : colors.component,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isUser
                                    ? const Radius.circular(16)
                                    : const Radius.circular(4),
                                bottomRight: isUser
                                    ? const Radius.circular(4)
                                    : const Radius.circular(16),
                              ),
                            ),
                            child: msg.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    msg.message,
                                    style: TextStyle(
                                      color: isUser
                                          ? Colors.white
                                          : colors.textSecondary,
                                      fontSize: 12,
                                      height: 1.4,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                          ),
                        ),
                        if (isUser) ...[
                          SizedBox(width: size.width * 0.02),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          // تم الاستغناء عن تمرير Controller يدوياً
          ChatBottomInput(inputFieldColor: colors.component),
        ],
      ),
    );
  }

  Widget _buildHistoryDrawer(BuildContext context, ThemeColors colors) {
    //  جلب الكنترولر داخلياً
    final controller = Get.find<ChatController>();

    return Drawer(
      backgroundColor: colors.backgroundMain,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => controller.startNewChat(),
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
                      color: AppColors.primaryColor.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: AppColors.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'New_Chat'.tr,
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
            const Divider(color: Color(0xff1E293B), height: 1),
            Expanded(
              child: Obx(() {
                if (controller.savedConversationIds.isEmpty) {
                  return Center(
                    child: Text(
                      'No_local_history_found'.tr,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.savedConversationIds.length,
                  itemBuilder: (context, index) {
                    final id = controller.savedConversationIds[index];
                    final isCurrent = controller.currentConversationId == id;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.primaryColor.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        onTap: () => controller.loadConversation(id),
                        dense: true,
                        leading: Icon(
                          Icons.chat_bubble_outline,
                          color: isCurrent
                              ? AppColors.primaryColor
                              : colors.textSecondary,
                          size: 16,
                        ),
                        title: Text(
                          "CONVERSATION_ID".trParams({'id': id.toString()}),
                          style: TextStyle(
                            color: isCurrent
                                ? AppColors.primaryColor
                                : colors.textPrimary,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: 'Cairo',
                            fontSize: 13,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Color(0xffEF4444),
                            size: 16,
                          ),
                          onPressed: () => controller.deleteConversation(id),
                        ),
                      ),
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
