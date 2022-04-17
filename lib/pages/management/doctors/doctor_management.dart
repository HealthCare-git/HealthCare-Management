import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management/utils/responsive.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/utils/texts.dart';
import '../../../utils/constants.dart';

class DoctorManagement extends StatelessWidget {
  const DoctorManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: const Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: Text1(text: "Doctor Management", color: Colors.black, size: 20),
      ),
      body:  FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('doctor').orderBy("doctor_joining_date",descending: true).get(),
    builder: (context, snapshot) {
    if(snapshot.data!=null){
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isMobile(context)?1:Responsive.isMobileLarge(context)?2:Responsive.isTablet(context)?4:Responsive.isDesktop(context)?6:1,
          childAspectRatio: Responsive.isMobile(context)?3:Responsive.isMobileLarge(context)?2:Responsive.isTablet(context)?1.3:Responsive.isDesktop(context)?1.1:1.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: snapshot.data!.size,
        itemBuilder: (_,index){
          return GestureDetector(
            onTap: (){
              Get.toNamed('/home/${AppStrings.MANAGEMENT}/doctor_management/${snapshot.data!.docs[index]["id"]}');
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(themeColor2)
                ),
                child: Column(
                  children: [
                    snapshot.data!.docs[index]["doctor_image"] == "" ? const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(themeColor2),
                      backgroundImage: AssetImage("user.png"),
                    ) : CircleAvatar(
                      radius: 50,
                      //backgroundColor: Color(themeColor2),
                      backgroundImage: CachedNetworkImageProvider(
                        '${snapshot.data!.docs[index]["doctor_image"]}',),
                    ),
                    Text(snapshot.data!.docs[index]["doctor_name"],),
                    Text(snapshot.data!.docs[index]["doctor_email"],),
                    Text(snapshot.data!.docs[index]["doctor_contact_number"],),
                  ],
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
