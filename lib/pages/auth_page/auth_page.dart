import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/authController.dart';
import '../../utils/constants.dart';
import '../../utils/reusable_widgets.dart';
import '../../utils/texts.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text1(text: "HealthCare", color: Color(themeColor), size: 50),
                Text2(weigth: false, size: 0.03, text: "We Care You, We Serve You", color: Colors.black)
              ],
            ),
          ),
          Column(
            children: [
              Text1(text: "welcome", color: Colors.black, size: 50),
              TextFormsEdited2(text: "Email",obsecure: false,labelText: "abc@gmail.com",con: emailController,),
              TextFormsEdited2(text: "Password",obsecure: false,labelText: "abc@gmail.com",con: passwordController,),
            ],
          ),
        ],
      ),
    );

  }
}







