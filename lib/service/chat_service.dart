import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/models/chat_list_model.dart';
import 'package:whatsapp_ui/models/conversation_model.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/res/utils/enums.dart';
import 'package:whatsapp_ui/res/utils/utils.dart';
import 'package:whatsapp_ui/service/storage_service.dart';

final chatServiceProvider = Provider((ref) => ChatService(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatService({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatListModel>> getChatList() {
    return firestore
        .collection("user")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .snapshots()
        .asyncMap((event) async {
      List<ChatListModel> chatList = [];
      for (var document in event.docs) {
        var chatContact = ChatListModel.fromMap(document.data());
        var userData =
            await firestore.collection("user").doc(chatContact.contactId).get();
        var user = UserModel.fromMap(userData.data()!);

        chatList.add(ChatListModel(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return chatList;
    });
  }

  Stream<List<ConversationModel>> getConverstionList(String receiverId) {
    return firestore
        .collection("user")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("timeSent")
        .snapshots()
        .asyncMap((event) async {
      List<ConversationModel> messages = [];
      for (var document in event.docs) {
        messages.add(ConversationModel.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToSubCollection(UserModel senderData, UserModel receiverData,
      String text, DateTime timeSent, String receiverId) async {
    var receiverChat = ChatListModel(
        name: senderData.name,
        profilePic: senderData.profilePic,
        contactId: senderData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('user')
        .doc(receiverId)
        .collection("chats")
        .doc(auth.currentUser!.uid)
        .set(receiverChat.toMap());

    var senderChat = ChatListModel(
        name: senderData.name,
        profilePic: senderData.profilePic,
        contactId: senderData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .set(senderChat.toMap());
  }

  void _saveMessageCollection({
    required String receiverId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String receiverUsername,
    required ChatEnum chatType,
  }) async {
    final message = ConversationModel(
        senderId: auth.currentUser!.uid,
        receiverId: receiverId,
        text: text,
        type: chatType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);

    await firestore
        .collection("user")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection("user")
        .doc(receiverId)
        .collection("chats")
        .doc(auth.currentUser!.uid)
        .collection("messages")
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverData;
      var userDataMap =
          await firestore.collection("user").doc(receiverId).get();
      receiverData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToSubCollection(
          senderUser, receiverData, text, timeSent, receiverId);
      _saveMessageCollection(
          receiverId: receiverId,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUser.name,
          receiverUsername: receiverData.name,
          chatType: ChatEnum.text);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverId,
    required UserModel senderData,
    required ProviderRef ref,
    required ChatEnum chatEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref.read(storageServiceProvider).sendFile(
          'chat/${chatEnum.type}/${senderData.uid}/$receiverId/$messageId',
          file);

      UserModel receiverData;
      var userDataMap =
          await firestore.collection("user").doc(receiverId).get();
      receiverData = UserModel.fromMap(userDataMap.data()!);

      String msgType;
      switch (chatEnum) {
        case ChatEnum.image:
          msgType = "📸 Photo";
          break;
        case ChatEnum.video:
          msgType = "🎥 Video";
          break;
        case ChatEnum.audio:
          msgType = "🎵 Audio";
          break;
        case ChatEnum.gif:
          msgType = "GIF";
          break;
        default:
          msgType = "GIF";
      }

      _saveDataToSubCollection(
          senderData, receiverData, msgType, timeSent, receiverId);
      _saveMessageCollection(
          receiverId: receiverId,
          text: imageUrl,
          timeSent: timeSent,
          messageId: messageId,
          username: senderData.name,
          receiverUsername: receiverData.name,
          chatType: chatEnum);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void updateSeenStatus(
    String receiverId,
    BuildContext context,
    String messageId
  ) async {
    try {
      await firestore
        .collection("user")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc(messageId)
        .update({
          "isSeen" : true
        });

    await firestore
        .collection("user")
        .doc(receiverId)
        .collection("chats")
        .doc(auth.currentUser!.uid)
        .collection("messages")
        .doc(messageId)
        .update({
          "isSeen" : true
        });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
