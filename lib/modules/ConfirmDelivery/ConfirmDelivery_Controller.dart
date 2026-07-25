import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../services/ApiService.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';

class ConfirmDeliveryController extends GetxController {
  final DeliveryVisit visit;
  ConfirmDeliveryController({required this.visit});

  final receiverNameController = TextEditingController();
  final paymentAmountController = TextEditingController();
  final notesController = TextEditingController();

  final Rxn<File> selectedImage = Rxn<File>();
  final Rx<bool> isSubmitting = false.obs;

  @override
  void onClose() {
    receiverNameController.dispose();
    paymentAmountController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      AppSnackBar.error("حدث خطأ أثناء فتح الكاميرا");
    }
  }

  Future<void> submitDelivery() async {
    if (receiverNameController.text.trim().isEmpty) {
      AppSnackBar.error("الرجاء إدخال اسم المستلم");
      return;
    }

    try {
      isSubmitting.value = true;

      final Map<String, dynamic> formDataMap = {
        "delivery_id": visit.deliveryId,
        "visit_id": visit.id,
        "receiver_name": receiverNameController.text.trim(),
        "payment_amount": paymentAmountController.text.trim().isEmpty
            ? "0.00"
            : paymentAmountController.text.trim(),
        "check_notes": notesController.text.trim().isEmpty
            ? "Customer was satisfied."
            : notesController.text.trim(),
      };

      if (selectedImage.value != null) {
        final path = selectedImage.value!.path;
        final fileName = path.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();

        formDataMap["receipt_image"] = await dio.MultipartFile.fromFile(
          path,
          filename: fileName,
          contentType: MediaType("image", extension == "png" ? "png" : "jpeg"),
        );
      }

      final formData = dio.FormData.fromMap(formDataMap);

      print("Sending Delivery Confirmation Request...");
      final response = await ApiService.post(
        "/planner/v1/deliveries/confirm-delivery",
        data: formData,
      );

      bool isApiSuccess = false;

      if (response.data != null) {
        final resData = response.data as Map<String, dynamic>;
        isApiSuccess = resData['isSuccess'] == true ||
            resData['statusCode'] == 201 ||
            response.statusCode == 201;
      }

      if (isApiSuccess) {
        AppSnackBar.success("تم تأكيد التوصيل بنجاح");

        await Future.delayed(const Duration(milliseconds: 800));

        if (Get.context != null) {
          Navigator.of(Get.context!).pop(true);
        } else {
          Get.back(result: true);
        }
        return;
      } else {
        String errMsg = "فشل تأكيد التوصيل";
        if (response.data != null && response.data is Map) {
          errMsg = response.data['message'] ?? errMsg;
        }
        AppSnackBar.error(errMsg);
        isSubmitting.value = false;
      }
    } catch (e) {
      isSubmitting.value = false;
      if (e is dio.DioException && e.response != null) {
        print("SERVER VALIDATION ERROR DETAILS: ${e.response?.data}");
        final serverMessage = e.response?.data['message'] ?? "بيانات الإدخال غير صالحة";
        AppSnackBar.error(serverMessage);

        if (e.response?.data['message']?.toString().contains("already completed") == true) {
          await Future.delayed(const Duration(milliseconds: 800));
          if (Get.context != null) {
            Navigator.of(Get.context!).pop(true);
          } else {
            Get.back(result: true);
          }
        }
      } else {
        print("Error confirming delivery: $e");
        AppSnackBar.error("حدث خطأ غير متوقع أثناء الاتصال");
      }
    }
  }
}