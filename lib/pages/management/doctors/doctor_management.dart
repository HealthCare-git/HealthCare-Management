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
      appBar: PreferredSize(
          preferredSize: Size(double.infinity,Get.height*0.15),
          child: Card(
            color:Colors.green.shade100.withOpacity(0.6),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text1(text: "Doctor Management", color: const Color(themeColor), size: 30),
            ),
          )
      ),
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctor').orderBy("doctor_joining_date",descending: true).snapshots(),
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
                child: ResponsiveWidget.isSmallScreen(context)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    snapshot.data!.docs[index]["doctor_image"] == "" ?
                    CircleAvatar(
                      radius: ResponsiveWidget.isSmallScreen(context)?30:50,
                      backgroundColor: Color(themeColor2),
                      backgroundImage: AssetImage("user.png"),
                    ) : CircleAvatar(
                      radius: 50,
                      //backgroundColor: Color(themeColor2),
                      backgroundImage: CachedNetworkImageProvider(
                        '${snapshot.data!.docs[index]["doctor_image"]}',),
                    ),
                    Column(
                      children: [
                        Text1(text: snapshot.data!.docs[index]["doctor_name"], color: Colors.black, size: 20),
                        //Text(,),
                        Text(snapshot.data!.docs[index]["doctor_email"],),
                        Text(snapshot.data!.docs[index]["doctor_contact_number"],),
                      ],
                    )

                  ],
                ):
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      snapshot.data!.docs[index]["doctor_image"] == "" ? const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(themeColor2),
                        backgroundImage: AssetImage("user.png"),
                      ) : CircleAvatar(
                        radius: 40,
                        //backgroundColor: Color(themeColor2),
                        backgroundImage: CachedNetworkImageProvider(
                          '${snapshot.data!.docs[index]["doctor_image"]}',),
                      ),
                      Text1(text: snapshot.data!.docs[index]["doctor_name"], color: Colors.black, size: 20),
                      Text(snapshot.data!.docs[index]["doctor_email"],),
                      Text(snapshot.data!.docs[index]["doctor_contact_number"],),
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
