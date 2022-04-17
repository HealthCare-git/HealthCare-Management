import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorSettingController extends GetxController{
  final AsyncSnapshot<DocumentSnapshot> query;
  DoctorSettingController({required this.query});

  @override
  void onInit() {
    super.onInit();

    updateDoctorData(query.data!['doctor_verified'], query.data!['doctor_name'],
        query.data!['about_you'],  query.data!['doctor_contact_number'], query.data!['doctor_experience'],
        query.data!['doctor_location'],query.data!['doctor_email']) ;
  }

  var doctorData = DoctorSettingData(verification: false, edit: false ).obs;

  updateDoctorData(bool verification, String name, String bio,String number,String experience,String location,dynamic email){

    doctorData.update((val) {
      val!.number = number;
      val.name = name;
      val.bio = bio;
      val.exp = experience;
      val.number =  number;
      val.location = location;
      val.email = email;
    });

  }
  updateVerification(bool verify){
    doctorData.update((val) {
      val!.verification = verify;
    });
  }
}

class DoctorSettingData{
  bool edit;
  bool verification;
  String? name ='';
  String? age ='';
  String? location= '';
  String? number = '';
  String? bio = '';
  String? exp='';
  String? mobile='';
  String? email='';
  DoctorSettingData({ required this.verification,required this.edit, this.email, this.mobile, this.name,this.exp, this.age,this.bio,this.number,this.location});
}