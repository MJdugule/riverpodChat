import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/controllers/auth_controller.dart';
import 'package:whatsapp_ui/res/widget/app_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const route = "/login-screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text("Input your phone number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("We will need to verify your number"),
            const SizedBox(
              height: 10,
            ),
            TextButton(onPressed: () {
              showCountryPicker(context: context, onSelect: (Country _country){
                setState(() {
                  country = _country;
                });
              });
            }, child: const Text("Select Country")),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                if(country !=null)
                 Text("+${country!.phoneCode}"),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    decoration:  const InputDecoration(
                      hintText: 'phone number'
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.6,),
            SizedBox(
              width: 90,
              child: AppButton(text: "NEXT", onPressed: (){
                String phoneNumber = phoneController.text.trim();
                if(country != null && phoneNumber.isNotEmpty){
                  ref.read(authProvider).signInWithPhone(context, "+${country!.phoneCode}$phoneNumber");
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
