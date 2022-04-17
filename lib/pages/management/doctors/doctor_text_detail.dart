import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/reusable_widgets.dart';
import '../../../utils/texts.dart';

class DoctorTextDetail extends StatelessWidget {
  const DoctorTextDetail({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    print(id);




    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text1(text: "Edit Doctor Profile", color: Colors.black, size: 25),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("doctor")
                .where("id",isEqualTo: id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    child: Center(child: CircularProgressIndicator(color: Color(themeColor),)));
              }


              //if (snapshot.connectionState == ConnectionState.done) {
              //Map<String, dynamic> element = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Column(
                    children: snapshot.data!.docs.map<Widget>((element) {
                      TextEditingController _contactNumber = TextEditingController(text: element['doctor_contact_number']==""?"":"${element['doctor_contact_number']}");
                      TextEditingController _aboutYou = TextEditingController(text: element['about_you']==""?"":"${element['about_you']}");
                      TextEditingController _location = TextEditingController(text: element['doctor_location']==""?"":"${element['doctor_location']}");
                      TextEditingController _experience = TextEditingController(text: element['doctor_experience']==""?"":"${element['doctor_experience']}");
                      TextEditingController _fee = TextEditingController(text: element['doctor_fees']==""?"":"${element['doctor_fees']}");
                      TextEditingController _gender = TextEditingController(text: element['doctor_gender']==""?"":"${element['doctor_gender']}");
                      TextEditingController _name = TextEditingController(text: element['doctor_name']==""?"":"${element['doctor_name']}");
                      TextEditingController _specialization = TextEditingController(text: element['doctor_specialization']==""?"":"${element['doctor_specialization']}");
                      TextEditingController _onlineTime = TextEditingController(text: element['online_practice_time']==""?"":"${element['online_practice_time']}");
                      TextEditingController _offlineTime = TextEditingController(text: element['offline_practice_time']==""?"":"${element['offline_practice_time']}");
                      TextEditingController _otherServices = TextEditingController(text: element['other_services']==""?"":"${element['other_services']}");
                      TextEditingController _relatedHospital = TextEditingController(text: element['related_hospital']==""?"":"${element['related_hospital']}");

                      return Column(
                        children:   [
                          const SizedBox(height: 40,),

                          IconTextForm(iconName: const Icon(Icons.text_fields),name: "Practice Name",controller: _name,max: 3,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.edit),name: "About You",controller: _aboutYou,max: 3,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.phone),name: "Contact Number",controller: _contactNumber,max: 1,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.timeline_outlined),name: "Practice Experience",controller: _experience,max: 1,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.attach_money),name: "Practice Fees",controller: _fee,max: 1,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.male),name: "Gender",controller: _gender,max: 1,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.timer),name: "Offline Practice Time",controller: _offlineTime,max: 3,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.timer),name: "Online Practice Time",controller: _onlineTime,max: 3,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.medical_services_outlined),name: "Other Services",controller: _otherServices,max: 3,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.local_hospital),name: "Doctor's Related Hospital ",controller: _relatedHospital,max: 3,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.location_on),name: "Location ",controller: _location,max: 3,min: 1,),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: (){
                                //Get.toNamed("$page");
                                Get.defaultDialog(
                                    cancelTextColor: Color(themeColor),
                                    buttonColor: Color(themeColor),
                                    contentPadding: EdgeInsets.all(20),
                                    title: "Warning",
                                    content: Text("Are you sure you want to add ?"),
                                    onConfirm: () async{
                                      await FirebaseFirestore.instance.collection("users").
                                      doc(id).
                                      update({
                                        "name":_name.text.trim(),
                                        "location":_location.text.trim(),
                                      }).onError((error, stackTrace) => print(error));
                                      await FirebaseFirestore.instance.collection("doctor").
                                      doc(id).
                                      update({
                                        "doctor_name": _name.text.trim(),
                                        "doctor_gender":_gender.text.trim(),
                                        "doctor_experience":_experience.text.trim(),
                                        "about_you":_aboutYou.text.trim(),
                                        "doctor_contact_number":_contactNumber.text.trim(),
                                        "instituion_name":"",
                                        "medicail_degree_year":"",
                                        "doctor_certificate":"",
                                        "doctor_id_proof_front":"",
                                        "doctor_id_proof_back":"",
                                        "doctor_specialization":_specialization.text.trim(),
                                        "doctor_fees":_fee.text.trim(),
                                        "online_practice_time":_onlineTime.text.trim(),
                                        "offline_practice_time":_offlineTime.text.trim(),
                                        "consulting_duration":"",
                                        "other_services":_otherServices.text.trim(),
                                        "doctor_awards":"",
                                        "doctor_location":_location.text.trim(),
                                        "related_hospital":_relatedHospital.text.trim(),
                                      }).onError((error, stackTrace) => print(error));
                                      Get.back();
                                      Get.snackbar("Data Saved", "Your data has been save succesfully");
                                    },
                                    onCancel: () {
                                      Get.back();
                                    });},
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFF0C9869),
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.all(5),
                                  child: Center(
                                    child: Text("Save",style: GoogleFonts.saira(
                                        fontSize: MediaQuery.of(context).size.height < 800?15:20,
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1
                                    ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList()
                ),
              );

            }
        ),
      ),
    );

  }
}


