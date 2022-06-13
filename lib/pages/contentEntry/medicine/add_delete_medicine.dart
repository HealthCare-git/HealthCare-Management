import 'dart:html';
import 'dart:js';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/utils/constants.dart';
import 'package:healthcare_management/utils/texts.dart';

import '../../../utils/responsive.dart';
import 'medicine controller/medicine_controller.dart';

class MedicineAddDelete extends StatefulWidget {
  @override
  State<MedicineAddDelete> createState() => _MedicineAddDeleteState();
}

class _MedicineAddDeleteState extends State<MedicineAddDelete> {

  @override
  Widget build(BuildContext context) {

    MedicineController medicineController=Get.put(MedicineController());

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
    TextEditingController newMedicinePackSize =TextEditingController();
    TextEditingController newMedicineUsage =TextEditingController();
    TextEditingController newKeyIngredient =TextEditingController();
    TextEditingController newMedicineSafety = TextEditingController();
    TextEditingController newMedicineStorage = TextEditingController();
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
                                      Obx(()=>
                                          Container(
                                            alignment: Alignment.topRight,
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(image: NetworkImage(medicineController.addUpcomingData.value.image)),
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
                                                                        'inventory/medicines/folder')
                                                                        .child('$mID')
                                                                        .putBlob(file);
                                                                    String downloadUrl =
                                                                    await snapshot.ref
                                                                        .getDownloadURL();
                                                                    medicineController.updateImage(downloadUrl);
                                                                    print(downloadUrl);

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
                                      ),


                                      addCustomTextField(newMedicineName, "Medicine Name"),
                                      addSamagriTextField(newMedicinePackSize, "Selected Pack Size"),
                                      addSamagriTextField(newMedicineUsage, "How to use"),
                                      addSamagriTextField(newMedicineSafety, "Safety Information"),
                                      addSamagriTextField(newMedicineStorage, "Storage Information"),
                                      addSamagriTextField(newKeyIngredient, "Key Ingredients"),
                                      addSamagriTextField(newMedicineDescription, "Medicine Description"),
                                      addSamagriTextField(newMedicinePrice, "Medicine Price"),
                                      addSamagriTextField(newMedicineMargin, "Medicine margin"),
                                      DropdownButton<String>(
                                        items: <String>[
                                          'Covid Essentials',
                                          'Skin Care',
                                          'Vitamins and Minerals',
                                          'Sexual Wellness',
                                          'Health Eatables',
                                          'Baby Care',
                                          'Pain Relief',
                                          'Diabetic Care',
                                          'Hair Care',
                                          'Ayurvedic',
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        hint: Obx(() => Text(medicineController.typeOfMedicine.value)),
                                        onChanged: (value) {
                                          medicineController.change(value);
                                          print(medicineController.typeOfMedicine);
                                        },
                                      ),


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
                                                      'medicine_description':newMedicineDescription.text.trim(),
                                                      'medicine_name' :newMedicineName.text.trim().capitalizeFirst,
                                                      'medicine_price' : newMedicinePrice.text.trim(),
                                                      'medicine_margin': newMedicineMargin.text.trim(),
                                                      'medicine_pack_size':newMedicinePackSize.text.trim(),
                                                      'medicine_usage' :newMedicineUsage.text.trim(),
                                                      'medicine_key_ingredient':newKeyIngredient.text.trim(),
                                                      'medicine_safety_information' : newMedicineSafety.text.trim(),
                                                      'medicine_storage': newMedicineStorage.text.trim(),
                                                      'medicine_image':medicineController.addUpcomingData.value.image,
                                                      'medicine_category':medicineController.typeOfMedicine.value,
                                                      'medicine_vendors':[],
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
                            .collection("inventory/medicines/medicine_categorise")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(),
                              ),
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
                          // List<Widget> _medicineTypeCards = [];
                          // snapshot.data!.docs.forEach((element) {
                          if(snapshot.data!=null){
                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: ResponsiveWidget.isSmallScreen(context)?1:ResponsiveWidget.isMobileLarge(context)?2:ResponsiveWidget.isMediumScreen(context)?4:ResponsiveWidget.isLargeScreen(context)?6:1,
                                childAspectRatio: ResponsiveWidget.isSmallScreen(context)?3:ResponsiveWidget.isMobileLarge(context)?2:ResponsiveWidget.isMediumScreen(context)?1.1:ResponsiveWidget.isLargeScreen(context)?1:1.1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.size,
                              itemBuilder: (_,index){
                                return GestureDetector(
                                  onTap: (){
                                    Get.bottomSheet(
                                      Container(
                                        height: Get.height,
                                        color: Colors.white,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("inventory/medicines/folder").
                                            where("medicine_category",isEqualTo:snapshot.data!.docs[index]["name"])
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
                                                      TextEditingController _medicinePrice = TextEditingController(text: snapshot.data!.docs[index]['medicine_price'] );
                                                      TextEditingController _medicineName = TextEditingController(text: snapshot.data!.docs[index]['medicine_name'] );
                                                      TextEditingController _medicineDescription = TextEditingController(text: snapshot.data!.docs[index]['medicine_description'] );
                                                      TextEditingController _medicineMargin = TextEditingController(text: snapshot.data!.docs[index]['medicine_margin'] );
                                                      TextEditingController _medicineStorage = TextEditingController(text: snapshot.data!.docs[index]['medicine_storage'] );
                                                      TextEditingController _medicineSafety = TextEditingController(text: snapshot.data!.docs[index]['medicine_safety_information'] );
                                                      TextEditingController _medicinePackSize = TextEditingController(text: snapshot.data!.docs[index]['medicine_pack_size'] );
                                                      TextEditingController _medicineKeyIncrident = TextEditingController(text: snapshot.data!.docs[index]['medicine_key_ingredient'] );
                                                      TextEditingController _medicineUsage = TextEditingController(text: snapshot.data!.docs[index]['medicine_usage'] );
                                                      TextEditingController _medicineCategory = TextEditingController(text: snapshot.data!.docs[index]['medicine_category'] );
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
                                                                                await FirebaseFirestore.instance.doc('inventory/medicines/folder/${snapshot.data!.docs[index]['id']}').update({
                                                                                  'medicine_description':_medicineDescription.text.trim(),
                                                                                  'medicine_name' :_medicineName.text.trim().capitalizeFirst,
                                                                                  'medicine_price' : _medicinePrice.text.trim(),
                                                                                  'medicine_margin': _medicineMargin.text.trim(),
                                                                                  'medicine_pack_size':_medicinePackSize.text.trim(),
                                                                                  'medicine_usage' :_medicineUsage.text.trim(),
                                                                                  'medicine_key_ingredient':_medicineKeyIncrident.text.trim(),
                                                                                  'medicine_safety_information' : _medicineSafety.text.trim(),
                                                                                  'medicine_storage': _medicineStorage.text.trim(),
                                                                                  //'medicine_image':medicineController.addUpcomingData.value.image,
                                                                                  'medicine_category':_medicineCategory.text.trim(),
                                                                                  'medicine_vendors':[],
                                                                                  "id":mID,

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
                                              return Text("");
                                            }),
                                      ),
                                    );
                                    //Get.toNamed('/home/${AppStrings.MANAGEMENT}/doctor_management/${snapshot.data!.docs[index]["id"]}');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      // height: ResponsiveWidget.isSmallScreen(context)?70:150,
                                      // width: ResponsiveWidget.isSmallScreen(context)?70:150,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          //color:  Color(int.parse(snapshot.data!.docs[index]["bgcolor"]!))
                                        color: context.theme.backgroundColor,
                                      ),
                                      child: ResponsiveWidget.isSmallScreen(context)?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            height:  ResponsiveWidget.isSmallScreen(context)?20:100,
                                            width:  ResponsiveWidget.isSmallScreen(context)?20:100,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                              //image: NetworkImage(${snapshot.data!.docs[index]["image"]},),
                                                image: DecorationImage(
                                                  image: NetworkImage(snapshot.data!.docs[index]["image"],),
                                                ),
                                                color:  Color(int.parse(snapshot.data!.docs[index]["bgcolor"]!))
                                            ),

                                            //child: remove?Icon(Icons.delete_forever_outlined):null,
                                          ),
                                          // CircleAvatar(
                                          //   radius: 50,
                                          //   //backgroundColor: Color(themeColor2),
                                          //   backgroundImage: CachedNetworkImageProvider(
                                          //     '${snapshot.data!.docs[index]["image"]}',),
                                          // ),
                                          Text(snapshot.data!.docs[index]["name"],style: TextStyle(fontSize: ResponsiveWidget.isSmallScreen(context)?8:14)),

                                        ],
                                      ):
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.centerRight,
                                              height:  ResponsiveWidget.isSmallScreen(context)?20:100,
                                              width:  ResponsiveWidget.isSmallScreen(context)?20:100,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                                  //image: NetworkImage(${snapshot.data!.docs[index]["image"]},),
                                                  image: DecorationImage(
                                                    image: NetworkImage(snapshot.data!.docs[index]["image"],),
                                                  ),
                                                  color:  Color(int.parse(snapshot.data!.docs[index]["bgcolor"]!))
                                              ),

                                              //child: remove?Icon(Icons.delete_forever_outlined):null,
                                            ),
                                            Text(snapshot.data!.docs[index]["name"],style: TextStyle(fontSize: ResponsiveWidget.isSmallScreen(context)?8:14)),
                                            //Text1(text: snapshot.data!.docs[index]["name"], color: Colors.black, size: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },

                            );};
                            // _medicineTypeCards.add(
                            //     InkWell(
                            //       //hoverColor: Colors.white38,
                            //       onTap: (){},
                            //       child: Container(
                            //         margin: EdgeInsets.all(10),
                            //         //margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                            //         height: ResponsiveWidget.isSmallScreen(context)?70:150,
                            //         width: ResponsiveWidget.isSmallScreen(context)?70:150,
                            //         decoration: BoxDecoration(
                            //           color: context.theme.backgroundColor,
                            //           borderRadius: BorderRadius.circular(10),
                            //
                            //         ),
                            //         child: Column(
                            //           mainAxisAlignment: MainAxisAlignment.center,
                            //           children: [
                            //             Container(
                            //               alignment: Alignment.centerRight,
                            //               height:  ResponsiveWidget.isSmallScreen(context)?20:70,
                            //               width:  ResponsiveWidget.isSmallScreen(context)?20:70,
                            //               decoration: BoxDecoration(
                            //                 borderRadius: BorderRadius.circular(10),
                            //                 image: DecorationImage(image: NetworkImage(element["image"])),
                            //                 color: Color(int.parse(element["bgcolor"]!)),
                            //               ),
                            //
                            //               //child: remove?Icon(Icons.delete_forever_outlined):null,
                            //             ),
                            //             const SizedBox(height: 5,),
                            //             Text(element["name"],style: TextStyle(fontSize: ResponsiveWidget.isSmallScreen(context)?8:14))
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            // );
                          return SizedBox();
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