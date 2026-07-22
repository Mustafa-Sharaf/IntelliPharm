import 'package:flutter/material.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import 'ChatGemini_Controller.dart';
import 'package:get/get.dart';

class ChatBottomInput extends StatelessWidget {
  final ChatController controller;
  final Color inputFieldColor;

  const ChatBottomInput({
    super.key,
    required this.controller,
    required this.inputFieldColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: inputFieldColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xff1E293B), width: 1.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => controller.sendChatMessage(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: "Cairo",
                    ),
                    cursorColor: AppColors.primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Write_your_question_here'.tr,
                      hintStyle: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            'Type_your_question_and_then_press_Enter_or_press_Submit'.tr,
            style: TextStyle(
              color: Color(0xff475569),
              fontSize: 11,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
