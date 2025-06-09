import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/source/local/chat_message_model.dart';
import '../../data/source/remote/ai_webservices.dart';
import '../../core/utils/constant/ai_content.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  Box<ChatMessageModel>? _messagesBox;

  ChatCubit() : super(ChatInitial());

  Future<void> openMessagesBox() async {
    try {
      _messagesBox = await Hive.openBox<ChatMessageModel>(
          'chat_history_${FirebaseAuth.instance.currentUser?.uid}');
    } on HiveError catch (err) {
      log(err.message.toString());
    }
  }

  Future<void> initHive() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      await openMessagesBox();
      startListeningToMessages();
    } on HiveError catch (err) {
      log(err.message.toString());
    }
  }

  void startListeningToMessages() {
    try {
      List<ChatMessageModel> messages =
          _messagesBox?.values
              .toList()
              .reversed
              .toList() ?? [];
      emit(ChatReceiveSuccess(response: messages));
      _messagesBox?.watch().listen((event) {
        List<ChatMessageModel> updatedMessages =
            _messagesBox?.values
                .toList()
                .reversed
                .toList() ?? [];
        emit(ChatReceiveSuccess(response: updatedMessages));
      });
    } on HiveError catch (err) {
      log(err.message.toString());
    }
  }

  Future<void> sendMessage({required String message}) async {
    emit(ChatSenderLoading());
    try {
      final chatMessageModel = ChatMessageModel(
        isUser: true,
        message: message.trim(),
        timeTamp: dateTimeFormatter(),
      );
      await _messagesBox?.add(chatMessageModel);
      emit(ChatSendSuccess());
      await Future.delayed(const Duration(milliseconds: 350));

      emit(ChatReceiverLoading());

      final List<Content> content = [
        ...AiConstantsContent.content,
        ...(_messagesBox?.values
            .toList()
            .map((msg) => Content.text(msg.message))
            .toList() ??
            []),
      ];
      final response = await GenerativeAiWebService.postData(content: content);
      log(response.toString());
      await _messagesBox?.add(ChatMessageModel(
        isUser: false,
        message: response ?? "ERROR",
        timeTamp: dateTimeFormatter(),
      ));
      emit(ChatSendSuccess());
    } on HiveError catch (err) {
      emit(ChatFailure(message: err.message.toString()));
    }
  }

  Future<void> sendMessageAndWaitForResponse({required String message}) async {
    emit(ChatSenderLoading());
    try {
      final chatMessageModel = ChatMessageModel(
        isUser: true,
        message: message.trim(),
        timeTamp: dateTimeFormatter(),
      );
      await _messagesBox?.add(chatMessageModel);
      emit(ChatSendSuccess());
      final List<Content> content = [
        ...AiConstantsContent.content,
        ...(_messagesBox?.values
            .toList()
            .map((msg) => Content.text(msg.message))
            .toList() ??
            []),
      ];
      emit(ChatReceiverLoading());
      final response = await GenerativeAiWebService.postData(content: content);
      log(response.toString());

      await _messagesBox?.add(ChatMessageModel(
        isUser: false,
        message: response ?? "ERROR",
        timeTamp: dateTimeFormatter(),
      ));

      List<ChatMessageModel> messages =
          _messagesBox?.values
              .toList()
              .reversed
              .toList() ?? [];
      emit(ChatReceiveSuccess(response: messages));
    } on HiveError catch (err) {
      emit(ChatFailure(message: err.message.toString()));
    } catch (e) {
      emit(ChatFailure(message: e.toString()));
    }
  }

  Future<void> deleteAllMessages() async {
    emit(ChatDeletingLoading());
    try {
      await _messagesBox?.clear();
      emit(ChatDeleteSuccess());
    } on HiveError catch (err) {
      log(err.message.toString());
      emit(ChatDeleteFailure(message: "Failed to delete chat history: $err"));
    }
  }

  String dateTimeFormatter() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    String formattedDate = formatter.format(now);
    log(formattedDate);
    return formattedDate;
  }
}
