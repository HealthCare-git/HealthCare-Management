import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/pages/management/doctors/settings.dart';
import 'package:healthcare_management/pages/management/patients/personal_profile.dart';
import 'package:healthcare_management/pages/management/patients/public_profile.dart';
import 'package:healthcare_management/utils/constants.dart';

import 'medical_profile.dart';

class PatientUserDetails extends StatelessWidget{
  String id = Get.parameters['id']!;

  PatientUserDetails({Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = Get.height;
    double width = Get.width;
    return Scaffold(
      backgroundColor: context.theme.backgroundColor
      ,
      body: FutureBuilder(
          future: FirebaseFirestore.instance.doc('patients/$id/PublicProfile/${id.substring(4)}').get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.data==null){
              return Center(child: SizedBox(
                height: 50,width: 50,
                child: CircularProgressIndicator(color: !Get.isDarkMode?Colors.white:Colors.black54,),
              ),);
            }
            return  DefaultTabController(length: 3, child: Scaffold(
                backgroundColor: context.theme.backgroundColor,
                appBar: AppBar(
                  backgroundColor:Colors.transparent,
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Container(
                  ),
                  actions: [
                    TabBar(
                      labelStyle: GoogleFonts.aBeeZee(color:Colors.white),
                      labelColor: Get.isDarkMode?Colors.white:Colors.black54,
                      indicatorColor: Colors.orangeAccent,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator:const BubbleTabIndicator(

                        indicatorHeight: 25.0,
                        indicatorColor: Color(themeColor2),
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        // Other flags
                        // indicatorRadius: 1,
                        // insets: EdgeInsets.all(1),
                        // padding: EdgeInsets.all(10)
                      ),
                      tabs: const[
                        Tab(
                          text: 'Public Profile',
                        ),
                        Tab(
                          text: 'Personal Profile',
                        ),
                        Tab(
                          text: 'Medical Profile',
                        ),
                      ],
                    ),
                    CircleAvatar(
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: const[
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 8),
                                  blurRadius: 8)
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage("${snapshot.data!.get('image')}"))),
                      ),
                    )
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.4,
                              width: width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage('${snapshot.data!.get('image')}'),
                                      fit: BoxFit.fill
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SelectableText(
                              '${snapshot.data!.get('name')}',
                              style: TextStyle(fontSize: 20),
                              autofocus: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const  Icon(
                                  Icons.location_history,

                                  size: 14,
                                ),
                                const  SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    'Location : ${snapshot.data!.get('location')}',
                                    style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                )
                              ],
                            ),
                            SelectableText(
                              'Uid : ${snapshot.data!['id']}',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: 40,
                      // ),
                      Expanded(
                        flex: 4,
                        child: TabBarView(
                          children: [
                            PublicProfile(id: snapshot.data!.get('id'),),
                            PersonalProfile(id: snapshot.data!.get('id'),),
                            MedicalProfile(id: snapshot.data!.get('id'),),
                            // PujaOffering(asyncSnapshot: snapshot),
                            // PurohitBankDetails(uid: snapshot.data!['pandit_uid'],),
                            // PurohitUidaiDetails(uid: snapshot.data!['pandit_uid']),
                            // PurohitBasicDetailsForm(documentSnapshot: snapshot),
                            // Icon(Icons.directions_bike),
                            // PanditSetting(query: snapshot),
                          ],
                        ),
                      )
                    ],
                  ),
                )));
          }
      ),
    );
  }}

