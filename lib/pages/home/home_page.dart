import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_management/pages/management/userManagementView.dart';
import 'package:healthcare_management/utils/texts.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../contentEntry/content_entry.dart';
import '../support/support_view.dart';

class HomePage extends StatelessWidget{
  HomePage({Key? key,}) : super(key: key);
  String tab = Get.parameters['tab']!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100.withOpacity(0.6),
      appBar:PreferredSize(
        preferredSize: Size(double.infinity,Get.height*0.15),
        child: Card(
          color:Colors.green.shade100.withOpacity(0.6),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: Get.height*0.2,
                  child: Image.asset("assets/logo1.png"),
                ),
                const SizedBox(width: 20,),
                Text1(text: "HealthCare Management Website", color: Color(themeColor), size: 30),
              ],
            ),
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
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
                          const SizedBox(
                            height: 5,
                          ),
                          leftTile(context, AppStrings.SUPPORT, 'Support',
                              Icons.support_agent),
                          //Divider(thickness: 2,height: 2,),

                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: ResponsiveWidget.isLargeScreen(context)?4:6,
                  child: Container(
                    margin: EdgeInsets.only(top: Get.height*0.1),
                    height: Get.height*0.9,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      child: tab == AppStrings.CONTENT_ENTRY? ContentEntryView(id: '',):tab == AppStrings.MANAGEMENT?UserManagementView(id: ''):SupportView(),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ListTile leftTile(BuildContext context,String navigationTab,text,IconData iconData) {
    return ListTile(
      selected: tab==navigationTab,
      selectedTileColor: Color(themeColor),
      textColor: Get.isDarkMode ? Colors.white54:Colors.black54 ,
      selectedColor: Get.isDarkMode ? Colors.white:Colors.white,
      onTap: (){
        Get.toNamed('/home/$navigationTab');
      },
      iconColor:  Get.isDarkMode ? Colors.white54:Colors.black54,
      leading: Icon(iconData,),
      title:ResponsiveWidget.isLargeScreen(context)?Text("$text"):null,
    );
  }
}

