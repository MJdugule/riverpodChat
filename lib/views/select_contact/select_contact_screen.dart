import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/controllers/contact_controller.dart';
import 'package:whatsapp_ui/res/widget/error_widget.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String route = "/select-contact";
  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contact"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(getContactProvider).when(
          data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return ListTile(
                  title: Text(contact.displayName),
                );
              }),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
