import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/controllers/auth_controller.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/res/widget/chat_text_field.dart';
import 'package:whatsapp_ui/res/widget/conversation_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String route = "/mobile-chat";
  final String name;
  final String uid;
  const MobileChatScreen({Key? key, required this.name, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authProvider).userDataById(uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container();
            }
            return Column(
                children: [
                  Text(name),
                  Text(snapshot.data!.isOnline ? "online" : "offline",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal
                  ),)
                ],
              );
            }
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
           Expanded(
            child: ConversationList(
              receiverId: uid,
            ),
          ),
          ChatTextField(
            receiverUid: uid,
          ),
        ],
      ),
    );
  }
}


