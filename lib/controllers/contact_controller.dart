import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/service/contact_service.dart';

final getContactProvider = FutureProvider((ref){
  final contactServices = ref.watch(contactServiceProvider);
  return contactServices.getContacts();
});

final getSelectedContactProvider = Provider((ref){
  final selectContactService = ref.watch(contactServiceProvider);
  return ContactController(ref: ref, contactService: selectContactService);
});

class ContactController {
  final ProviderRef ref;
  final ContactService contactService;

  ContactController({required this.ref, required this.contactService});

  void selectedContact(Contact selectedContact, BuildContext context)  {
     contactService.selectContact(selectedContact, context);
  }
  
}