import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../utils/reusable_widgets.dart';
class ContentEntryView extends StatelessWidget{
  final String id;

  ContentEntryView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Wrap(
              children: [
                FunctionCards(iconData: CupertinoIcons.tv_circle ,text: 'Adds',ontap: (){},),
                FunctionCards(iconData: CupertinoIcons.desktopcomputer,text: 'Events',ontap: (){},),
                FunctionCards(iconData: CupertinoIcons.percent,text: 'Offers',ontap: (){},),
                FunctionCards(iconData: CupertinoIcons.news ,text: 'Health Feeds',ontap:()async{

                }),
                FunctionCards(iconData: Icons.medication,text: 'Medicines',ontap: (){
                  Get.toNamed('/home/${AppStrings.CONTENT_ENTRY}/medicine');
                },),

              ],
            )
        )
    );
  }

}

