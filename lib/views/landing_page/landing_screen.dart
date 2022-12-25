import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/res/widget/app_button.dart';
import 'package:whatsapp_ui/views/authentication/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const SizedBox(height: 50,),
        const Text("Welcome", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
      SizedBox(height: size.height/9  ,),
      const Padding(
        padding: EdgeInsets.all(15.0),
        child: Text("Read our Privacy Policy. Tap Continue to accept", style: TextStyle(color: greyColor),
        textAlign: TextAlign.center,
        ),
      ), 
      const SizedBox(height: 10,),
      SizedBox(
        width: size.width*0.75,
        child: AppButton(text: "CONTINUE", onPressed: (){
          Navigator.pushNamed(context, LoginScreen.route);
        }))
      ],)),
    );
  }
}