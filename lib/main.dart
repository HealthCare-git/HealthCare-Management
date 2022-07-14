


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/pages/contentEntry/medicine/add_delete_medicine.dart';
import 'package:healthcare_management/pages/contentEntry/medicine/catagory_medicine.dart';
import 'package:healthcare_management/pages/contentEntry/notification/notifications.dart';
import 'package:healthcare_management/pages/contentEntry/post_section/view/post_tab_view.dart';
import 'package:healthcare_management/pages/contentEntry/video_section/video_tab.dart';
import 'package:healthcare_management/pages/home/home_page.dart';
import 'package:healthcare_management/pages/management/doctors/doctor_management.dart';
import 'package:healthcare_management/pages/management/doctors/doctor_user_detail.dart';
import 'package:healthcare_management/pages/management/patients/patient_management.dart';
import 'package:healthcare_management/pages/management/patients/patient_user_detail.dart';
import 'package:healthcare_management/pages/splash_screen.dart';
import 'package:healthcare_management/utils/constants.dart';
import 'package:healthcare_management/utils/firebase_constants.dart';
import 'package:healthcare_management/utils/theme.dart';

import 'controllers/authController.dart';

void main() async{
  //print('Translated: ${await "Здравствуйте. Ты в порядке?".translate(to: 'hi')}');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBnw2EAWDht1CtQTFR5ZfDpuYaUqPIegT0",
          authDomain: "healthcare-2c808.firebaseapp.com",
          projectId: "healthcare-2c808",
          storageBucket: "healthcare-2c808.appspot.com",
          messagingSenderId: "5028793711",
          appId: "1:5028793711:web:d9d3d8ad474a4aa981ec9a",
          measurementId: "G-GP7VTMLY09"
      )
  );

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      initialRoute: '/home/${AppStrings.CONTENT_ENTRY}',
      getPages: [

      GetPage(name: '/home/:tab', page: ()=>HomePage(),
      children: [
        GetPage(name: '/doctor_management', page: ()=>const DoctorManagement(),
          children: [
            GetPage(name: '/:id', page: ()=>DoctorUserDetails(),)
          ]
        ),
        GetPage(name: '/medicine', page:()=>MedicineAddDelete(),children: [
          GetPage(name: '/catagory', page: ()=>CatagoryMedicine(),)
        ]),
        GetPage(name: '/post/:tab', page: ()=>PostTab(),),
        GetPage(name: '/video/:tab', page:()=>VideoTab()),
        GetPage(
          name: '/notification',
          page: () => NotificationManager(),
        ),
        GetPage(name: '/patient_management', page: ()=>const PatientManagement(),
            children: [
              GetPage(name: '/:id', page: ()=>PatientUserDetails(),)
            ]
        ),
      ]),

      ],

    );

  }
}




