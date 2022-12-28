import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/controllers/auth_controller.dart';
import 'package:whatsapp_ui/models/chat_list_model.dart';
import 'package:whatsapp_ui/models/conversation_model.dart';
import 'package:whatsapp_ui/res/utils/enums.dart';
import 'package:whatsapp_ui/service/chat_service.dart';

final chatControllerProvider = Provider((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatController(chatService: chatService, ref: ref);
});

class ChatController {
  final ChatService chatService;
  final ProviderRef ref;

  ChatController({required this.chatService, required this.ref});

  Stream<List<ChatListModel>> chatList(){
    return chatService.getChatList();
  }

  Stream<List<ConversationModel>> conversationList(String receiverId){
    return chatService.getConverstionList(receiverId);
  }

  void sendTextMessage(BuildContext context, String text, String receiverId) {
    ref.read(userDataProvider).whenData((value) => chatService.sendTextMessage(
        context: context,
        text: text,
        receiverId: receiverId,
        senderUser: value!));
  }

   void sendFileMessage(BuildContext context, File file, String receiverId, ChatEnum chatEnum) {
    ref.read(userDataProvider).whenData((value) => chatService.sendFileMessage(
        context: context,
        file: file,
        receiverId: receiverId,
        senderData: value!,
        chatEnum: chatEnum,
        ref: ref
        ));
  }

  void updateSeenStatus(
    BuildContext context,
    String receiverId,
    String messageId
  ){
    chatService.updateSeenStatus(receiverId, context, messageId);
  }
}
