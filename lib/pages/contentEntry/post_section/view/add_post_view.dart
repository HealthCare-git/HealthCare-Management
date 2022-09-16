import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/reusable_widgets.dart';
import '../../medicine/add_delete_medicine.dart';
import '../controller/add_post_controller.dart';

class AddPostView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController about = TextEditingController();
    String postId =
    "PID${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
   return Scaffold(
     body: GetX<AddPostController>(
       init: AddPostController(),
       builder: (controller){
       return Column(
       children: [
          Container(
                    alignment: Alignment.topRight,
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(controller.addUpcomingData.value.image)),
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
                                          child: Text("Cancel")),
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
                                                        'inventory/post_folder')
                                                    .child('$postId')
                                                    .putBlob(file);
                                                String downloadUrl =
                                                    await snapshot.ref
                                                        .getDownloadURL();
                                                  controller.updateImage(downloadUrl);      
                                               
                                              });
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Continue")),
                                    ],
                                  ));
                        },
                        child: Text("Edit")),
                  ),

                  addCustomTextField(name, 'Post Name'),
                  addCustomTextField(about, 'Route Post'),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){

                     Get.defaultDialog(
                       middleText: "Are you sure you want to add ${name.text} as upcoming event",
                       onConfirm: (){
                        if(name.text.isEmpty || about.text.isEmpty ){
                          Get.showSnackbar(const GetSnackBar(titleText: Text(''),messageText: Text('Please fill are fields properly'),duration: Duration(seconds: 2),));
                        }
                        else{
                          Get.bottomSheet(
                              const Center(
                                child: CircularProgressIndicator(color: Colors.white,),
                              )
                          );
                     FirebaseFirestore.instance.doc('inventory/post_folder/post/$postId').set({
                        'name' : name.text,
                        'route' : about.text,
                        'image' : controller.addUpcomingData.value.image,
                        'nick' : name.text,
                       "timestamp":FieldValue.serverTimestamp(),
                      }).whenComplete(() {
                       Get.back();
                     });
                     Get.back();
                        }
                       },
                       onCancel: (){
                         Get.back();
                       }
                     );
                    },
                    child: redButton('Submit'))
       ],
     );
   
     },)
   );
  }

}