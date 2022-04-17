import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../utils/reusable_widgets.dart';
import 'package:get/get.dart';

import '../../../utils/texts.dart';

class DoctorIdDetails extends StatefulWidget {
  final uid;

  const DoctorIdDetails(
      {Key? key,  this.uid})
      : super(key: key);

  @override
  State<DoctorIdDetails> createState() => _DoctorIdDetailsState();
}

class _DoctorIdDetailsState extends State<DoctorIdDetails> {
  final _tMformKey = GlobalKey<FormState>();
  String netUrlFront =
      "https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg";
  String netUrlBack =
      "https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg";

  @override


  @override
  Widget build(BuildContext context) {


    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.doc('doctor/${widget.uid}').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          try {
            netUrlFront =
            snapshot.data!.get("doctor_id_proof_front") == null
                ? ""
                : snapshot.data!.get("doctor_id_proof_front");
            netUrlBack =
            snapshot.data!.get("doctor_id_proof_back") == null
                ? ""
                : netUrlBack =
                snapshot.data!.get("doctor_id_proof_back");
          }
          catch(e) {
            return Center(child: Container(child : Text("No Addhar details found")));
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text1(text: "Doctor ID Proof", color: Colors.black, size: 25),
            ),
            body: Center(
              child: Form(
                key: _tMformKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text("Front Pic"),
                        CustomImageUploader(
                            imageHeight:
                            MediaQuery.of(context).size.height*0.5,
                            imageWidth:
                            MediaQuery.of(context).size.height*0.25,
                            networkImageUrl: netUrlFront,
                            path: 'Doctor/id_proof/${widget.uid}/frontAdhaar',
                            onPressed: (String string) {
                              Get.bottomSheet(Center(child: CircularProgressIndicator(color: Colors.white,),));
                              netUrlFront = string;
                              Get.back();
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Back Pic"),
                        CustomImageUploader(
                            imageHeight:
                            MediaQuery.of(context).size.height*0.5,
                            imageWidth:
                            MediaQuery.of(context).size.height*0.25,
                            networkImageUrl: netUrlBack,
                            path: 'Doctor/id_proof/${widget.uid}/backAdhaar',
                            onPressed: (String? string) {
                              Get.bottomSheet(Center(child: CircularProgressIndicator(color: Colors.white,),));
                              netUrlBack = string!;
                              Get.back();
                            }),
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
                                    _tMformKey.currentState!.save();
                                    FirebaseFirestore.instance
                                        .doc(
                                        'doctor/${widget.uid}')
                                        .update({
                                      'doctor_id_proof_back': netUrlBack,
                                      'doctor_id_proof_front': netUrlFront,
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
                                  child: Text("Update",style: GoogleFonts.saira(
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
                        // TextButton(
                        //     onPressed: () {
                        //       _tMformKey.currentState!.save();
                        //       FirebaseFirestore.instance
                        //           .doc(
                        //           'doctor/${widget.uid}')
                        //           .update({
                        //         'doctor_id_proof_back': netUrlBack,
                        //         'doctor_id_proof_front': netUrlFront,
                        //       });
                        //     },
                        //     child: const Text(
                        //       "Update",
                        //       style: TextStyle(
                        //           color: Colors.blue, fontWeight: FontWeight.bold),
                        //     ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );


  }
}
