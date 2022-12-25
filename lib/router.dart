import 'package:flutter/material.dart';
import 'package:whatsapp_ui/res/widget/error_widget.dart';
import 'package:whatsapp_ui/views/authentication/login_screen.dart';
import 'package:whatsapp_ui/views/authentication/otp_screen.dart';
import 'package:whatsapp_ui/views/select_contact/select_contact_screen.dart';
import 'package:whatsapp_ui/views/user_details/user_details.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  switch(settings.name){
    case LoginScreen.route:
    return MaterialPageRoute(builder: (context) {
     return const LoginScreen();
    });
    case OtpScreen.route:
    final verificationId = settings.arguments as String;
    return MaterialPageRoute(builder: (context) {
     return  OtpScreen(verificationId: verificationId,);
    });
    case UserDetails.route:
    return MaterialPageRoute(builder: (context) {
     return  const UserDetails();
    });
    case SelectContactScreen.route:
    return MaterialPageRoute(builder: (context) {
     return  const SelectContactScreen();
    });
    default:
    return MaterialPageRoute(builder:(context) 
    { return const Scaffold(
      body: ErrorText(error: "This page doesn't exist")
    );});
  }
}