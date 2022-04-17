
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/auth_page/auth_page.dart';
import '../pages/home/home_page.dart';
import '../utils/constants.dart';
import '../utils/firebase_constants.dart';
import '../utils/texts.dart';

class AuthController extends GetxController {
  var image = "".obs;
  var name = "".obs;
  var bio = "".obs;
  var mobile = "".obs;
  var location = "Please select the location".obs;

  static AuthController authInstance = Get.find();
  var isLoading = true.obs;
  late Rx<User?> firebaseUser;
  final TextEditingController _name = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  getUser() async {
    print(firebaseUser.value?.uid);
    await FirebaseFirestore.instance
        .collection("patients/HCID${firebaseUser.value?.uid}/PublicProfile")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        image.value = doc["image"];
        // name=doc["name"];
        // bio=doc["bio"];
        //mobile=doc["mobile"];
      });
    });
  }

  // getLoaction() {
  //   final uuid = AuthController.authInstance.firebaseUser.value?.uid;
  //   return Get.bottomSheet(
  //     StreamBuilder<QuerySnapshot>(
  //         stream: FirebaseFirestore.instance
  //             .collection("users").where("id",isEqualTo: "HCID${uuid}")
  //             .snapshots(),
  //         builder: (context, snapshot) {
  //           LocationController locationController =
  //           Get.put(LocationController());
  //
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Container(
  //                 child: Center(
  //                     child: CircularProgressIndicator(
  //                       color: Color(themeColor),
  //                     )));
  //           }
  //
  //           return ListView(
  //               children: snapshot.data!.docs.map<Widget>((element) {
  //                 print("location:${element['location']}");
  //                 TextEditingController _location2 = TextEditingController(
  //                     text: element['location'] == ""
  //                         ? ""
  //                         : "${element['location']}");
  //                 return Container(
  //                     color: Colors.white,
  //                     child: Column(
  //                       children: [
  //                         Container(
  //                           decoration:
  //                           const BoxDecoration(color: Color(themeColor2)),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Column(
  //                               children: [
  //                                 Row(
  //                                   mainAxisAlignment:
  //                                   MainAxisAlignment.spaceEvenly,
  //                                   children: [
  //                                     const Icon(
  //                                       Icons.my_location,
  //                                       color: Colors.black54,
  //                                     ),
  //                                     Text2(
  //                                         weigth: true,
  //                                         size: 0.02,
  //                                         text: "Location Permission is off",
  //                                         color: Colors.black54),
  //                                     GestureDetector(
  //                                       onTap: () {
  //                                         locationController.getUserLocation(element["user_type"]);
  //                                       },
  //                                       child: Container(
  //                                         decoration: BoxDecoration(
  //                                             color: const Color(themeColor),
  //                                             borderRadius:
  //                                             BorderRadius.circular(10)),
  //                                         child: Text1(
  //                                             text: "Grant",
  //                                             color: Colors.white,
  //                                             size: 20),
  //                                       ),
  //                                     )
  //                                   ],
  //                                 ),
  //                                 Text2(
  //                                     weigth: false,
  //                                     size: 0.015,
  //                                     text:
  //                                     "Granting permission will ensure accurate location and hassle free delivery",
  //                                     color: Colors.black54),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         Text1(
  //                             text: "Enter Location Manually",
  //                             color: Colors.black54,
  //                             size: 20),
  //                         IconTextForm(
  //                           iconName: const Icon(Icons.location_on),
  //                           name: "Location (city,pincode,state)",
  //                           controller: _location2,
  //                           max: 2,min: 1,
  //                         ),
  //                         Text1(
  //                             text: "Have you filled your Profile Details?",
  //                             color: Colors.black54,
  //                             size: 25),
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: GestureDetector(
  //                             onTap: () async {
  //                               await FirebaseFirestore.instance
  //                                   .collection('users')
  //                                   .doc("HCID${uuid}")
  //                                   .update({"location": _location2.text.trim()});
  //
  //                               element["user_type"]=="Patient"?await FirebaseFirestore.instance
  //                                   .collection("patients")
  //                                   .doc("HCID${firebaseUser.value?.uid}")
  //                                   .collection("PublicProfile")
  //                                   .doc(firebaseUser.value?.uid)
  //                                   .update({
  //                                 "location": _location2.text.trim(),
  //                               }):
  //                               element["user_type"]=="Doctor"?await FirebaseFirestore.instance
  //                                   .collection("doctor")
  //                                   .doc("HCID${firebaseUser.value?.uid}")
  //                                   .update({
  //                                 "doctor_location":_location2.text.trim(),
  //
  //                               }):
  //                               element["user_type"]=="Lab Tester"?await FirebaseFirestore.instance
  //                                   .collection("lab_tester")
  //                                   .doc("HCID${firebaseUser.value?.uid}")
  //                                   .update({
  //                                 "lab_location":_location2.text.trim(),
  //                               }):
  //                               element["user_type"]=="Hospital Management"?await FirebaseFirestore.instance
  //                                   .collection("hospital_management")
  //                                   .doc("HCID${firebaseUser.value?.uid}")
  //                                   .update({
  //                                 "hospital_location":_location2.text.trim(),
  //
  //                               }):
  //                               element["user_type"]=="Clinic"?await FirebaseFirestore.instance
  //                                   .collection("clinic_management")
  //                                   .doc("HCID${firebaseUser.value?.uid}")
  //                                   .update({
  //                                 "clinic_location":_location2.text.trim(),
  //
  //                               }):null;
  //
  //                               Get.back();
  //                               print(image);
  //                               print(name);
  //                             },
  //                             child: Container(
  //                               width: double.infinity,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 color: const Color(0xFF0C9869),
  //                               ),
  //                               child: Padding(
  //                                 padding: EdgeInsets.all(5),
  //                                 child: Center(
  //                                     child: Text1(
  //                                         text: "Yes,Proceed",
  //                                         color: Colors.white,
  //                                         size: 20)),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               Get.back();
  //                               Get.snackbar("Instruction",
  //                                   "Please fill the Personal,Public and Details in Profile Section",
  //                                   duration: const Duration(seconds: 3));
  //                             },
  //                             child: Container(
  //                               width: double.infinity,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 color: const Color(0xFF0C9869),
  //                               ),
  //                               child: Padding(
  //                                 padding: EdgeInsets.all(5),
  //                                 child: Center(
  //                                     child: Text1(
  //                                         text: "No",
  //                                         color: Colors.white,
  //                                         size: 20)),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ));
  //               }).toList());
  //         }),
  //     //barrierColor: Colors.red[50],
  //     isDismissible: true,
  //   );
  // }

  _setInitialScreen(User? user) async{
    if (user != null) {
      // user is logged in
      Get.offAll(() =>  HomePage());

    } else {
      // user is null as in user is not available or not logged in
      Get.offAll(() => AuthPage());
    }
  }

  void register(String name, String email, String password, String userType) async {
    try {
      //isLoading.value=true;
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value?.updateDisplayName(name);
      isLoading.value = false;


    } on FirebaseAuthException catch (e) {
      // this is solely for the Firebase Auth Exception
      // for example : password did not match
      print(e.message);
      // Get.snackbar("Error", e.message!);
      Get.snackbar(
        "Error",
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // this is temporary. you can handle different kinds of activities
      //such as dialogue to indicate what's wrong
      print(e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      //isLoading.value=false;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // print(user);
      // await user?.reload();
      isLoading.value = false;
      // print(user?.email);
      // print(user?.uid);
    } on FirebaseAuthException catch (e) {
      // this is solely for the Firebase Auth Exception
      // for example : password did not match
      Get.back();
      Get.snackbar("Errror", "${e.message}");
      print(e.message);
    } catch (e) {
      print(e.toString());
    }
  }

  void signOut() {
    try {
      auth.signOut();
      isLoading.value = false;
    } catch (e) {
      print(e.toString());
    }
  }
}
