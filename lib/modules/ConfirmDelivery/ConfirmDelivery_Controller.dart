import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../services/ApiService.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';

class ConfirmDeliveryController extends GetxController {
  final DeliveryVisit visit;
  ConfirmDeliveryController({required this.visit});
  final currentMapController = Get.find<MapHelperController>(tag: "routeDelivery");
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
      // تصغير أبعاد الصورة وتقليل الجودة لتقليل حجم الملف المرفوع
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      print("حدث خطأ أثناء فتح الكاميرا");

    }
  }

  Future<void> submitDelivery() async {
    //print(" CHECK BEFORE SUBMIT -> visit.id: ${visit.id}, visit.deliveryId: ${visit.deliveryId}");
    if (receiverNameController.text.trim().isEmpty) {
      AppSnackBar.error("Please enter the recipient's name".tr);
      return;
    }

    try {
      isSubmitting.value = true;
      final Map<String, dynamic> formDataMap = {
        "delivery_id": visit.deliveryId,
        "visit_id": visit.id,
        "receiver_name": receiverNameController.text.trim(),
        "payment_amount": paymentAmountController.text.trim().isEmpty ? "0.00" : paymentAmountController.text.trim(),
        "check_notes": notesController.text.trim().isEmpty ? "Customer was satisfied." : notesController.text.trim(),
        "current_latitude": currentMapController.latitude.value,
        "current_longitude": currentMapController.longitude.value,
      };
      //print("Sending Delivery Confirmation Request for delivery_id: ${visit.deliveryId}...");
     // print("Sending Delivery Confirmation Request for visit_id: ${visit.id}...");

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


      final response = await ApiService.post(
        "/planner/v1/deliveries/confirm-delivery",
        data: formData,
      );
      //print("RESPONSE DATA: ${response.data}");
      //print("STATUS CODE: ${response.statusCode}");
      bool isApiSuccess = false;

      if (response.data != null) {
        final resData = response.data as Map<String, dynamic>;
        isApiSuccess = resData['isSuccess'] == true ||
            resData['statusCode'] == 201 ||
            response.statusCode == 201;
      }

      if (isApiSuccess) {
        AppSnackBar.success("Delivery confirmed successfully".tr);

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
        AppSnackBar.error("Delivery confirmation failed".tr);
        isSubmitting.value = false;
      }
    } catch (e) {
      isSubmitting.value = false;
      if (e is dio.DioException) {
        if (e.type == dio.DioExceptionType.receiveTimeout || e.type == dio.DioExceptionType.sendTimeout) {
          AppSnackBar.error("The connection is very slow; the upload took longer than expected.".tr);
        } else if (e.response != null) {
          AppSnackBar.error("Invalid input data".tr);

          if (e.response?.data['message']?.toString().contains("already completed") == true) {
            await Future.delayed(const Duration(milliseconds: 800));
            if (Get.context != null) {
              Navigator.of(Get.context!).pop(true);
            } else {
              Get.back(result: true);
            }
          }
        } else {
          AppSnackBar.error("An error occurred while connecting to the server.".tr);
        }
      } else {
        print("Error confirming delivery: $e");
        AppSnackBar.error("An unexpected error occurred during the connection.".tr);
      }
    }
  }
}