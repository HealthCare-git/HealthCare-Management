import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../utils/reusable_widgets.dart';
import 'package:get/get.dart';

import '../../../utils/texts.dart';

class DoctorCertificateDetails extends StatefulWidget {
  final uid;

  const DoctorCertificateDetails(
      {Key? key,  this.uid})
      : super(key: key);

  @override
  State<DoctorCertificateDetails> createState() => _DoctorCertificateDetailsState();
}

class _DoctorCertificateDetailsState extends State<DoctorCertificateDetails> {
  final _tMformKey = GlobalKey<FormState>();
  String netUrl =
      "https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg";

  @override


  @override
  Widget build(BuildContext context) {


    return StreamBuilder(
        stream: FirebaseFirestore.instance.doc('doctor/${widget.uid}').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          print(snapshot.data!.get("doctor_certificate"));
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          try {
            netUrl =
            snapshot.data!.get("doctor_certificate") == null
                ? ""
                : snapshot.data!.get("doctor_certificate");
          }
          catch(e) {
            return const Center(child: Text("No Certificates details found"));
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text1(text: "Doctor Certificate", color: Colors.black, size: 25),
            ),
            body: Center(
              child: Form(
                key: _tMformKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text("Doctor Certificates"),
                        CustomImageUploader(
                            imageHeight:
                            MediaQuery.of(context).size.height*0.5,
                            imageWidth:
                            MediaQuery.of(context).size.height*0.5,
                            networkImageUrl: netUrl,
                            path: 'Doctor/${widget.uid}/certificate.jpg',
                            onPressed: (String string) {
                              Get.bottomSheet(Center(child: CircularProgressIndicator(color: Colors.white,),));
                              netUrl = string;
                              Get.back();
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ShowImage(
                                imageUrl: snapshot.data!.get("doctor_certificate"), name: 'Your Certificate',
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.remove_red_eye,color: Color(themeColor),),
                              Text1(text: "Preview Certificate", color: Color(themeColor), size: 20)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                                      'doctor_certificate': netUrl,
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
