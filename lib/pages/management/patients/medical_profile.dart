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

class MedicalProfile extends StatelessWidget {
  const MedicalProfile({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    print(id);




    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text1(text: "Medical Profile", color: Colors.black, size: 25),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("patients/$id/MedicalProfile")
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
                      TextEditingController _allergies = TextEditingController(text: element["allergies"]==""?"":element["allergies"]);
                      TextEditingController _currentMedication = TextEditingController(text: element["current_medications"]==""?"":element["current_medications"]);
                      TextEditingController _pastMedication = TextEditingController(text: element["past_medication"]==""?"":element["past_medication"]);
                      TextEditingController _chronicDiseases = TextEditingController(text: element["chronic_diseases"]==""?"":element["chronic_diseases"]);
                      TextEditingController _injuries = TextEditingController(text: element["injuries"]==""?"":element["injuries"]);
                      TextEditingController _surgeries = TextEditingController(text: element["surgeries"]==""?"":element["surgeries"]);

                      return Column(
                        children:   [
                          const SizedBox(height: 40,),

                          IconTextForm(iconName: const Icon(Icons.coronavirus),name: "Allergies",controller: _allergies,max: 3,min: 1,),
                          IconTextForm(iconName: const Icon(Icons.medical_services),name: "Current Medications",controller: _currentMedication,max: 3,min: 1,),
                          IconTextForm(iconName: const Icon(Icons.medication_liquid),name: "Past Medication",controller: _pastMedication,max: 3,min: 1,),
                          IconTextForm(iconName: const Icon(Icons.add),name: "Chronic Diseases",controller: _chronicDiseases,max: 3,min: 1,),
                          IconTextForm(iconName: const Icon(Icons.personal_injury),name: "Injuries",controller: _injuries,max: 3,min: 1,),
                          IconTextForm(iconName: const Icon(Icons.cut),name: "Surgeries",controller: _surgeries,max: 3,min: 1,),
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
                                      FirebaseFirestore.instance.collection("patients").
                                      doc(id).collection("MedicalProfile").doc(id.substring(4)).
                                      set({
                                        "allergies":_allergies.text.trim(),
                                        "current_medications":_currentMedication.text.trim(),
                                        "past_medication":_pastMedication.text.trim(),
                                        "chronic_diseases":_chronicDiseases.text.trim(),
                                        "injuries":_injuries.text.trim(),
                                        "surgeries":_surgeries.text.trim(),
                                      });
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


