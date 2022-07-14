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
                FunctionCards(
                  iconData: CupertinoIcons.tv_circle ,
                  text: 'Post',
                  ontap: (){
                  Get.toNamed('/home/${AppStrings.CONTENT_ENTRY}/post/up');
                },
                  color: Colors.teal.shade100.withOpacity(0.6),
                ),
                FunctionCards(iconData: CupertinoIcons.desktopcomputer,text: 'Events',ontap: (){},color: Colors.green.shade100.withOpacity(0.6),),
                FunctionCards(iconData: CupertinoIcons.percent,text: 'Offers',ontap: (){},color: Colors.blue.shade100.withOpacity(0.6),),
                FunctionCards(iconData: CupertinoIcons.news ,text: 'Health Feeds',
                    color: Colors.orange.shade100.withOpacity(0.6),
                    ontap:()async{

                }),
                FunctionCards(
                  color: Colors.purple.shade100.withOpacity(0.6),
                  iconData: Icons.medication,text: 'Medicines',
                  ontap: (){Get.toNamed('/home/${AppStrings.CONTENT_ENTRY}/medicine');},
                ),
                FunctionCards(
                  color: Colors.red.shade100.withOpacity(0.6),
                  iconData: CupertinoIcons.videocam ,text: 'Add Video',
                  ontap: (){Get.toNamed('/home/${AppStrings.CONTENT_ENTRY}/video/up');},),
                FunctionCards(
                  color: Colors.yellow.shade100.withOpacity(0.6),
                  iconData: CupertinoIcons.videocam ,text: 'Notifications',
                  ontap:(){
                    Get.toNamed('/home/${AppStrings.CONTENT_ENTRY}/notification');
                  },
                ),

              ],
            )
        )
    );
  }

}

