import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/res/utils/utils.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';
import 'package:whatsapp_ui/service/storage_service.dart';
import 'package:whatsapp_ui/views/authentication/otp_screen.dart';
import 'package:whatsapp_ui/views/user_details/user_details.dart';

final authServiceProvider = Provider((ref) => AuthService(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthService({required this.auth, required this.firestore});

  void signInWithPhone(BuildContext context, String phone) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: (verificationId, forceResendingToken) async {
            Navigator.pushNamed(context, OtpScreen.route,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserDetails.route, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserData({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png";

      if (profilePic != null) {
        photoUrl = await ref
            .read(storageServiceProvider)
            .sendFile("profilePic/$uid", profilePic);
      }

      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNo: auth.currentUser!.phoneNumber!,
          groupId: []);

       await   firestore.collection("user").doc(uid).set(user.toMap());
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){return const MobileLayoutScreen();}), (route) => false);
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<UserModel?> getUserData() async {
    var userData = await firestore.collection("user").doc(auth.currentUser?.uid).get();
    UserModel? user;

    if(userData.data() !=null){
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> userStatus(String userId){
    return firestore.collection("user").doc(userId).snapshots().map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserStatus(bool isOnline) async{
    await firestore.collection("user").doc(auth.currentUser!.uid).update({
      "isOnline" : isOnline
    });

  }
}
