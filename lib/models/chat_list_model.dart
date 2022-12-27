class ChatListModel {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  ChatListModel(
      {required this.name,
      required this.profilePic,
      required this.contactId,
      required this.timeSent,
      required this.lastMessage});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "profilePic": profilePic,
      "contactId": contactId,
      "timeSent": timeSent.millisecondsSinceEpoch,
      "lastMessage": lastMessage,
    };
  }

  factory ChatListModel.fromMap(Map<String, dynamic> map) {
    return ChatListModel(
        name: map["name"] ?? "",
        profilePic: map["profilePic"] ?? "",
        contactId: map["contactId"] ?? "",
        timeSent: DateTime.fromMillisecondsSinceEpoch(map["timeSent"]),
        lastMessage: map["lastMessage"] ?? "");
  }
}
