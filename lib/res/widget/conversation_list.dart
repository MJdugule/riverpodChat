import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/controllers/chat_controller.dart';
import 'package:whatsapp_ui/models/conversation_model.dart';
import 'package:whatsapp_ui/res/widget/my_message_card.dart';
import 'package:whatsapp_ui/res/widget/sender_message_card.dart';

class ConversationList extends ConsumerStatefulWidget {
  final String receiverId;
  const ConversationList({required this.receiverId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConversationListState();
}

class _ConversationListState extends ConsumerState<ConversationList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConversationModel>>(
      stream: ref.read(chatControllerProvider).conversationList(widget.receiverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        SchedulerBinding.instance.addPostFrameCallback((_) { 
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final conversationDetails = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(conversationDetails.timeSent);
            if(!conversationDetails.isSeen && conversationDetails.receiverId == FirebaseAuth.instance.currentUser!.uid){
              ref.read(chatControllerProvider).updateSeenStatus(context, widget.receiverId, conversationDetails.messageId);
            }
            if (conversationDetails.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: conversationDetails.text,
                date: timeSent,
                type: conversationDetails.type,
                isSeen: conversationDetails.isSeen
              );
            }
            return SenderMessageCard(
              message: conversationDetails.text,
              date: timeSent,
              type: conversationDetails.type,
            );
          },
        );
      }
    );
  }
}


