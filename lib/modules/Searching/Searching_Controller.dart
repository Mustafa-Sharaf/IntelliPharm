
import 'package:flutter/material.dart';


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
}
