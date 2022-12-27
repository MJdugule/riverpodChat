import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/service/auth_service.dart';

final authProvider = Provider((ref){
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService: authService, ref: ref);
});

final userDataProvider = FutureProvider((ref){
  final authController = ref.watch(authProvider);
  return authController.getUserDetails();
});

class AuthController{
  final AuthService authService;
  final ProviderRef ref;
  AuthController({required this.authService, required this.ref});

  void signInWithPhone(BuildContext context, String phone){
    authService.signInWithPhone(context, phone);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP){
    authService.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);
  }

  void sendData(BuildContext context, String name, File? profilePic){
    authService.saveUserData(name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Future<UserModel?> getUserDetails() async {
    UserModel? user = await authService.getUserData();
    return user;
  }

  Stream<UserModel> userDataById(String userId){
    return authService.userStatus(userId);
  }

  void  setUserStatus(bool isOnline){
    authService.setUserStatus(isOnline);
  }
}