import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/chat_message.dart';

const apiKey = "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";

class ApiController extends GetxController {
  final _isLoading = false.obs;
  final _isError = false.obs;
  final _errorMessage = ''.obs;
  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  String get errorMessage => _errorMessage.value;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  final baseUrl = Uri.https('api.openai.com', 'v1/completions');

  Map<String, String> header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $apiKey",
  };

  final _data = ''.obs;
  get data => _data.value;
  set data(value) => _data.value = value;
  void clearData() => _data.value = '';

  final _message = ''.obs;
  get message => _message.value;
  set message(value) => _message.value = value;
  void clearMessage() => _message.value = '';

  final _chatMessages = <ChatMessage>[].obs;
  List<ChatMessage> get chatMessages => _chatMessages;
  set chatMessages(value) => _chatMessages.value = value;

  @override
  void onInit() {
    // fetchData("Hello World");
    super.onInit();
  }

  @override
  void onReady() {
    // fetchData("hi");
    super.onReady();
  }

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future fetchData(String prompt) async {
    _isLoading.value = true;
    Get.snackbar('Loading', 'Please wait...');

    // add message to chat as sender type.
    _chatMessages.add(ChatMessage(
      message: prompt.trim(),
      chatMessageType: ChatMessageType.sender,
    ));
    Future.delayed(const Duration(milliseconds: 50)).then((_) => scrollDown());

    isLoading
        ? _chatMessages.add(ChatMessage(
            message: 'Loading, Please wait...',
            chatMessageType: ChatMessageType.bot,
          ))
        : null;

    textController.clear();
    try {
      final response = await http.post(baseUrl,
          headers: header,
          body: jsonEncode({
            "model": 'text-davinci-003',
            "prompt": prompt,
            "temperature": 0.3,
            "max_tokens": 2000,
            "top_p": 1.0,
            "frequency_penalty": 0.0,
            "presence_penalty": 0.0,
          }));

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        data = res["choices"][0]["text"];

        data != '' ? _chatMessages.remove(_chatMessages.last) : null;

        // add message to chat as bot type.
        _chatMessages.add(ChatMessage(
          message: data.trim(),
          chatMessageType: ChatMessageType.bot,
        ));
        Future.delayed(const Duration(milliseconds: 50))
            .then((_) => scrollDown());
      } else {
        _isError.value = true;
        _errorMessage.value = "Error: ${response.statusCode}";
      }
    } catch (e) {
      _isError.value = true;
      _errorMessage.value = "Error: $e";
    } finally {
      _isLoading.value = false;
    }
  }
}
