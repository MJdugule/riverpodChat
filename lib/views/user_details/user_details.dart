import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/controllers/auth_controller.dart';
import 'package:whatsapp_ui/res/utils/utils.dart';

class UserDetails extends ConsumerStatefulWidget {
  static const String route = "/user-details";
  const UserDetails({Key? key}) : super(key: key);

  @override
  ConsumerState<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends ConsumerState<UserDetails> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
               image == null ? const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage("https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png"),
                ) : CircleAvatar(
                  radius: 64,
                  backgroundImage: FileImage(image!),
                ),
                Positioned(
                    left: 80,
                    bottom: -10,
                    child: IconButton(
                        onPressed: () async{
                          image = await pickImage(context);
                          setState(() {
                            
                          });
                        }, icon: const Icon(Icons.add_a_photo)))
              ],
            ),
            Row(
              children: [
                Container(
                  width:  size.width*0.85,
                  padding:  const EdgeInsets.all(20),
                  child:  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      helperText: "Enter your name"
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  String name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    ref.read(authProvider).sendData(context, name, image);
                  }
                }, icon: const Icon(Icons.done))
              ],
            )
          ],
        ),
      )),
    );
  }
}
