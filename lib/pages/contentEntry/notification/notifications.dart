import 'dart:convert';
import 'dart:html';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/reusable_widgets.dart';


class NotificationManager extends StatelessWidget{
  //NotificationController notificationController=Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    TextEditingController Title = TextEditingController();
    TextEditingController SubTitle = TextEditingController();
    TextEditingController Body = TextEditingController();
    TextEditingController Route = TextEditingController();
    // String? app ='infopujapurohit';
    // String upcomingId =
        "UPID${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
    return Scaffold(
        body:Column(
              children: [
                // Container(
                //   alignment: Alignment.topRight,
                //   height: 100,
                //   width: 100,
                //   decoration: BoxDecoration(
                //     image: DecorationImage(image: NetworkImage(controller.addUpcomingData.value.image)),
                //   ),
                //   child: TextButton(
                //       onPressed: () {
                //         showDialog(
                //             context: context,
                //             builder: (context) => AlertDialog(
                //               title: const Text("Alert"),
                //               content: const Text(
                //                   "Are you sure that you want to update this picture?"),
                //               actions: [
                //                 TextButton(
                //                     onPressed: () {
                //                       Navigator.of(context).pop();
                //                     },
                //                     child: Text("Cancel")),
                //                 TextButton(
                //                     onPressed: () {
                //                       FileUploadInputElement input =
                //                       FileUploadInputElement()
                //                         ..accept = 'image/*';
                //                       FirebaseStorage fs =
                //                           FirebaseStorage.instance;
                //                       input.click();
                //                       input.onChange.listen((event) {
                //                         final file = input.files!.first;
                //                         final reader = FileReader();
                //                         reader.readAsDataUrl(file);
                //                         reader.onLoadEnd
                //                             .listen((event) async {
                //                           var snapshot = await fs
                //                               .ref(
                //                               'assets_folder/upcoming_events_folder')
                //                               .child('$upcomingId')
                //                               .putBlob(file);
                //                           String downloadUrl =
                //                           await snapshot.ref
                //                               .getDownloadURL();
                //                           controller.updateImage(downloadUrl);
                //
                //                         });
                //                       });
                //                       Navigator.of(context).pop();
                //                     },
                //                     child: Text("Continue")),
                //               ],
                //             ));
                //       },
                //       child: Text("Edit")),
                // ),

                addCustomTextField(Title, 'Title'),
                addCustomTextField(SubTitle, 'SubTitle'),
                addCustomTextField(Body, 'Body'),
                addCustomTextField(Route, 'Route'),
                SizedBox(height: 20,),
                // DropdownButton<String>(
                //   items: <String>[
                //     'infopujapurohit',
                //     'brahminapp',
                //     'vendors',
                //   ].map((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                //   hint: Obx(() => Text(notificationController.app.value)),
                //   onChanged: (value) {
                //     notificationController.change(value);
                //     print(notificationController.app.value);
                //   },
                // ),
                InkWell(
                    onTap: ()async{
                      await FirebaseMessaging.instance.subscribeToTopic('all');


                                Get.defaultDialog(
                          middleText: "Are you sure you want to add ${Title.text} as push notification",
                          onConfirm: ()async {
                            if(Title.text.isEmpty || SubTitle.text.isEmpty || Body.text.isEmpty){

                              Get.showSnackbar(const GetSnackBar(titleText: Text(''),messageText: Text('Please fill are fields properly'),duration: Duration(seconds: 2),));
                            }
                            else {
                              print(Body.text.trim()+SubTitle.text.trim()+Title.text.trim()+Route.text.trim());
            try {

            await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                "key=AAAAASu9TW8:APA91bFTTTDVNYK46ueswQZa9jXNqDwGOlqY52US1EXpSd5u_LXe-jbJRJWNGWFxRPlrDnv6ePDHWeLtaBXu1HEY6UhTaMREpvw9pofPDVyikYOEguEDGY3cLwniBptI6TReaswYR2E8"

            },
            body: jsonEncode(
            <String, dynamic>{
                "notification" : {
                "body" : Body.text.trim(),
                "content_available" : true,
                "priority" : "high",
                "subtitle":SubTitle.text.trim(),
                "title":Title.text.trim()
            },
            'priority': 'high',
            "data" : {
                "route":Route.text.trim(),
                "priority" : "high",
                "sound":"default",
                "content_available" : true,
                "bodyText" : "New Announcement assigned"
            },
              "to":"all"
            },),);
              print("notification send");
              Get.back();
              Get.snackbar("Done", "Successfully sent push notification");
            } catch (e) {
              print("error push notification");
              Get.back();
              Get.snackbar("Error", "Error sending push notification");

            }

                            }
                          },
                          onCancel: (){
                            Get.back();
                          }
                      );
                    },
                    child: redButton('Submit'))
              ],
           )
    );
  }
}