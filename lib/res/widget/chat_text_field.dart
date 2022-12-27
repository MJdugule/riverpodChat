import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/controllers/chat_controller.dart';
import 'package:whatsapp_ui/res/utils/enums.dart';
import 'package:whatsapp_ui/res/utils/utils.dart';

class ChatTextField extends ConsumerStatefulWidget {
  final String receiverUid;
  const ChatTextField({
    Key? key,
    required this.receiverUid,
  }) : super(key: key);

  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  bool isShowSend = false;
  bool showEmoji = false;
  FocusNode focusNode = FocusNode();
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: messageController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isShowSend = true;
                    });
                  } else {
                    setState(() {
                      isShowSend = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (showEmoji) {
                                  showEmojiContainer();
                                }else{
                                  hideEmojiContainer();
                                }
                              },
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                              )),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            File? image = await pickImage(context);
                            if (image != null) {
                              ref.read(chatControllerProvider).sendFileMessage(
                                  context,
                                  image,
                                  widget.receiverUid,
                                  ChatEnum.image);
                            }
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            File? video = await pickVideo(context);
                            if (video != null) {
                              ref.read(chatControllerProvider).sendFileMessage(
                                  context,
                                  video,
                                  widget.receiverUid,
                                  ChatEnum.video);
                            }
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 2, left: 2),
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF128C7E),
                  radius: 25,
                  child: Icon(
                    isShowSend ? Icons.send : Icons.mic,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  if (isShowSend) {
                    ref.read(chatControllerProvider).sendTextMessage(
                        context, messageController.text.trim(), widget.receiverUid);
                    setState(() {
                      messageController.clear();
                    });
                  }
                },
              ),
            )
          ],
        ),
       showEmoji ? SizedBox(
          height: 310,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                messageController.text = messageController.text+emoji.emoji;
              });
              if(!isShowSend){
                setState(() {
                  isShowSend = true;
                });
              }
            },
          ),
        ): const SizedBox()
      ],
    );
  }

  void hideEmojiContainer(){
    setState(() {
      showEmoji = false;
    });
    focusNode.requestFocus();
  }

  void showEmojiContainer(){
    setState(() {
      showEmoji = true;
    });
    focusNode.unfocus();
  }
}
