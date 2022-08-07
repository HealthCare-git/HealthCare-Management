import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/responsive.dart';
import '../controller/add_post_controller.dart';

class UpdatePost extends StatefulWidget {
  final String eventId;
  final String image;
  final String  updateName;
  final String  updateRoute;
  const UpdatePost({Key? key,required this.image,required this.eventId, required this.updateName,required this.updateRoute}) : super(key: key);
  @override
  State<UpdatePost> createState() => _UpdatePostState();
}


class _UpdatePostState extends State<UpdatePost> {
  bool tap=false;
  String image2 =
      'https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png';
  AddPostController controller = Get.put(AddPostController());

  @override
  Widget build(BuildContext context) {
    TextEditingController _name =TextEditingController(text:widget.updateName);
    TextEditingController _route =TextEditingController(text:widget.updateRoute);
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
                  Container(
                    alignment: Alignment.topRight,
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: tap==false?NetworkImage(widget.image):NetworkImage(image2)),
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
                                      child: const Text("Cancel")),
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
                                                .child('${widget.eventId}')
                                                .putBlob(file);
                                            String downloadUrl =
                                            await snapshot.ref
                                                .getDownloadURL();
                                            setState(() {

                                              image2 = downloadUrl;
                                              widget.image!=downloadUrl;
                                              tap=true;
                                              //widget.onPressed(downloadUrl);
                                              print("imag2 is:$image2");
                                              print("widget.image is:${widget.image}");
                                            });
                                          });
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Continue")),
                                ],
                              ));
                        },
                        child: const Text("Edit")),
                  ),
                addEventTextField(_name, "Update Name"),
                addEventTextField(_route, "Route "),

                  InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          contentPadding: EdgeInsets.all(20),
                          title: "Warning",
                          content: const Text("Are you sure you want to update ?"),
                          onConfirm: () {
                            FirebaseFirestore.instance
                                  .doc(
                                  'inventory/post_folder/post/${widget.eventId}')
                                  .update({
                                 'name':_name.text.trim(),
                                //'image': image2,
                                //"nick":widget.updateName,
                                'route' :_route.text.trim(),
                              }).whenComplete(() => Get.back());
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
  }

  Widget addEventTextField(TextEditingController controller, hintText) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          minLines: 1,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            fillColor: Colors.grey,

            hintText: hintText,

            //make hint text
            hintStyle: const  TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: "verdana_regular",
              fontWeight: FontWeight.w400,
            ),

            //create lable
            labelText: hintText,
            //lable style
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: "verdana_regular",
              fontWeight: FontWeight.w400,
            ),
          )),
    );
  }
}

