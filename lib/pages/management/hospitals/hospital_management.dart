import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management/utils/responsive.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/utils/texts.dart';
import '../../../utils/constants.dart';

class HospitalManagement extends StatelessWidget {
  const HospitalManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity,Get.height*0.15),
          child: Card(
            color:Colors.green.shade100.withOpacity(0.6),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text1(text: "Hospital Management", color: const Color(themeColor), size: 30),
            ),
          )
      ),
      body:  StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('hospital').orderBy("hospital_joining_date",descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: Color(themeColor),));
            }
            if(snapshot.data!=null){
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveWidget.isSmallScreen(context)?1:ResponsiveWidget.isMobileLarge(context)?2:ResponsiveWidget.isMediumScreen(context)?4:ResponsiveWidget.isLargeScreen(context)?6:1,
                  childAspectRatio: ResponsiveWidget.isSmallScreen(context)?3:ResponsiveWidget.isMobileLarge(context)?2:ResponsiveWidget.isMediumScreen(context)?1.3:ResponsiveWidget.isLargeScreen(context)?1.1:1.1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.size,
                itemBuilder: (_,index){
                  Timestamp time = snapshot.data!.docs[index]["hospital_joining_date"];
                  DateTime t = time.toDate();
                  return GestureDetector(
                    onTap: (){
                      //print(snapshot.data!.docs[index]["hospital_name"]);
                      Get.toNamed('/home/${AppStrings.MANAGEMENT}/hospital_management/${snapshot.data!.docs[index]["hospital_name"]}'.replaceAll(" ", "%20"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(themeColor2)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text1(text: snapshot.data!.docs[index]["hospital_name"], color: Colors.black, size: 15),
                              Text(snapshot.data!.docs[index]["hospital_location"],),
                              const SizedBox(height: 5,),
                              Text("$t",),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },

              );
            }
            return SizedBox();
          }),
    );
  }
}
