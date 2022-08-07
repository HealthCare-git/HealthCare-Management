import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../utils/reusable_widgets.dart';
class SupportView extends StatelessWidget{
  const SupportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Wrap(
          children: [
          FunctionCards(iconData: CupertinoIcons.text_bubble ,text: 'Support Chat',ontap: (){Get.toNamed('/home/${AppStrings.SUPPORT}/support-chat');}, color: Colors.yellow.shade100.withOpacity(0.6),),
          ],
        )
      )
    );
  }

}

