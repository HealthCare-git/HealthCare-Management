import 'dart:html';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/pages/management/doctors/settings.dart';
import 'package:healthcare_management/utils/constants.dart';
import 'package:healthcare_management/utils/texts.dart';

import '../../../utils/responsive.dart';
import '../../../utils/reusable_widgets.dart';
import 'controller/hospital_department_controller.dart';

class HospitalDetails extends StatelessWidget{
  String name = Get.parameters['name']!;
  @override
  Widget build(BuildContext context) {
    DepartmentController departmentController=Get.put(DepartmentController());
    String mID = "HCID${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
    //print(name);
    double height = Get.height;
    double width = Get.width;
    return Scaffold(
        backgroundColor: Colors.green.shade100.withOpacity(0.6),
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation: 5.0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
          ),
          title: Text1(text: "Hospital Departments", color: Color(themeColor), size: 20),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('hospital/$name/department').snapshots(),
              builder: (context, snapshot1) {
                //print(snapshot1.data?.size);

                if(snapshot1.data?.size==0){
                  return Center(child: Text1(text: "No departments available yet", color: Colors.black54, size: 20));
                }

                if(snapshot1.data==null){
                  return Center(child: Text1(text: "Start your queries we will join you Shortly", color: Colors.black54, size: 20));
                }

                if(snapshot1.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                return ListView.builder(
                  //semanticChildCount: 10,
                  //scrollDirection: Axis.vertical,
                    //physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot1.data!.size,
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap:(){
                              Get.bottomSheet(
                                Obx(()=>
                                    Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topRight,
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(image: NetworkImage(departmentController.addUpcomingData.value.image)),
                                          ),
                                          child: TextButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text("Alert"),
                                                      content: const Text(
                                                          "Are you sure that you want to update this picture?"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: const Text("Cancel")),
                                                        TextButton(
                                                            onPressed: () {
                                                              FileUploadInputElement input =
                                                              FileUploadInputElement()
                                                                ..accept = 'image/*';
                                                              FirebaseStorage fs =
                                                                  FirebaseStorage.instance;
                                                              input.click();
                                                              input.onChange.listen((event) {
                                                                final file = input.files!.first;
                                                                final reader = FileReader();
                                                                reader.readAsDataUrl(file);
                                                                reader.onLoadEnd
                                                                    .listen((event) async {
                                                                  var snapshot = await fs
                                                                      .ref(
                                                                      'inventory/department/folder')
                                                                      .child('$mID')
                                                                      .putBlob(file);
                                                                  String downloadUrl =
                                                                  await snapshot.ref
                                                                      .getDownloadURL();
                                                                  departmentController.updateImage(downloadUrl);
                                                                  print(downloadUrl);
                                                                });
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: const Text("Continue")),
                                                      ],
                                                    ));
                                              },
                                              child: const Text("Edit")),
                                        ),
                                        InkWell(
                                            onTap: ()async{
                                              Get.defaultDialog(
                                                  title: "Warning",
                                                  content: const Text("Are you sure you want to add ?"),
                                                  onConfirm: () async{
                                                    Get.bottomSheet(
                                                        const Center(child: CircularProgressIndicator(color: Colors.white,),)
                                                    );
                                                    await FirebaseFirestore.instance.collection('hospital/$name/department').doc(snapshot1.data!.docs[index]['department']).update({
                                                      'department_image':departmentController.addUpcomingData.value.image,
                                                    }).whenComplete(() => Get.back());
                                                    Get.back();
                                                    Get.showSnackbar(const GetSnackBar(message: 'Medicine Added',duration: Duration(seconds: 2),));
                                                  },
                                                  onCancel: (){
                                                    Get.back();
                                                    Get.showSnackbar(const GetSnackBar(message: 'Medicine Canceled',duration: Duration(seconds: 2),));
                                                  }
                                              );

                                            },
                                            child: redButton('Submit')
                                        )
                                      ],
                                    ),
                                ),

                              );
                              //Get.to(DetailPage(name: snapshot.data!.docs[index]['medicine_name'],));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10,),
                                    snapshot1.data!.docs[index]['department_image']==""?
                                    Container(
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.orange.shade100),
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                          image: const DecorationImage(
                                              image: CachedNetworkImageProvider("https://firebasestorage.googleapis.com/v0/b/healthcare-2c808.appspot.com/o/common_assets%2Fno_hospital_and_clinic_image.png?alt=media&token=9e7716a4-77f9-49e7-84f4-ac9114b45643")
                                          )
                                      ),
                                    ):
                                    Container(
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.orange.shade100),
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(snapshot1.data!.docs[index]['department_image'])
                                          )
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text2(weigth: false, size: 0.016, text: snapshot1.data!.docs[index]['department'], color: Colors.black),
                                          const SizedBox(height: 10,),
                                          Text2(weigth: false, size: 0.016, text: "Doctor name : "+ snapshot1.data!.docs[index]['doctor_name'], color: Colors.black),
                                          const SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Text2(weigth: false, size: 0.016, text: "Department image available : ", color: Colors.black),
                                              snapshot1.data!.docs[index]['department_image']==""?
                                              Text2(weigth: true, size: 0.021, text: "No", color: Colors.red):
                                              Text2(weigth: true, size: 0.021, text: "Yes", color: Colors.green),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          Text2(weigth: true, size: 0.021, text: "Price : ${snapshot1.data!.docs[index]['doctor_fees']} ", color: Colors.black),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(thickness: 1,)
                        ],
                      );
                    });


              }
          ),
        ));
  }}

