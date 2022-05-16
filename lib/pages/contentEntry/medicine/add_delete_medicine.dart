import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/utils/constants.dart';
import 'package:healthcare_management/utils/texts.dart';

import '../../../utils/responsive.dart';

class MedicineAddDelete extends StatefulWidget {
  @override
  State<MedicineAddDelete> createState() => _MedicineAddDeleteState();
}

class _MedicineAddDeleteState extends State<MedicineAddDelete> {

  @override
  Widget build(BuildContext context) {

    // List<TextEditingController> _newName =
    // List.generate(11, (i) => TextEditingController());
    // List<Widget> _newNameTextFields = List.generate(
    //   11,
    //       (index) => addSamagriTextField(_newName[index], "Medicine Name $index"),
    // );
    // List<TextEditingController> _newDescription =
    // List.generate(11, (i) => TextEditingController());
    // List<Widget> _newDescriptionTextFields = List.generate(
    //   11,
    //       (index) => addSamagriTextField(_newDescription[index], "Medicine Description $index"),
    // );
    String mID = "HCID${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
    TextEditingController newMedicineName =TextEditingController();
    TextEditingController newMedicineDescription =TextEditingController();
    TextEditingController newMedicinePrice = TextEditingController();
    TextEditingController newMedicineMargin = TextEditingController();
    return Scaffold(
      body: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    Row(
                      children: [

                        Text2(text: "Medicine edit zone", color: const Color(themeColor), size: ResponsiveWidget.isSmallScreen(context)?0.02:0.03, weigth: true,),
                        const SizedBox(width: 20,),
                        const Icon(Icons.medication,size: 30,color: Color(themeColor),),
                        Spacer(),
                        TextButton(onPressed: (){
                          Get.bottomSheet(
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Get.width*0.1),
                                height: Get.height*0.9,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      addCustomTextField(newMedicineName, "Medicine Name"),
                                      addSamagriTextField(newMedicineDescription, "Medicine Description"),
                                      addSamagriTextField(newMedicinePrice, "Medicine Price"),
                                      addSamagriTextField(newMedicineMargin, "Medicine margin"),


                                      InkWell(
                                          onTap: ()async{
                                            // final List<String> names = await translate(newname.text);
                                            // final List<String> description = await translate(newdescription.text);

                                            if (newMedicineName.text.trim()!="" &&
                                                newMedicineDescription.text.trim()!="" &&
                                                newMedicinePrice.text.trim()!="" &&
                                                newMedicineMargin.text.trim()!=""){
                                              Get.defaultDialog(
                                                  title: "Warning",
                                                  content: const Text("Are you sure you want to add ?"),
                                                  onConfirm: () async{
                                                    Get.bottomSheet(
                                                        const Center(child: CircularProgressIndicator(color: Colors.white,),)
                                                    );
                                                    await FirebaseFirestore.instance.collection('inventory/medicines/folder').doc(mID).set({
                                                      'medicine_description':newMedicineDescription.text.trim().capitalize,
                                                      'medicine_name' :newMedicineName.text.trim(),
                                                      'medicine_price' : newMedicinePrice.text,
                                                      'medicine_margin': newMedicineMargin.text,
                                                      'medicine_vendors':[],
                                                      'medicine_picture':'',
                                                      "id":mID,

                                                    }).whenComplete(() => Get.back());
                                                    Get.back();
                                                    Get.showSnackbar(const GetSnackBar(message: 'Medicine Added',duration: Duration(seconds: 2),));
                                                  },
                                                  onCancel: (){
                                                    Get.back();
                                                    Get.showSnackbar(const GetSnackBar(message: 'Medicine Canceled',duration: Duration(seconds: 2),));
                                                  }
                                              );
                                            }
                                            else{
                                              Get.showSnackbar(const GetSnackBar(message: 'All Fields are mandatory to be filled!',duration: Duration(seconds: 2),));
                                            }




                                          },
                                          child: redButton('Submit')
                                      )

                                    ],
                                  ),
                                ),
                              ),
                              backgroundColor: context.theme.backgroundColor,
                              isScrollControlled: true
                          );
                        }, child: Text2(weigth: true, size: 0.017, text: "Add New", color: const Color(themeColor)))
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.07,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("inventory/medicines/folder")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data==null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                                //semanticChildCount: 10,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.size,
                                itemBuilder: (_, index) {
                                  TextEditingController _medicinePrice = TextEditingController(text: snapshot.data!.docs[index]['medicine_price'] );
                                  TextEditingController _medicineName = TextEditingController(text: snapshot.data!.docs[index]['medicine_name'] );
                                  TextEditingController _medicineDescription = TextEditingController(text: snapshot.data!.docs[index]['medicine_description'] );
                                  TextEditingController _medicineMargin = TextEditingController(text: snapshot.data!.docs[index]['medicine_margin'] );
                                  return ExpansionTile(
                                    title: Text(
                                        "${snapshot.data!.docs[index]['medicine_name']}"),
                                    trailing: const Text("Edit"),
                                    onExpansionChanged: (value) {
                                      snapshot.data!.docs.toList().forEach((element) {
                                        TextEditingController(text: "${snapshot.data!.docs[index]['medicine_name']}");
                                      });
                                    },
                                    children: [
                                      addCustomTextField(_medicineName, "Medicine Name"),
                                      addSamagriTextField(_medicineDescription, "Medicine Description"),
                                      addSamagriTextField(_medicinePrice, "Medicine Price"),
                                      addSamagriTextField(_medicineMargin, "Medicine margin"),

                                      Row(
                                        crossAxisAlignment:CrossAxisAlignment.center,
                                        mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              onTap: ()async{
                                                if (_medicineName.text.trim()!="" &&
                                                    _medicineDescription.text.trim()!="" &&
                                                    _medicinePrice.text.trim()!="" &&
                                                    _medicineMargin.text.trim()!=""){
                                                  Get.defaultDialog(
                                                      title: "Warning",
                                                      content: const Text("Are you sure you want to Update ?"),
                                                      onConfirm: () async{
                                                        Get.bottomSheet(
                                                            const Center(child: CircularProgressIndicator(color: Colors.white,),)
                                                        );
                                                        await FirebaseFirestore.instance.doc('inventory/medicines/folder/${snapshot.data!.docs[index]['id']}').update({
                                                          'medicine_description':_medicineDescription.text.trim().capitalize,
                                                          'medicine_name' :_medicineName.text.trim(),
                                                          'medicine_price' : _medicinePrice.text.trim(),
                                                          'medicine_margin': _medicineMargin.text.trim(),

                                                        }).whenComplete(() => Get.back());
                                                        Get.showSnackbar(const GetSnackBar(message: 'Medicine Updated',duration: Duration(seconds: 2),));
                                                      },
                                                      onCancel: (){
                                                        Get.back();
                                                        Get.showSnackbar(const GetSnackBar(message: 'Medicine Update Canceled',duration: Duration(seconds: 2),));
                                                      }
                                                  );

                                                }

                                              },
                                              child: redButton('Update')
                                          ),
                                          InkWell(
                                              onTap: ()async{
                                                Get.defaultDialog(
                                                  confirmTextColor: Colors.white,
                                                    title: "Warning",
                                                    content: const Text("Are you sure you want to Delete ?"),
                                                    onConfirm: () async{
                                                      await FirebaseFirestore.instance.doc('inventory/medicines/folder/${snapshot.data!.docs[index]['id']}').delete();
                                                      Get.showSnackbar(const GetSnackBar(message: 'Medicine Deleted',duration: Duration(seconds: 2),));
                                                    },
                                                    onCancel: (){
                                                      Get.back();
                                                      Get.showSnackbar(const GetSnackBar(message: 'Medicine Deletion Canceled',duration: Duration(seconds: 2),));
                                                    }
                                                );

                                              },
                                              child: redButton('Delete'))
                                        ],
                                      ),

                                    ],
                                  );
                                });
                          }
                          return Text("");
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
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
  Widget addSamagriTextField(TextEditingController controller, hintText) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        //textCapitalization: TextCapitalization.words,
          controller: controller,
          minLines: 1,
          maxLines: 10,  // allow user to enter 5 line in textfield
          keyboardType: TextInputType.multiline,
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
            hintStyle:const TextStyle(
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


Widget addCustomTextField(TextEditingController controller, hintText) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: TextFormField(
      textCapitalization: TextCapitalization.words,
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
          hintStyle: const TextStyle(
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