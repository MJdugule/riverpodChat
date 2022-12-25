import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/service/contact_service.dart';

final getContactProvider = FutureProvider((ref){
  final contactServices = ref.watch(contactServiceProvider);
  return contactServices.getContacts();
});