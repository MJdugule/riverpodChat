import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/res/utils/utils.dart';
import 'package:whatsapp_ui/views/chat/chat_screen.dart';

final contactServiceProvider =
    Provider((ref) => ContactService(firestore: FirebaseFirestore.instance));

class ContactService {
  final FirebaseFirestore firestore;

  ContactService({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection("user").get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum = selectedContact.phones[0].number
            .replaceAll(" ", "")
            .replaceAll("(", "")
            .replaceAll(")", "");

        if (selectedPhoneNum == userData.phoneNo) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.route,
              arguments: {"name": userData.name, "uid": userData.uid});
        }

        if (!isFound) {
          showSnackBar(
              context: context,
              content: "This number in not registered on the app");
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
