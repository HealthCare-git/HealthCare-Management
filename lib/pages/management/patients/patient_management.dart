import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management/utils/responsive.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/utils/texts.dart';
import '../../../utils/constants.dart';

class PatientManagement extends StatelessWidget {
  const PatientManagement({Key? key}) : super(key: key);

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
        title: Text1(text: "Patient Management", color: Colors.black, size: 20),
      ),
      body:  FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('patients').orderBy("patient_joining_date",descending: true).get(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(color: Color(themeColor),),
              );
            }
            if(snapshot.data!=null){
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveWidget.isMobileLarge(context)?1:ResponsiveWidget.isMobileLarge(context)?2:ResponsiveWidget.isMediumScreen(context)?4:ResponsiveWidget.isLargeScreen(context)?6:1,
                  childAspectRatio: ResponsiveWidget.isMobileLarge(context)?3:ResponsiveWidget.isMobileLarge(context)?2:ResponsiveWidget.isMediumScreen(context)?1.3:ResponsiveWidget.isLargeScreen(context)?1.1:1.1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.size,
                itemBuilder: (_,index){
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed('/home/${AppStrings.MANAGEMENT}/patient_management/${snapshot.data!.docs[index]["id"]}');
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
                            Text1(text: snapshot.data!.docs[index]["name"], color: Colors.black, size: 20),
                            Text2(weigth: false, size: 0.017, text: snapshot.data!.docs[index]["email"], color: Colors.black),
                            const SizedBox(height: 10,),
                            Text2(weigth: false, size: 0.012, text: snapshot.data!.docs[index]["id"], color: Colors.black),
                            // Text(snapshot.data!.docs[index]["name"],),
                            // Text(snapshot.data!.docs[index]["email"],),
                            // Text(snapshot.data!.docs[index]["id"],),
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
