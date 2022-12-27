import 'package:whatsapp_ui/res/utils/enums.dart';

class ConversationModel {
  final String senderId;
  final String receiverId;
  final String text;
  final ChatEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  ConversationModel(
      {required this.senderId,
      required this.receiverId,
      required this.text,
      required this.type,
      required this.timeSent,
      required this.messageId,
      required this.isSeen});

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "text": text,
      "type": type.type,
      "timeSent": timeSent.millisecondsSinceEpoch,
      "messageId": messageId,
      "isSeen": isSeen,
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
        senderId: map["senderId"] ?? "",
        isSeen: map["isSeen"] ?? "",
        messageId: map["messageId"] ?? "",
        receiverId: map["receiverId"] ?? "",
        text: map["text"] ?? "",
        timeSent: DateTime.fromMillisecondsSinceEpoch(map["timeSent"]),
        type: (map["type"] as String).toEnum());
  }
}
