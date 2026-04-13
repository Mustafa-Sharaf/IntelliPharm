
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../AddOrder/AddOrder_Controller.dart';

class SearchControllerX {
  final TextEditingController textController = TextEditingController();
  final ValueNotifier<String> searchText = ValueNotifier('');

  final SpeechToText speech = SpeechToText();
  bool isListening = false;

  void onChanged(String value) {
    searchText.value = value;
  }

  Future<void> startListening() async {
    bool available = await speech.initialize();

    if (available) {
      isListening = true;

      String locale = "en_US";

      speech.listen(
        localeId: locale,
  /*      onResult: (result) {
          final text = result.recognizedWords;

          textController.text = text;
          searchText.value = text;

          Get.find<AddOrderController>()
              .onSearchChanged(text);
        },*/
        onResult: (result) {
          final text = result.recognizedWords.toUpperCase();

          textController.text = text;
          searchText.value = text;

          Get.find<AddOrderController>()
              .onSearchChanged(text);
        },
      );
    }
  }

  void stopListening() {
    speech.stop();
    isListening = false;
  }

  void clear() {
    textController.clear();
    searchText.value = '';
  }
}




/*
class SearchControllerX {
  final TextEditingController textController = TextEditingController();
  final ValueNotifier<String> searchText = ValueNotifier('');

  void onChanged(String value) {
    searchText.value = value;
  }

  void clear() {
    textController.clear();
    searchText.value = '';
  }

  void dispose() {
    textController.dispose();
    searchText.dispose();
  }
}*/
