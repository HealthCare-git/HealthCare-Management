import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/reusable_widgets.dart';
import '../../../utils/texts.dart';
import 'package:get/get.dart';

class CatagoryMedicine extends StatelessWidget {
  const CatagoryMedicine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mID = "HCID${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
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
    var medicineDetail=Get.arguments;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity,Get.height*0.15),
          child: Card(
            color:Colors.green.shade100.withOpacity(0.6),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text1(text: medicineDetail, color:  const Color(themeColor), size: 30),
            ),
          )
      ),
      body: Container(
        height: Get.height,
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("inventory/medicines/folder").
            where("medicine_category",isEqualTo:medicineDetail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("no data"),
                );
              }

              if (snapshot.hasData) {
                return ListView.builder(
                  //semanticChildCount: 10,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (_, index) {
                      TextEditingController _medicinePrice = TextEditingController(text: snapshot.data!.docs[index]['medicine_actual_price'] );
                      TextEditingController _medicineName = TextEditingController(text: snapshot.data!.docs[index]['medicine_name'] );
                      TextEditingController _medicineDescription = TextEditingController(text: snapshot.data!.docs[index]['medicine_description'] );
                      TextEditingController _medicineMargin = TextEditingController(text: snapshot.data!.docs[index]['medicine_margin'] );
                      TextEditingController _medicineStorage = TextEditingController(text: snapshot.data!.docs[index]['medicine_storage'] );
                      TextEditingController _medicineSafety = TextEditingController(text: snapshot.data!.docs[index]['medicine_safety_information'] );
                      TextEditingController _medicinePackSize = TextEditingController(text: snapshot.data!.docs[index]['medicine_pack_size'] );
                      TextEditingController _medicineKeyIncrident = TextEditingController(text: snapshot.data!.docs[index]['medicine_key_ingredient'] );
                      TextEditingController _medicineUsage = TextEditingController(text: snapshot.data!.docs[index]['medicine_usage'] );
                      TextEditingController _medicineCategory = TextEditingController(text: snapshot.data!.docs[index]['medicine_category'] );
                      TextEditingController newMedicinePercentageIncreasePrice = TextEditingController(text: snapshot.data!.docs[index]['medicine_percentage_price_increased']);
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: ExpansionTile(
                            collapsedBackgroundColor: Color(themeColor2),
                            backgroundColor: Color(themeColor2),
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
                              addSamagriTextField(_medicinePackSize, "Selected Pack Size"),
                              addSamagriTextField(_medicineUsage, "How to use"),
                              addSamagriTextField(_medicineSafety, "Safety Information"),
                              addSamagriTextField(_medicineStorage, "Storage Information"),
                              addSamagriTextField(_medicineKeyIncrident, "Key Ingredient"),
                              addSamagriTextField(_medicineDescription, "Medicine Description"),
                              addSamagriTextField(_medicinePrice, "Medicine Price"),
                              addSamagriTextField(newMedicinePercentageIncreasePrice, "Percentage to increase %"),
                              addSamagriTextField(_medicineMargin, "Medicine margin"),
                              addSamagriTextField(_medicineCategory, "Medicine Type"),

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
                                                await FirebaseFirestore.instance.doc('/inventory/medicines/folder/${snapshot.data!.docs[index]['id']}').update({
                                                  'medicine_description':_medicineDescription.text.trim(),
                                                  'medicine_name' :_medicineName.text.trim().capitalizeFirst,
                                                  'medicine_actual_price' : _medicinePrice.text.trim(),
                                                  'medicine_percentage_price_increased' : newMedicinePercentageIncreasePrice.text.trim(),
                                                  'medicine_increased_price' : int.parse(_medicinePrice.text.trim())+(int.parse(_medicinePrice.text.trim())*int.parse(newMedicinePercentageIncreasePrice.text.trim())/100),
                                                  'medicine_margin': _medicineMargin.text.trim(),
                                                  'medicine_pack_size':_medicinePackSize.text.trim(),
                                                  'medicine_usage' :_medicineUsage.text.trim(),
                                                  'medicine_key_ingredient':_medicineKeyIncrident.text.trim(),
                                                  'medicine_safety_information' : _medicineSafety.text.trim(),
                                                  'medicine_storage': _medicineStorage.text.trim(),
                                                  //'medicine_image':medicineController.addUpcomingData.value.image,
                                                  'medicine_category':_medicineCategory.text.trim(),
                                                  //'medicine_vendors':[],
                                                  //"id":mID,

                                                }).whenComplete(() => Get.back());
                                                Get.back();
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
                                              await FirebaseFirestore.instance.doc('inventory/medicines/folder/${snapshot.data!.docs[index]['id']}').delete().whenComplete(() => Get.back());
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
                          ),
                        ),
                      );
                    });
              }
              return const Text("");
            }),
      ),
    );
  }
}
