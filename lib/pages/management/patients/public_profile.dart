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

class PublicProfile extends StatelessWidget {
  const PublicProfile({Key? key, required this.id}) : super(key: key);
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
                .collection("patients/$id/PublicProfile")
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
                      TextEditingController _name = TextEditingController(text: element['name']==""?"":"${element['name']}");
                      TextEditingController _aboutYou = TextEditingController(text: element['bio']==""?"":"${element['bio']}");
                      TextEditingController _location = TextEditingController(text: element['location']==""?"":"${element['location']}");

                      return Column(
                        children:   [
                          const SizedBox(height: 40,),

                          IconTextForm(iconName: const Icon(Icons.text_fields),name: "Practice Name",controller: _name,max: 3,min: 1,),
                          const SizedBox(height: 10,),
                          IconTextForm(iconName: const Icon(Icons.edit),name: "About You",controller: _aboutYou,max: 3,min: 1,),
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
                                      await FirebaseFirestore.instance.collection("patients").
                                      doc(id).collection("PublicProfile").doc(id.substring(4)).
                                      update({
                                        "name":_name.text.trim(),
                                        "bio":_aboutYou.text.trim(),
                                        "location": _location.text.trim(),
                                      }).onError((error, stackTrace) => print(error));
                                      await FirebaseFirestore.instance.collection("patients").
                                      doc(id).
                                      update({
                                        "name":_name.text.trim(),
                                      }).onError((error, stackTrace) => print(error)).then((value) => Get.back());
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


