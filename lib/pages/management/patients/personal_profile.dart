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

class PersonalProfile extends StatelessWidget {
  const PersonalProfile({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    print(id);




    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text1(text: "Personal Profile", color: Colors.black, size: 25),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("patients/$id/PersonalProfile")
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
                      TextEditingController _mobile = TextEditingController(text: element["mobile_number"]==""?"":element["mobile_number"]);
                      TextEditingController _gender = TextEditingController(text: element["gender"]==""?"":element["gender"]);

                      TextEditingController _bloodGroup = TextEditingController(text: element["blood_group"]==""?"":element["blood_group"]);
                      TextEditingController _height = TextEditingController(text: element["height"]==""?"":element["height"]);
                      TextEditingController _weight = TextEditingController(text: element["weight"]==""?"":element["weight"]);
                      TextEditingController _emergencyContact = TextEditingController(text: element["emergency_contact"]==""?"":element["emergency_contact"]);

                      return Column(
                        children:   [
                          const SizedBox(height: 40,),

                          IconTextForm(iconName: Icon(Icons.phone),name: "Mobile Number",controller: _mobile,max: 1,min: 1,),
                          IconTextForm(iconName: Icon(Icons.male),name: "Gender",controller: _gender,max: 1,min: 1,),

                          IconTextForm(iconName: Icon(Icons.bloodtype),name: "Blood Group",controller: _bloodGroup,max: 1,min: 1,),
                          IconTextForm(iconName: Icon(Icons.height),name: "Height (in feet)",controller: _height,max: 1,min: 1,),
                          IconTextForm(iconName: Icon(Icons.monitor_weight_rounded),name: "Weight (in kg)",controller: _weight,max: 1,min: 1,),
                          IconTextForm(iconName: Icon(Icons.phone_forwarded),name: "Emergency Contact",controller: _emergencyContact,max: 1,min: 1,),
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
                                    content: Text("Are you sure you want to Update ?"),
                                    onConfirm: () async{
                                      try{
                                        FirebaseFirestore.instance
                                            .collection("patients").
                                        doc(id).collection("PersonalProfile").doc(id.substring(4))
                                            .set({
                                          "mobile_number": _mobile.text.trim(),
                                          "gender": _gender.text.trim(),
                                          "blood_group": _bloodGroup.text.trim(),
                                          "height": "${_height.text.trim()} feet",
                                          "weight": "${_weight.text.trim()} kg",
                                          "emergency_contact":
                                          _emergencyContact.text.trim(),
                                        });
                                        Get.back();
                                        //Get.toNamed("/profile");
                                        Get.snackbar("Data Saved", "Your data has been save successfully");
                                      }catch(e){
                                        Get.snackbar("Error", "$e");
                                      }
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


