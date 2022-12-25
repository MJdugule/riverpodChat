import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/controllers/auth_controller.dart';

class OtpScreen extends ConsumerWidget {
  static const String route = "/otp-screen";
  final String verificationId;
  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text("Verify your phone number"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text("We have sent an SMS with the code"),
            SizedBox(
              width: size.width*0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration:  const InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(fontSize: 30),
                ),
                onChanged: (value) {
                  if(value.length == 6){
                    ref.read(authProvider).verifyOTP(context, verificationId, value.trim());
                  }
                  
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}