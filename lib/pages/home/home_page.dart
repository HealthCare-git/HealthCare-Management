import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/pages/management/userManagementView.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../contentEntry/content_entry.dart';

class HomePage extends StatelessWidget{
  HomePage({Key? key,}) : super(key: key);
  String tab = Get.parameters['tab']!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: Get.height*0.11),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        leftTile(context,AppStrings.CONTENT_ENTRY,'Content Entry',LineIcons.user),
                        const SizedBox(height: 5,),
                        leftTile(context,AppStrings.MANAGEMENT,'Users Management',Icons.admin_panel_settings),
                        Divider(thickness: 2,height: 2,),

                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: Responsive.isDesktop(context)?4:6,
                child: Container(
                  margin: EdgeInsets.only(top: Get.height*0.1),
                  height: Get.height*0.9,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    child: tab == AppStrings.CONTENT_ENTRY? ContentEntryView(id: '',):UserManagementView(id: ''),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  ListTile leftTile(BuildContext context,String navigationTab,text,IconData iconData) {
    return ListTile(
      selected: tab==navigationTab,
      textColor: Get.isDarkMode ? Colors.white54:Colors.black54 ,
      selectedColor: Get.isDarkMode ? Colors.white:Colors.black,
      onTap: (){
        Get.toNamed('/home/$navigationTab');
      },
      iconColor:  Get.isDarkMode ? Colors.white54:Colors.black54,
      leading: Icon(iconData,),
      title:Responsive.isDesktop(context)?Text("$text"):null,
    );
  }
}

