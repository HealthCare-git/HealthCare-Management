import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/pages/contentEntry/video_section/controller/add_video_controller.dart';

import '../../../utils/reusable_widgets.dart';
import '../medicine/add_delete_medicine.dart';

class AddVideo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    AddVideoController addVideoController=Get.put(AddVideoController());
    TextEditingController video_key = TextEditingController();
    TextEditingController video_name = TextEditingController();
    TextEditingController video_category = TextEditingController();
    TextEditingController about = TextEditingController();
    TextEditingController tittle = TextEditingController();
    TextEditingController video_id = TextEditingController();
    TextEditingController video_thumbnail = TextEditingController();
    TextEditingController live = TextEditingController();
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [

              DropdownButton<String>(
                items: <String>[
                  'gym',
                  'yoga and meditation',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Obx(() => Text(addVideoController.typeOfVideo.value)),
                onChanged: (value) {
                  addVideoController.change(value);
                  print(addVideoController.typeOfVideo);
                },
              ),

              addCustomTextField(video_key, 'Video Key'),
              addCustomTextField(video_name, 'Video Name'),
              //addCustomTextField(video_category, 'Video Category'),
              addCustomTextField(about, 'About Video'),
              addCustomTextField(tittle, 'Title'),
              addCustomTextField(video_id, 'Video Id'),
              addCustomTextField(video_thumbnail, 'Video Thumbnail'),
              addCustomTextField(live, 'Live (true or false)'),

              const SizedBox(height: 20,),
              InkWell(
                  onTap: (){
                    Get.defaultDialog(
                        middleText: "Are you sure you want to add ${tittle.text} as New video",
                        onConfirm: (){
                          if(video_thumbnail.text.isEmpty || tittle.text.isEmpty || video_id.text.isEmpty){
                            Get.showSnackbar(const GetSnackBar(titleText: Text(''),messageText: Text('Please fill all fields properly'),duration: Duration(seconds: 2),));
                          }
                          else{

                            // live.text.trim()=="true"?FirebaseFirestore.instance.doc('PujaPurohitFiles/puja_purohit_tv/live_aarti/${video_id.text.trim()}').set({
                            //   'video_key' : video_key.text.trim(),
                            //   'video_name' : video_name.text.trim(),
                            //   'tittle' :tittle.text.trim(),
                            //   'video_id' :video_id.text.trim(),
                            //   'video_thumbnail':video_thumbnail.text.trim(),
                            //   "live":live.text.trim()=="false"?false:true,
                            //   "timetamp":FieldValue.serverTimestamp(),
                            // }):null;

                            FirebaseFirestore.instance.doc('inventory/all_videos/videos/${video_id.text.trim()}').set({
                              'video_key' : video_key.text.trim(),
                              'video_name' : video_name.text.trim(),
                              'about' : about.text.trim(),
                              "video_category":addVideoController.typeOfVideo.value,
                              'tittle' :tittle.text.trim(),
                              'video_id' :video_id.text.trim(),
                              'video_thumbnail':video_thumbnail.text.trim(),
                              "live":live.text.trim()=="false"?false:true,
                              "timestamp":FieldValue.serverTimestamp(),
                            }).whenComplete(() {
                              Get.back();
                            });
                          }
                        },
                        onCancel: (){
                          Get.back();
                        }
                    );
                  },
                  child: redButton('Submit'))
            ],
          ),
        ),
    );
  }

}