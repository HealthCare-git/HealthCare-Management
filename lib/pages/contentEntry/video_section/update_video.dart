import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../utils/responsive.dart';
import '../medicine/add_delete_medicine.dart';
import 'controller/add_video_controller.dart';

class UpdateVideo extends StatefulWidget {
  final String video_key;
  final String  video_name;
  final String  video_category;
  final  String title;
  final  String about;
  final String video_id;
  final String  video_thumbnail;
  final  String live;
  //final String eventId;
  const UpdateVideo({Key? key,required this.video_key,required this.about, required this.video_name,required this.video_category,required this.title, required this.live, required this.video_id,required this.video_thumbnail,}) : super(key: key);
  @override
  State<UpdateVideo> createState() => _UpdateVideoState();
}


class _UpdateVideoState extends State<UpdateVideo> {
  // String image2 =
  //     'https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png';
  AddVideoController controller = Get.put(AddVideoController());

  @override
  Widget build(BuildContext context) {
    TextEditingController video_key = TextEditingController(text:widget.video_key);
    TextEditingController video_name = TextEditingController(text:widget.video_name);
    TextEditingController video_category = TextEditingController(text:widget.video_category);
    TextEditingController about = TextEditingController(text:widget.about);
    TextEditingController tittle = TextEditingController(text:widget.title);
    TextEditingController video_id = TextEditingController(text:widget.video_id);
    TextEditingController video_thumbnail = TextEditingController(text:widget.video_thumbnail);
    TextEditingController live = TextEditingController(text:widget.live);
    return Padding(
      padding: ResponsiveWidget.isSmallScreen(context)
          ? const EdgeInsets.all(0)
          : EdgeInsets.only(left: Get.width * 0.15, right: Get.width * 0.07),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  addCustomTextField(video_key, 'Video Key'),
                  addCustomTextField(video_name, 'Video Name'),
                  addCustomTextField(video_category, 'Video Category'),
                  addCustomTextField(about, 'About Video'),
                  addCustomTextField(tittle, 'Title'),
                  addCustomTextField(video_id, 'Video Id'),
                  addCustomTextField(video_thumbnail, 'Video Thumbnail'),
                  addCustomTextField(live, 'Live (true or false)'),

                  InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          contentPadding: EdgeInsets.all(20),
                          title: "Warning",
                          content: const Text("Are you sure you want to Update ?"),
                          onConfirm: () async{
                            await FirebaseFirestore.instance
                                  .doc(
                                  'inventory/all_videos/videos/${video_id.text.trim()}')
                                  .update({
                                'video_key' : video_key.text.trim(),
                                'about' : about.text.trim(),
                                'video_name' : video_name.text.trim(),
                                'tittle' :tittle.text.trim(),
                                'video_id' :video_id.text.trim(),
                                'video_thumbnail':video_thumbnail.text.trim(),
                                "live":live.text.trim(),
                                "timestamp":FieldValue.serverTimestamp(),
                              }).whenComplete(() => Get.back());

                              // await FirebaseFirestore.instance
                              //     .doc(
                              //     '/puja_purohit_tv/live_aarti/${video_id.text.trim()}')
                              //     .update({
                              //
                              //   'language' : int. parse(language.text.trim()) ,
                              //   'puja_key' : puja_key.text.trim(),
                              //   'channel_logo' : channel_logo.text.trim(),
                              //   'puja_name' : puja_name.text.trim(),
                              //   'tittle' :tittle.text.trim(),
                              //   'video_id' :video_id.text.trim(),
                              //   'video_thumbnail':video_thumbnail.text.trim(),
                              //   "live":live.text.trim(),
                              //   "timetamp":FieldValue.serverTimestamp(),
                              // });


                          },
                          onCancel: () {
                            Get.back();
                          });
                    },
                    child: redButton("Submit"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container redButton(String text) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red, width: 2.0)),
      child: Text(text),
    );
  }}

//   Widget addEventTextField(TextEditingController controller, hintText) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: TextFormField(
//           keyboardType: TextInputType.multiline,
//           maxLines: 10,
//           minLines: 1,
//           controller: controller,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blue, width: 1.0),
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             fillColor: Colors.grey,
//
//             hintText: hintText,
//
//             //make hint text
//             hintStyle: const  TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//               fontFamily: "verdana_regular",
//               fontWeight: FontWeight.w400,
//             ),
//
//             //create lable
//             labelText: hintText,
//             //lable style
//             labelStyle: const TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//               fontFamily: "verdana_regular",
//               fontWeight: FontWeight.w400,
//             ),
//           )),
//     );
//   }
// }

