import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/pages/management/doctors/settings.dart';
import 'package:healthcare_management/utils/constants.dart';

import '../../../utils/responsive.dart';
import 'doctor_certificates.dart';
import 'doctor_id_proof.dart';
import 'doctor_text_detail.dart';

class DoctorUserDetails extends StatelessWidget{
  String id = Get.parameters['id']!;

  DoctorUserDetails({Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = Get.height;
    double width = Get.width;
    return Scaffold(
      backgroundColor: context.theme.backgroundColor
      ,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.doc('doctor/${id}').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.data==null){
              return Center(child: SizedBox(
                height: 50,width: 50,
                child: CircularProgressIndicator(color: !Get.isDarkMode?Colors.white:Colors.black54,),
              ),);
            }
            return  DefaultTabController(length: 6, child: Scaffold(
                backgroundColor: Colors.green.shade100.withOpacity(0.6),
                appBar: AppBar(
                  backgroundColor:Colors.transparent,
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Container(
                  ),
                  actions: [
                    TabBar(
                      labelStyle: GoogleFonts.aBeeZee(color:Colors.white,fontSize: ResponsiveWidget.isSmallScreen(context)?10:15),
                      labelColor: Get.isDarkMode?Colors.white:Colors.black54,
                      indicatorColor: const Color(themeColor2),
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: EdgeInsets.symmetric(horizontal: ResponsiveWidget.isSmallScreen(context)?8:10),

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
                          text: 'Detail',
                        ),
                        Tab(
                          text: 'Bank detail',
                        ),
                        Tab(
                          text: 'Addhar',
                        ),
                        Tab(
                          text: 'Certificates',
                        ),
                        Tab(
                          text: 'Appointment',
                        ),
                        Tab(
                          text: 'Actions',
                        )
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
                                image: NetworkImage("${snapshot.data!.get('doctor_image')}"))),
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
                              height: ResponsiveWidget.isSmallScreen(context)?height * 0.1:height * 0.4,
                              width: ResponsiveWidget.isSmallScreen(context)?width * 0.13:width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage('${snapshot.data!.get('doctor_image')}'),
                                      fit: BoxFit.fill
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: SelectableText(
                                      '${snapshot.data!.get('doctor_name')}',
                                      style: TextStyle(fontSize: ResponsiveWidget.isSmallScreen(context)?height*0.015:height*0.02),
                                      autofocus: true,
                                    )),
                                const SizedBox(
                                  width: 5,
                                ),
                                snapshot.data!.get('doctor_verified')!
                                    ? const Icon(
                                  Icons.verified,
                                  color: Color(themeColor),

                                  size: 14,
                                )
                                    : const Icon(
                                  Icons.verified,
                                  color: Colors.grey,
                                  size: 12,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                ResponsiveWidget.isSmallScreen(context)?Text(""):const  Icon(
                                  Icons.location_history,

                                  size: 14,
                                ),
                                const  SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    ResponsiveWidget.isSmallScreen(context)?
                                    '${snapshot.data!.get('doctor_location')}':
                                    'Location : ${snapshot.data!.get('doctor_location')}',
                                    style:
                                    TextStyle(fontSize: ResponsiveWidget.isSmallScreen(context)?height*0.012:height*0.018, color: Colors.grey),
                                  ),
                                )
                              ],
                            ),
                            SelectableText(
                              ResponsiveWidget.isSmallScreen(context)?
                              'Contact :\n${snapshot.data!['doctor_contact_number']}':
                              'Contact : ${snapshot.data!['doctor_contact_number']}',
                              style:
                              TextStyle(fontSize: ResponsiveWidget.isSmallScreen(context)?height*0.012:height*0.018, color: Colors.grey),
                              autofocus: true,
                            ),
                            ResponsiveWidget.isSmallScreen(context)?const Text(""):SelectableText(
                              'Uid : ${snapshot.data!['id']}',
                              style: TextStyle(fontSize: height*0.018, color: Colors.grey),
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
                            DoctorTextDetail(id:snapshot.data!['id']),
                            Icon(Icons.directions_bike),
                            DoctorIdDetails(uid:snapshot.data!['id']),
                            DoctorCertificateDetails(uid:snapshot.data!['id']),
                            Icon(Icons.directions_bike),
                            DoctorSetting(query: snapshot,)
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
                ))
            );
          }
      ),
    );
  }}

