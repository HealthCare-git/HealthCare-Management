import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/reusable_widgets.dart';
import 'package:get/get.dart';

class UserManagementView extends StatelessWidget{
  final String id;
  UserManagementView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Wrap(
              children: [
                FunctionCards(color: Colors.teal.shade100.withOpacity(0.6),iconData: CupertinoIcons.person_alt_circle ,text: 'Patients',ontap: (){Get.toNamed('/home/${AppStrings.MANAGEMENT }/patient_management');},),
                FunctionCards(color: Colors.green.shade100.withOpacity(0.6),iconData: CupertinoIcons.person_badge_plus_fill ,text : 'Doctor',ontap: (){Get.toNamed('/home/${AppStrings.MANAGEMENT }/doctor_management');},),
                FunctionCards(color: Colors.orange.shade100.withOpacity(0.6),iconData: CupertinoIcons.house_alt_fill ,text: 'Hospital',ontap: (){Get.toNamed('/home/${AppStrings.MANAGEMENT }/hospital_management');},),
                FunctionCards(color: Colors.blue.shade100.withOpacity(0.6),iconData: CupertinoIcons.house_alt ,text: 'Clinics',ontap: (){},),
                FunctionCards(color: Colors.purple.shade100.withOpacity(0.6),iconData: CupertinoIcons.lab_flask ,text: 'Labs',ontap: (){},),


              ],
            )
        )
    );
  }

}

