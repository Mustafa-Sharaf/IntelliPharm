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
    final ChatController controller = Get.put(ChatController());
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.messages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   /* Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colors.component, //Color(0xff1A202C)
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.smart_toy_outlined,
                        color: colors.textSecondary, //Color(0xff94A3B8)
                        size: 80,
                      ),
                    ),*/
                    BotExpressiveAnimation(
                      containerColor: colors.component,
                      iconColor: colors.textSecondary,
                      size: 100,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'How can I help you today?',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      'Write your question below to get started',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                    color: isUser ? Colors.white : colors.textSecondary,
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
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
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

        ChatBottomInput(
          controller: controller,
          inputFieldColor: colors.component,
        ),
      ],
    );
  }
}
