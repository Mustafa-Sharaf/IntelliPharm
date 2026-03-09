
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/CustomTextField.dart';
import '../../Widgets/ForgotPasswordComponent.dart';
import '../../Widgets/Header_Screen.dart';
import '../../app_theme/AppColors.dart';
import 'SignIn_Controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderScreen(title: "SignIn".tr, body: "WelcomeBack".tr,),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            /// ===== FORM =====
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,),
              child: Column(
                children: [
                  CustomTextField(
                    label: "EmailAddress".tr,
                    icon: Icons.email_outlined,
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomTextField(
                    label: "Password".tr,
                    icon: Icons.lock_outline,
                    obscureText: true,
                    controller: controller.passwordController,
                  ),
                  ForgotPasswordComponent(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        onPressed: (){
                          Get.offAllNamed("/homeScreen");///Deletes all previous pages
                        },
                        child: Text(
                          "Log_In".tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’tHaveLoginCredentialsContactAdmin".tr,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            //fontWeight: FontWeight.w700,
                            fontFamily: 'Cairo',
                          )),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
