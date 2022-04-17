import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/doctorController.dart';
import '../../../utils/texts.dart';

class DoctorSetting extends StatelessWidget{
  final AsyncSnapshot<DocumentSnapshot> query;
  DoctorSetting({required this.query});
  @override
  Widget build(BuildContext context) {

    return GetX<DoctorSettingController>(
        init:  DoctorSettingController(query: query),
        builder: (controller){
          TextEditingController name = TextEditingController(text: "${controller.doctorData.value.name}");
          TextEditingController location = TextEditingController(text: "${controller.doctorData.value.location}");
          TextEditingController mobile = TextEditingController(text: controller.doctorData.value.number==null?"null":"${controller.doctorData.value.number}");
          TextEditingController email = TextEditingController(text: "${controller.doctorData.value.email}");
          TextEditingController experience = TextEditingController(text: "${controller.doctorData.value.exp}");
          TextEditingController bio = TextEditingController(text: "${controller.doctorData.value.bio}");

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width*0.15
            ),
            child: Column(children: [
              AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text1(text: "Doctor Setting", color: Colors.black, size: 25),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){
                    if(controller.doctorData.value.edit==true){
                      controller.doctorData.update((val) {
                        val!.edit = false;
                      });

                      FirebaseFirestore.instance.doc('doctor/${query.data!['id']}').update({
                        'doctor_verified':controller.doctorData.value.verification,
                        'doctor_name':name.text,
                        'about_you':bio.text,
                        'doctor_contact_number':mobile.text ,
                        'doctor_location':location.text,
                        'doctor_email':email.text,
                        'doctor_experience':experience.text
                      });
                    }
                    else{
                      controller.doctorData.update((val) {
                        val!.edit = true;
                      });
                    }
                  }, child: Text(controller.doctorData.value.edit?"Save":"Edit" ))
                ],
              ),
              ListTile(
                title:  Text(
                  'Verification',
                ),
                trailing:  Switch(
                  value: controller.doctorData.value.verification,
                  onChanged: (bool state) {

                    controller.updateVerification(state);
                  },
                ),
              ),
              ListTile(
                  title: const Text(
                    'Name',
                  ),
                  trailing: SizedBox(
                    width: 200,
                    child: TextFormField(
                      enabled: controller.doctorData.value.edit,
                      decoration: const InputDecoration(
                          border: InputBorder.none
                      ) ,
                      controller: name,
                    ),
                  )

              ),
              ListTile(
                  title: const Text(
                    'Location',
                  ),
                  trailing: SizedBox(
                    width: 200,
                    child: TextFormField(
                      enabled: controller.doctorData.value.edit,
                      decoration: const InputDecoration(
                          border: InputBorder.none
                      ) ,
                      controller: location,
                    ),
                  )

              ),
              ListTile(
                  title: const Text(
                    'Experience',
                  ),
                  trailing: SizedBox(
                    width: 200,
                    child: TextFormField(
                      enabled: controller.doctorData.value.edit,
                      decoration: const InputDecoration(
                          border: InputBorder.none
                      ) ,
                      controller: experience,
                    ),
                  )

              ),
              ListTile(
                  title: const Text(
                    'Mobile',
                  ),
                  trailing: SizedBox(
                    width: 200,
                    child: TextFormField(
                      enabled: controller.doctorData.value.edit,
                      decoration: const InputDecoration(
                          border: InputBorder.none
                      ) ,
                      controller: mobile,
                    ),
                  )

              ),
              ListTile(
                  title: const Text(
                    'Email',
                  ),
                  trailing: SizedBox(
                    width: 200,
                    child: TextFormField(
                      enabled: controller.doctorData.value.edit,
                      decoration: const InputDecoration(
                          border: InputBorder.none
                      ) ,
                      controller: email,
                    ),
                  )

              ),
              ListTile(
                  title: const Text(
                    'About You',
                  ),
                  trailing: SizedBox(
                    width: 300,
                    height: 200,
                    child: TextFormField(
                      enabled: controller.doctorData.value.edit,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          border: InputBorder.none
                      ) ,
                      controller: bio,
                    ),
                  )

              ),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Get.defaultDialog(
                          contentPadding: EdgeInsets.all(20),
                          title: "Warning",
                          content: Text("Are you sure you want to remove ${query.data!['doctor_name']} ?"),
                          onConfirm: (){
                            FirebaseFirestore.instance.doc('doctor/${query.data!['id']}').delete();
                            Get.back();
                            Get.back();
                          },
                          onCancel: (){Get.back();}
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red,width: 2.0)
                      ),
                      child: Text("Delete Account"),
                    ),
                  )
                ],
              )
            ]),
          );
        });
  }

}

